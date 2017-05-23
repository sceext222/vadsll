# nft_init.coffee, vadsll/src/sub/
util = require '../util'
config = require '../config'

nft_init = ->
  setup_file = config.get_file_path 'log', config.FILE.nft.setup

  # neet root privilege
  await util.run_check ['nft', '-f', setup_file]

module.exports = nft_init  # async
