# only_logout.coffee, vadsll/src/sub/

async_ = require '../async'
util = require '../util'
config = require '../config'
log = require '../log'
packet_util = require '../packet_util'


only_logout = ->
  # load config
  c = await config.load()
  # DEBUG config
  log.d "auth_server = #{c.auth_server}, interface = #{c.interface}, account = #{c.account}"

  # get IP addr
  ip = await util.get_bind_ip c.interface
  log.d "IP addr #{ip.join('.')}"
  # make logout data
  data = packet_util.make_logout_msg ip, c.account

  # connecting to auth server and send data
  t = await util.connect_auth_server c.auth_server
  log.d "send logout packet (#{data.length} Byte data)"
  await t.send data

  log.d "waiting server to close socket .. . "
  await t.wait_err()
  log.p "[ OK ] only-logout success "


module.exports = only_logout  # async
