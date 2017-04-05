# vadsll.coffee, vadsll/src/


_print_help = ->
  # TODO

_print_version = ->
  # TODO

main = (argv) ->
  switch argv[0]
    when '--only-login'
      await require('./sub/only_login')()
    when '--only-logout'
      await require('./sub/only_logout')()
    when '--nft-gen'
      await require('./sub/nft_gen')()
    when '--nft-init'
      await require('./sub/nft_init')()
    when '--nft-reset'
      await require('./sub/nft_reset')()
    when '--log-backup'
      await require('./sub/log_backup')()
    when '--log-clean'
      await require('./sub/log_clean')()
    when '--run-keep-alive'
      await require('./sub/run_keep_alive')()
    when '--run-route-filter'
      await require('./sub/run_route_filter')()
    when '--route-filter'
      await require('./sub/route_filter')()
    when '--keep-alive'
      await require('./sub/keep_alive')()
    when '--once-keep-alive'
      await require('./sub/once_keep_alive')()
    when '--kill-keep-alive'
      await require('./sub/kill_keep_alive')()
    when '--kill-route-filter'
      await require('./sub/kill_route_filter')()
    when '--login'
      await require('./sub/login_')()
    when '--logout'
      await require('./sub/logout_')()
    when '--help'
      _print_help()
    when '--version'
      _print_version()
    else
      console.log "ERROR: bad command line, please try `--help` "
      process.exit(1)

_start = ->
  try
    await main(process.argv[2..])
  catch e
    # DEBUG
    console.log "ERROR: #{e.stack}"
    # FIXME
    #throw e
    process.exit(1)
_start()
