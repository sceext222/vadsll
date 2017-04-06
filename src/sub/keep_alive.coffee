# keep_alive.coffee, vadsll/src/sub/

path = require 'path'

async_ = require '../async'
util = require '../util'
config = require '../config'
log = require '../log'


_pid_file = ->
  path.join config.get_log_path(), config.LOG_PID_KEEP_ALIVE

_on_exit = ->
  # remove PID file
  await async_.rm _pid_file()

  log.d "receive SIGTERM, exiting .. . "
  process.exit(0)

_once_keep_alive = ->
  log.d "once keep-alive at #{new Date()}"
  await util.call_this ['--slave', '--once-keep-alive']

keep_alive = ->
  c = await config.load()
  # create PID file
  await util.create_pid_file _pid_file()

  # set exit event listener
  process.on 'SIGTERM', () ->
    _on_exit()
  # set once_keep_alive callback
  setInterval _once_keep_alive, 1e3 * c.keep_alive_timeout_s
  log.d "start send keep-alive every #{c.keep_alive_timeout_s} s "

module.exports = keep_alive  # async
