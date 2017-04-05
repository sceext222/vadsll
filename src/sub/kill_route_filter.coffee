# kill_route_filter.coffee, vadsll/src/sub/
path = require 'path'

util = require '../util'
config = require '../config'

kill_route_filter = ->
  pid_file = path.join config.get_log_path(), config.LOG_PID_ROUTE_FILTER
  await util.kill_pid pid_file

module.exports = kill_route_filter  # async
