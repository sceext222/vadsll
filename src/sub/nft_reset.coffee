# nft_reset.coffee, vadsll/src/sub/
util = require '../util'
config = require '../config'

nft_reset = ->
  c = await util.load_config()
  table_name = c.nft_table
  # neet root privilege
  await util.run_check ['nft', 'delete', 'table', table_name]

module.exports = nft_reset  # async
