# log_backup.coffee, vadsll/src/sub/
path = require 'path'

async_ = require '../async'
util = require '../util'
config = require '../config'


log_backup = ->
  log_path = config.get_dir 'log'
  old_path = path.join log_path, config.LOG_OLD_PATH
  # FIXME TODO try to create old_path dir

  # create backup dir
  backup_path = path.join old_path, new Date().toISOString()
  await async_.mkdir backup_path
  # copy each log file
  for i in config.LOG_FILE_LIST
    log_file = path.join log_path, i
    if await async_.file_exist log_file
      await util.cp log_file, path.join(backup_path, i)

module.exports = log_backup  # async
