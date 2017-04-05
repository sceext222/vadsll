# logout_.coffee, vadsll

util = require '../util'
config = require '../config'

logout_ = ->
  c = await config.load()
  console.log "vadsll: start LOGOUT "
  await util.call_this ['--kill-keep-alive']

  await util.call_this ['--only-login']
  await util.call_this ['--nft-reset']
  # set MTU
  await util.set_mtu c.interface, c.ethernet_mtu

  await util.call_this ['--kill-route-filter']
  console.log "vadsll: [ OK ] logout done. "

module.exports = logout_  # async
