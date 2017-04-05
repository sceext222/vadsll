# once_keep_alive.coffee, vadsll/src/sub/

async_ = require '../async'
util = require '../util'
config = require '../config'
packet_util = require '../packet_util'


once_keep_alive = ->
  # load config
  c = await config.load()
  # get IP addr
  ip = await util.get_bind_ip c.interface
  # DEBUG config
  console.log "vadsll.D: auth_server = #{c.auth_server}, interface = #{c.interface}, IP = #{ip.join('.')}, account = #{c.account}"

  # make logout data
  data = packet_util.make_keep_msg ip, c.account

  # connecting to auth server and send data
  t = await util.connect_auth_server c.auth_server
  console.log "vadsll.D: send keep packet (#{data.length} Byte data)"
  await t.send data

  console.log "vadsll.D: waiting server to close socket .. . "
  await t.wait_err()
  console.log "vadsll: once-keep-alive finished "


module.exports = once_keep_alive  # async
