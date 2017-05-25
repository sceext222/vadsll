# only_login.coffee, vadsll/src/sub/
# FIXME TODO more error process

async_ = require '../async'
util = require '../util'
config = require '../config'
log = require '../log'
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
    log_file = config.get_file_path 'log', config.FILE.log.server_res_ok
  else
    log_file = config.get_file_path 'log', config.FILE.log.server_res_err
  await util.write_file log_file, util.print_json(o) + '\n'

_decode_server_msg = (raw) ->
  b64 = raw.split('base64:')[1].trim()
  tmp_file = config.get_file_path 'log', config.FILE.log.server_msg_tmp
  await util.write_file tmp_file, Buffer.from(b64, 'base64')
  result = await async_.call_cmd ['iconv', '-f', 'gbk', '-t', 'utf-8', tmp_file]


only_login = (passwd) ->
  # load config
  c = await util.load_config()
  # DEBUG config
  log.d "auth_server = #{c.auth_server}, interface = #{c.interface}, account = #{c.account}"

  # get IP addr and MAC address
  ip = await util.get_bind_ip c.interface
  [mac, mac_str] = await util.get_mac_addr c.interface
  log.d "IP addr = #{ip.join('.')}, MAC addr = #{mac_str}"
  # make login data
  data = packet_util.make_login_msg mac, ip, c.account, passwd

  # connecting to auth server and send data
  t = await util.connect_auth_server c.auth_server
  log.d "send login packet (#{data.length} Byte data)"
  await t.send data

  # wait server response
  log.d "waiting server response .. . "
  [head, body] = await _recv_packet t
  log.d "server response (#{head.length + body.length} Byte data)"
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
    log.p "ERROR: login failed: #{info}"
    # close socket
    await t.close()
    return
  # login OK, send ACK msg
  ack = packet_util.login_ack()
  log.d "send ACK (#{ack.length} Byte data)"
  await t.send ack
  # close socket
  await t.close()
  # login done
  log.p "[ OK ] only-login success "

module.exports = only_login  # async
