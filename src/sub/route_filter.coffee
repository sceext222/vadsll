# route_filter.coffee, vadsll/src/sub/

path = require 'path'
child_process = require 'child_process'

async_ = require '../async'
util = require '../util'
config = require '../config'


_spawn = ->
  # TODO
  bin = cmd[0]
  rest = cmd[1..]
  # DEBUG
  console.log "  run_detach -> #{cmd.join(' ')}"
  p = child_process.spawn bin, rest, {
    stdio: 'inherit'
    detached: true
  }
  p.unref()

route_filter = ->
  # TODO

module.exports = route_filter  # async
