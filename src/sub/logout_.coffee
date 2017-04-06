# logout_.coffee, vadsll/src/

util = require '../util'
config = require '../config'
log = require '../log'

logout_ = ->
  c = await config.load()
  log.p "start LOGOUT "
  await util.call_this ['--slave', '--kill-keep-alive']

  await util.call_this ['--slave', '--only-logout']
  await util.call_this ['--slave', '--nft-reset']
  # set MTU
  await util.set_mtu c.interface, c.ethernet_mtu

  await util.call_this ['--slave', '--kill-route-filter']
  log.p "[ OK ] logout done. "

module.exports = logout_  # async
