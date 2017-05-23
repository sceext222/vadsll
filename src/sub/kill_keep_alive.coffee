# kill_keep_alive.coffee, vadsll/src/sub/
util = require '../util'
config = require '../config'

kill_keep_alive = ->
  pid_file = config.get_file_path 'run', config.FILE.pid.keep_alive
  await util.kill_pid pid_file

module.exports = kill_keep_alive  # async
