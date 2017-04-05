# nft_gen.coffee, vadsll/src/sub/

path = require 'path'

async_ = require '../async'
util = require '../util'
config = require '../config'
make_nft_rules = require '../make_nft_rules'


nft_gen = ->
  # read config and server_log file
  c = await config.load()
  log_file = path.join config.get_log_path(), config.LOG_SERVER_RES_OK
  server_log = await async_.read_file log_file

  [setup, reset] = make_nft_rules c, JSON.parse(server_log)
  # write files
  setup_file = path.join config.get_log_path(), config.LOG_NFT_SETUP
  reset_file = path.join config.get_log_path(), config.LOG_NFT_RESET

  await util.write_file setup_file, setup
  await util.write_file reset_file, reset

module.exports = nft_gen  # async
