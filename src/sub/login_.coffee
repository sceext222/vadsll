# login_.coffee, vadsll

util = require '../util'
config = require '../config'

login_ = ->
  c = await config.load()
  console.log "vadsll: start LOGIN "

  await util.call_this ['--log-backup']
  await util.call_this ['--log-clean']

  await util.call_this ['--only-login']
  await util.call_this ['--nft-gen']
  # set MTU
  await util.set_mtu c.interface, c.vadsl_mtu
  await util.call_this ['--nft-init']

  await util.call_this ['--run-keep-alive']
  await util.call_this ['--run-route-filter']

  console.log "vadsll: [ OK ] login done. "

module.exports = login_  # async
