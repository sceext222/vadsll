# log_clean.coffee, vadsll/src/sub/

path = require 'path'

async_ = require '../async'
util = require '../util'
config = require '../config'


log_clean = ->
  log_path = config.get_log_path()
  # clean each log file
  for i in config.LOG_FILE_LIST
    log_file = path.join log_path, i
    if await async_.file_exist log_file
      await async_.rm log_file

module.exports = log_clean  # async
