# config.coffee, vadsll/src/

path = require 'path'

async_ = require './async'

# static config

# paths
_BIN_ROUTE_FILTER = 'route_filter'  #  dist/route_filter
_CONFIG_FILE = 'config.json'        #  etc/config.json
_LOCAL_INSTALL_PREFIX = '/usr/local/'
# paths (installed to /usr/local/)
_PATH_LOCAL_DIST = '/usr/local/lib/vadsll/'
_PATH_LOCAL_ETC = '/usr/local/etc/vadsll/'
_PATH_LOCAL_LOG = '/var/log/vadsll/'
# paths (not installed, from this file: `config.js`)
_PATH_DIST = '../'        #  dist/vadsll/config.js
_PATH_ETC = '../../etc/'  #  etc/config.json
_PATH_LOG = '../../tmp/'  #  tmp/

LOG_SERVER_RES_OK    = 'server_res.OK.json'
LOG_SERVER_RES_ERR   = 'server_res.err.json'
# $ sudo nft -f setup.nft
LOG_NFT_SETUP        = 'setup.nft'
LOG_NFT_RESET        = 'nft_reset.sh'
LOG_PID_KEEP_ALIVE   = 'keep_alive.pid'
LOG_PID_ROUTE_FILTER = 'route_filter.pid'
LOG_SERVER_MSG_TMP   = 'server_msg.gbk'

LOG_FILE_LIST = [
  LOG_SERVER_RES_OK
  LOG_SERVER_RES_ERR
  LOG_NFT_SETUP
  #LOG_NFT_RESET
]
LOG_OLD_PATH = 'old'


_is_local_installed = ->
  d = path.resolve __dirname
  if d.startsWith _LOCAL_INSTALL_PREFIX
    return true
  false

_path_pretty_print = (raw) ->
  path.relative path.resolve('.'), raw

# config.json data
_config_data = null
# load config.json
load = ->
  if _is_local_installed()
    config_file = path.join _PATH_LOCAL_ETC, _CONFIG_FILE
  else
    config_file = _path_pretty_print path.join(__dirname, _PATH_ETC, _CONFIG_FILE)
  # DEBUG
  console.log "vadsll.D: load config file #{config_file}"
  text = await async_.read_file config_file
  _config_data = JSON.parse text

get_config = ->
  _config_data

get_log_path = ->
  if _is_local_installed()
    path.normalize _PATH_LOCAL_LOG
  else
    _path_pretty_print path.join(__dirname, _PATH_LOG)

get_route_filter_bin = ->
  if _is_local_installed()
    path.normalize path.join(_PATH_LOCAL_DIST, _BIN_ROUTE_FILTER)
  else
    _path_pretty_print path.join(__dirname, _PATH_DIST, _BIN_ROUTE_FILTER)


module.exports = {
  LOG_SERVER_RES_OK
  LOG_SERVER_RES_ERR
  LOG_NFT_SETUP
  LOG_NFT_RESET
  LOG_PID_KEEP_ALIVE
  LOG_PID_ROUTE_FILTER
  LOG_SERVER_MSG_TMP

  LOG_FILE_LIST
  LOG_OLD_PATH

  load  # async

  get_config
  get_log_path
  get_route_filter_bin
}
