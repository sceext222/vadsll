# kill_keep_alive.coffee, vadsll/src/sub/

path = require 'path'

async_ = require '../async'
config = require '../config'


kill_keep_alive = ->
  pid_file = path.join config.get_log_path(), config.LOG_PID_KEEP_ALIVE
  if await async_.file_exist(pid_file)
    pid = await async_.read_file pid_file
    pid = Number.parseInt pid

    console.log "vadsll.D: send SIGTERM to PID #{pid}"
    process.kill pid, 'SIGTERM'

module.exports = kill_keep_alive  # async
