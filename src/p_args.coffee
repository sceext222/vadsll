# p_args.coffee, vadsll/src/

config = require './config'


_MAIN_OPERATION = [
  '--login'
  '--logout'
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
  for i in args
    switch i
      when config.FLAG_SLAVE
        config.set_slave true
      else
        for m in _MAIN_OPERATION
          if i == m
            o = m
            break
  o

module.exports = p_args
