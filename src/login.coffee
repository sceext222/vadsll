# login.coffee, vadsll/src/

async_ = require './async'
util = require './util'
config = require './config'
packet_util = require './packet_util'
make_nft_rules = require './make_nft_rules'


# FIXME TODO more error process

_recv_packet = (t) ->
  # recv header
  header = await t.recv packet_util.PACKET_HEADER_SIZE
  body_len = packet_util.get_body_size header
  # recv body
  body = await t.recv body_len
  [header, body]

# async
login = ->
  # load config
  await config.load()
  c = config.get_config()

  # connecting to auth server and send data
  t = new util.TcpC()
  [auth_ip, auth_port] = c.auth_server.split(':')
  auth_port = Number.parseInt auth_port
  # DEBUG config
  console.log "vadsll.D: auth_server = #{c.auth_server}, interface = #{c.interface}, account = #{c.account}"

  # get IP addr and MAC address
  ip = await util.get_bind_ip c.interface
  [mac, mac_str] = await util.get_mac_addr c.interface
  console.log "vadsll.D: IP addr = #{ip.join('.')}, MAC addr = #{mac_str}"
  # make login data
  data = packet_util.make_login_msg mac, ip, c.account, c.password

  # connecting to auth server
  await t.connect auth_ip, auth_port
  console.log "vadsll.D: send login packet (#{data.length} Byte data)"
  await t.send data

  # wait server response
  console.log "vadsll.D: waiting server response .. . "
  [head, body] = await _recv_packet t
  console.log "vadsll.D: server response (#{head.length + body.length} Byte data)"
  # parse server data
  res = packet_util.parse_server_msg head, body
  # DEBUG
  console.log JSON.stringify(res, '', '    ')
  # check login OK
  if res.type == 'error'
    console.log "vadsll: ERROR: login failed: #{res.info}"
    # close socket
    await t.close()
    return
  # login OK, send ACK msg
  ack = packet_util.login_ack()
  console.log "vadsll.D: send ACK (#{ack.length} Byte data)"
  await t.send ack
  # close socket
  await t.close()
  # logout done
  console.log "vadsll: [ OK ] logout done."

  # TODO start background route_filter process and send keep-alive msg ?

module.exports = login
