# only_logout.coffee, vadsll/src/sub/

async_ = require '../async'
util = require '../util'
config = require '../config'
packet_util = require '../packet_util'


only_logout = ->
  # load config
  c = await config.load()
  # DEBUG config
  console.log "vadsll.D: auth_server = #{c.auth_server}, interface = #{c.interface}, account = #{c.account}"

  # get IP addr
  ip = await util.get_bind_ip c.interface
  console.log "vadsll.D: IP addr #{ip.join('.')}"
  # make logout data
  data = packet_util.make_logout_msg ip, c.account

  # connecting to auth server and send data
  t = await util.connect_auth_server c.auth_server
  console.log "vadsll.D: send logout packet (#{data.length} Byte data)"
  await t.send data

  console.log "vadsll.D: waiting server to close socket .. . "
  await t.wait_err()
  console.log "vadsll: [ OK ] only-logout success "


module.exports = only_logout  # async
