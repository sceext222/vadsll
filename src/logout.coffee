# logout.coffee, vadsll/src/

async_ = require './async'
util = require './util'
config = require './config'
packet_util = require './packet_util'
make_nft_rules = require './make_nft_rules'

# async
logout = ->
  # load config
  await config.load()
  c = config.get_config()

  # connecting to auth server and send data
  t = new util.TcpC()
  [auth_ip, auth_port] = c.auth_server.split(':')
  auth_port = Number.parseInt auth_port
  # DEBUG config
  console.log "vadsll.D: auth_server = #{c.auth_server}, interface = #{c.interface}, account = #{c.account}"

  # get IP addr
  ip = await util.get_bind_ip c.interface
  console.log "vadsll.D: IP addr of #{c.interface} is #{ip.join('.')}"
  # make logout data
  data = packet_util.make_logout_msg ip, c.account

  # connecting to auth server
  await t.connect auth_ip, auth_port
  console.log "vadsll.D: send logout packet (#{data.length} Byte data)"
  await t.send data

  # close socket
  await t.close()
  # logout done
  console.log "vadsll: [ OK ] logout done."

  # TODO kill background route_filter process and login (keep-alive) process

module.exports = logout
