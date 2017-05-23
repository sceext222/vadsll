# log.coffee, vadsll/src/

config = require './config'


_MASTER_PREFIX = 'vadsll'
_SLAVE_PREFIX  = '    vl'

# FIXME TODO print to stderr
_p = (text) ->
  if config.is_slave()
    o = _SLAVE_PREFIX + text
  else
    o = _MASTER_PREFIX + text
  console.log o

# TODO maybe print current time ?

# exports

d = (text) ->
  _p '.D: ' + text
e = (text) ->
  _p '.E: ' + text
w = (text) ->
  _p '.W: ' + text
p = (text) ->
  _p ': ' + text


module.exports = {
  d  # DEBUG
  e  # ERROR
  w  # WARN

  p  # normal print
}
