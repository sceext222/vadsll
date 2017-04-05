# nft_init.coffee, vadsll/src/sub/

path = require 'path'

util = require '../util'
config = require '../config'


nft_init = ->
  setup_file = path.join config.get_log_path(), config.LOG_NFT_SETUP

  # neet root privilege
  await util.run_check ['nft', '-f', setup_file]

module.exports = nft_init  # async
