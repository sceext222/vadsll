# kill_route_filter.coffee, vadsll/src/sub/
util = require '../util'
config = require '../config'

kill_route_filter = ->
  pid_file = config.get_file_path 'run', config.FILE.pid.route_filter
  await util.kill_pid pid_file

module.exports = kill_route_filter  # async
