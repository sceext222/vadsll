# once_keep_alive.coffee, vadsll/src/sub/

async_ = require '../async'
util = require '../util'
config = require '../config'
log = require '../log'
packet_util = require '../packet_util'


once_keep_alive = ->
  # load config
  c = await util.load_config()
  # get IP addr
  ip = await util.get_bind_ip c.interface
  # DEBUG config
  log.d "auth_server = #{c.auth_server}, interface = #{c.interface}, IP = #{ip.join('.')}, account = #{c.account}"

  # make logout data
  data = packet_util.make_keep_msg ip, c.account

  # connecting to auth server and send data
  t = await util.connect_auth_server c.auth_server
  log.d "send keep packet (#{data.length} Byte data)"
  await t.send data

  log.d "waiting server to close socket .. . "
  await t.wait_err()
  log.p "once-keep-alive finished "


module.exports = once_keep_alive  # async
