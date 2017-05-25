# init.coffee, vadsll/src/
async_ = require '../async'
util = require '../util'
config = require '../config'
log = require '../log'

init = ->
  # create directory (as root)
  log_dir = config.get_dir 'log'
  run_dir = config.get_dir 'run'

  _check_create_dir = (dir) ->
    if ! await async_.file_exist(dir)
      await util.run_check ['mkdir', '-p', dir]
    await util.run_check ['chown', "#{config.SYSTEM_USER}:#{config.SYSTEM_USER}", dir]
  await _check_create_dir(log_dir)
  await _check_create_dir(run_dir)
  # check PID file
  route_filter_pid = config.get_file_path 'run', config.FILE.pid.route_filter
  keep_alive_pid = config.get_file_path 'run', config.FILE.pid.keep_alive

  if await async_.file_exist(route_filter_pid)
    throw new Error "PID file `#{route_filter_pid}` already exist ! "
  if await async_.file_exist(keep_alive_pid)
    throw new Error "PID file `#{keep_alive_pid}` already exist ! "

module.exports = init  # async
