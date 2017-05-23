# run_route_filter.coffee, vadsll/src/sub/
util = require '../util'

run_route_filter = ->
  util.run_detach util.call_this_args(['--route-filter'], true)
  await return

module.exports = run_route_filter  # async
