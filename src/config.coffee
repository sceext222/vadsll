# config.coffee, vadsll/src/
path = require 'path'

# static config

# dirs for vadsll files
_DIR = {
  system: {
    lib: '/usr/lib/vadsll'
    bin: '/usr/bin'
    etc: '/etc/vadsll'
    log: '/var/log/vadsll'
    run: '/run/vadsll'
    _prefix: '/usr/lib/'
  }
  test: {  # from this file (`config.js`)
    lib: '../'        # dist/vadsll/config.js
    bin: '../../os'   # os/
    etc: '../../etc'  # etc/config.json
    log: '../../tmp'  # tmp/
    run: '../../tmp'
  }
}
# file paths
FILE = {
  config: 'config.toml'         # ETC/config.toml
  passwd: 'shadow'              # ETC/shadow
  route_filter: 'route_filter'  # LIB/route_filter
  log: {  # LOG/
    server_res_ok: 'server_res.OK.json'
    server_res_err: 'server_res.err.json'
    server_msg_tmp: 'server_msg.gbk'
  }
  nft: {  # LOG/  $ sudo nft -f setup.nft
    setup: 'setup.nft'
    reset: 'nft_reset.sh'
  }
  pid: {  # RUN/  PID file
    keep_alive: 'keep_alive.pid'
    route_filter: 'route_filter.pid'
  }
}

LOG_FILE_LIST = [  # LOG/
  FILE.log.server_res_ok
  FILE.log.server_res_err
  FILE.nft.setup
  #FILE.nft.reset
]
LOG_OLD_PATH = 'old'


is_system_install = ->
  d = path.resolve __dirname
  if d.startsWith _DIR.system._prefix
    return true
  false

_path_pretty_print = (raw) ->
  path.relative path.resolve('.'), raw

get_dir = (dir) ->
  if is_system_install()
    o = _DIR.system[dir]
  else
    o = _path_pretty_print path.join(__dirname, _DIR.test[dir])
  o

get_file_path = (dir, file) ->
  path.join get_dir(dir), file

# global data
_gd = {
  # config.json data
  config_data: null

  # if this process is running in --slave mode
  slave: false
  # this process drop to UID (and GID)
  drop: null
}

set_config = (data) ->
  _gd.config_data = data
get_config = ->
  _gd.config_data

FLAG_SLAVE = '--slave'
FLAG_DROP = '--drop'
# the system user to run vadsll in drop mode
SYSTEM_USER = 'vadsll'

set_slave = (slave) ->
  _gd.slave = slave
is_slave = ->
  _gd.slave
set_drop = (uid) ->
  _gd.drop = uid
get_drop = ->
  _gd.drop


module.exports = {
  FILE
  LOG_FILE_LIST
  LOG_OLD_PATH

  is_system_install
  SYSTEM_USER

  get_dir
  get_file_path
  set_config
  get_config

  FLAG_SLAVE
  FLAG_DROP
  set_slave
  is_slave
  set_drop
  get_drop
}
