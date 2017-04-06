# vadsll.coffee, vadsll/src/


VADSLL_VERSION = 'vadsll version 0.1.0-1 test20170406 1440'

_print_help = ->
  console.log '''
  vadsll: Virtual ADSL tools for Linux
  Usage:
      --login              The complete LOGIN process
      --logout             The complete LOGOUT process

      --only-login         Only send LOGIN packet to auth server
      --only-logout        Only send LOGOUT packet to auth server
      --nft-gen            Generate nftables rules
      --nft-init           Setup nftables rules
      --nft-reset          Reset nftables rules
      --log-backup         Backup log files
      --log-clean          Clean log files
      --run-keep-alive     Run KEEP-ALIVE in background
      --run-route-filter   Run route_filter in background
      --route-filter       Daemon of route_filter
      --keep-alive         Daemon of KEEP-ALIVE
      --once-keep-alive    Only send KEEP-ALIVE packet to auth server ONCE
      --kill-keep-alive    Kill KEEP-ALIVE daemon
      --kill-route-filter  Kill route_filter daemon

      --help               Show this help text
      --version            Show version of this program

  vadsll: <https://github.com/sceext222/vadsll>
  '''

_print_version = ->
  console.log VADSLL_VERSION

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
