# only_login.coffee, vadsll/src/sub/
# FIXME TODO more error process

path = require 'path'

async_ = require '../async'
util = require '../util'
config = require '../config'
packet_util = require '../packet_util'


_recv_packet = (t) ->
  # recv header
  header = await t.recv packet_util.PACKET_HEADER_SIZE
  body_len = packet_util.get_body_size header
  # recv body
  body = await t.recv body_len
  [header, body]

_create_log = (res, c, ip_a, mac_str) ->
  o = {
    '#': 'vadsll login log'
    interface: c.interface
    mac: mac_str
    ip: ip_a.join('.')
    auth_server: c.auth_server
    account: c.account
    server_res: res
    time: new Date().toISOString()
  }
  if res.type == 'OK'
    log_file = path.join config.get_log_path(), config.LOG_SERVER_RES_OK
  else
    log_file = path.join config.get_log_path(), config.LOG_SERVER_RES_ERR
  await util.write_file log_file, util.print_json(o) + '\n'

_decode_server_msg = (raw) ->
  b64 = raw.split('base64:')[1].trim()
  tmp_file = path.join config.get_log_path(), config.LOG_SERVER_MSG_TMP
  await util.write_file tmp_file, Buffer.from(b64, 'base64')
  result = await async_.call_cmd ['iconv', '-f', 'gbk', '-t', 'utf-8', tmp_file]


only_login = ->
  # load config
  c = await config.load()
  # DEBUG config
  console.log "vadsll.D: auth_server = #{c.auth_server}, interface = #{c.interface}, account = #{c.account}"

  # get IP addr and MAC address
  ip = await util.get_bind_ip c.interface
  [mac, mac_str] = await util.get_mac_addr c.interface
  console.log "vadsll.D: IP addr = #{ip.join('.')}, MAC addr = #{mac_str}"
  # make login data
  data = packet_util.make_login_msg mac, ip, c.account, c.password

  # connecting to auth server and send data
  t = await util.connect_auth_server c.auth_server
  console.log "vadsll.D: send login packet (#{data.length} Byte data)"
  await t.send data

  # wait server response
  console.log "vadsll.D: waiting server response .. . "
  [head, body] = await _recv_packet t
  console.log "vadsll.D: server response (#{head.length + body.length} Byte data)"
  # parse server data
  res = packet_util.parse_server_msg head, body
  # DEBUG
  console.log util.print_json(res)
  # create log files
  await _create_log res, c, ip, mac_str

  # check login OK
  if res.type == 'error'
    info = res.info
    if info.startsWith 'base64:'
      info = await _decode_server_msg info
    console.log "vadsll: ERROR: login failed: #{info}"
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
  console.log "vadsll: [ OK ] only-login success "

module.exports = only_login  # async
