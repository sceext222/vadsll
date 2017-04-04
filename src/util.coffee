# util.coffee, vadsll/src/

path = require 'path'

async_ = require './async'


_WRITE_REPLACE_FILE_SUFFIX = '.tmp'

# atomic write-replace for a file
write_file = (file_path, text) ->
  tmp_file = file_path + _WRITE_REPLACE_FILE_SUFFIX
  await async_.write_file tmp_file, text
  await async_.mv tmp_file, file_path


module.exports = {
  write_file  # async
}
