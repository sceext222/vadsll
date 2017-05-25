# vadsll.coffee, vadsll/src/

p_args = require './p_args'
util = require './util'


VADSLL_VERSION = 'vadsll version 1.0.0-2 test20170525 1454'

_print_help = ->
  console.log '''
  vadsll: Virtual ADSL tools for Linux
  Usage:
      --login              The complete LOGIN process
      --logout             The complete LOGOUT process

      --init               Do init in system install mode
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
  # DROP before run sub
  switch p_args(argv)
    when '--init'
      # NOT really drop
      util.check_drop false
      await require('./sub/init')()
    when '--only-login'
      # load passwd before drop
      passwd = await util.read_passwd()
      # DROP
      util.check_drop true
      await require('./sub/only_login')(passwd)
    when '--only-logout'
      # DROP first
      util.check_drop true
      await require('./sub/only_logout')()
    when '--nft-gen'
      # DROP first
      util.check_drop true
      await require('./sub/nft_gen')()
    when '--nft-init'
      # NOT really drop
      util.check_drop false
      await require('./sub/nft_init')()
    when '--nft-reset'
      # NOT really drop
      util.check_drop false
      await require('./sub/nft_reset')()
    when '--log-backup'
      # DROP first
      util.check_drop true
      await require('./sub/log_backup')()
    when '--log-clean'
      # DROP first
      util.check_drop true
      await require('./sub/log_clean')()
    when '--run-keep-alive'
      # DROP first
      util.check_drop true
      await require('./sub/run_keep_alive')()
    when '--run-route-filter'
      # NOT really drop
      util.check_drop false
      await require('./sub/run_route_filter')()
    when '--route-filter'
      # NOTE not drop here
      await require('./sub/route_filter')()
    when '--keep-alive'
      # DROP first
      util.check_drop true
      await require('./sub/keep_alive')()
    when '--once-keep-alive'
      # DROP first
      util.check_drop true
      await require('./sub/once_keep_alive')()
    when '--kill-keep-alive'
      # DROP first
      util.check_drop true
      await require('./sub/kill_keep_alive')()
    when '--kill-route-filter'
      # DROP first
      util.check_drop true
      await require('./sub/kill_route_filter')()
    when '--login'
      # not drop here, but check auto_drop
      await util.auto_drop()
      await require('./sub/login_')()
    when '--logout'
      # not drop here, but check auto_drop
      await util.auto_drop()
      await require('./sub/logout_')()
    # NO drop check
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
