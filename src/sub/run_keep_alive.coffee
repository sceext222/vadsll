# run_keep_alive.coffee, vadsll/src/sub/

util = require '../util'

run_keep_alive = ->
  util.run_detach util.call_this_args(['--keep-alive'])
  await return

module.exports = run_keep_alive  # async
