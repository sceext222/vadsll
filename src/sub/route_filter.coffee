# route_filter.coffee, vadsll/src/sub/

path = require 'path'
child_process = require 'child_process'

async_ = require '../async'
util = require '../util'
config = require '../config'
log = require '../log'

# global data
_gd = {
  p: null  # child process: route_filter
  exit_flag: false
}

_spawn = (args) ->
  cmd = args[0]
  rest = args[1..]
  # DEBUG
  console.log "  RUN -> #{args.join(' ')}"
  p = child_process.spawn cmd, rest, {
    stdio: 'inherit'
  }
  _gd.p = p

  p.on 'exit', () ->
    pid = _gd.p.pid
    _gd.p = null
    if ! _gd.exit_flag
      log.d "child process exit (PID #{pid}  route_filter)"
      _on_exit()


_pid_file = ->
  path.join config.get_log_path(), config.LOG_PID_ROUTE_FILTER

_on_exit = ->
  _gd.exit_flag = true
  if _gd.p?
    pid = _gd.p.pid
    log.d "send SIGKILL to PID #{pid} (route_filter) "
    process.kill pid, 'SIGKILL'
  # remove PID file
  await async_.rm _pid_file()
  process.exit(0)

route_filter = ->
  c = await config.load()
  # create PID file
  await util.create_pid_file _pid_file()

  server_log_file = path.join config.get_log_path(), config.LOG_SERVER_RES_OK
  s = JSON.parse await async_.read_file(server_log_file)

  args = [
    config.get_route_filter_bin()
    '--queue'
    c.nfqueue_id
    '--src-ip'
    s.ip
    '--dst-ip'
    s.server_res.gateway
    '--mtu'
    c.ethernet_mtu
  ]
  _spawn args
  # set exit event listener
  process.on 'SIGTERM', () ->
    log.d "receive SIGTERM, exiting .. . "
    _on_exit()

module.exports = route_filter  # async
