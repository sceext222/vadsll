# login_.coffee, vadsll/src/

util = require '../util'
config = require '../config'
log = require '../log'

login_ = ->
  c = await config.load()
  log.p "start LOGIN "

  await util.call_this ['--slave', '--log-backup']
  await util.call_this ['--slave', '--log-clean']

  await util.call_this ['--slave', '--only-login']
  await util.call_this ['--slave', '--nft-gen']
  # set MTU
  await util.set_mtu c.interface, c.vadsl_mtu
  await util.call_this ['--slave', '--nft-init']

  await util.call_this ['--slave', '--run-keep-alive']
  await util.call_this ['--slave', '--run-route-filter']

  log.p "[ OK ] login done. "

module.exports = login_  # async
