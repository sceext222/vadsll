# p_args.coffee, vadsll/src/

config = require './config'


_MAIN_OPERATION = [
  '--login'
  '--logout'
  '--init'
  '--only-login'
  '--only-logout'
  '--nft-gen'
  '--nft-init'
  '--nft-reset'
  '--log-backup'
  '--log-clean'
  '--run-keep-alive'
  '--run-route-filter'
  '--route-filter'
  '--keep-alive'
  '--once-keep-alive'
  '--kill-keep-alive'
  '--kill-route-filter'
  '--help'
  '--version'
]

p_args = (args) ->
  o = null
  rest = args[..]
  while rest.length > 0
    a = rest[0]
    rest = rest[1..]
    switch a
      when config.FLAG_SLAVE
        config.set_slave true
      when config.FLAG_DROP
        uid = Number.parse rest[0]
        rest = rest[1..]
        config.set_drop uid
      else
        for m in _MAIN_OPERATION
          if a == m
            o = m
            break
  o

module.exports = p_args
