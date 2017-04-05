# kill_keep_alive.coffee, vadsll/src/sub/
path = require 'path'

util = require '../util'
config = require '../config'

kill_keep_alive = ->
  pid_file = path.join config.get_log_path(), config.LOG_PID_KEEP_ALIVE
  await util.kill_pid pid_file

module.exports = kill_keep_alive  # async
