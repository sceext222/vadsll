# nft_gen.coffee, vadsll/src/sub/
async_ = require '../async'
util = require '../util'
config = require '../config'
make_nft_rules = require '../make_nft_rules'

nft_gen = ->
  # read config and server_log file
  c = await util.load_config()

  log_file = config.get_file_path 'log', config.FILE.log.server_res_ok
  server_log = await async_.read_file log_file

  [setup, reset] = make_nft_rules c, JSON.parse(server_log)
  # write files
  setup_file = config.get_file_path 'log', config.FILE.nft.setup
  reset_file = config.get_file_path 'log', config.FILE.nft.reset

  await util.write_file setup_file, setup
  await util.write_file reset_file, reset

module.exports = nft_gen  # async
