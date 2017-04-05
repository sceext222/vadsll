# keep_alive.coffee, vadsll/src/sub/

path = require 'path'

async_ = require '../async'
util = require '../util'
config = require '../config'


_pid_file = ->
  path.join config.get_log_path(), config.LOG_PID_KEEP_ALIVE

_on_exit = ->
  # remove PID file
  await async_.rm _pid_file()

  console.log "vadsll.D: receive SIGTERM, exiting .. . "
  process.exit(0)

_once_keep_alive = ->
  console.log "vadsll.D: once keep-alive at #{new Date()}"
  await util.call_this ['--once-keep-alive']

keep_alive = ->
  c = await config.load()
  # create PID file
  await util.create_pid_file _pid_file()

  # set exit event listener
  process.on 'SIGTERM', () ->
    _on_exit()
  # set once_keep_alive callback
  setInterval _once_keep_alive, 1e3 * c.keep_alive_timeout_s
  console.log "vadsll.D: start send keep-alive every #{c.keep_alive_timeout_s} s "

module.exports = keep_alive  # async
