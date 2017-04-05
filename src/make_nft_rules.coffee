# make_nft_rules.coffee, vadsll/src/


# IPv4 net mask to CIDR /N format
_net_mask_to_cidr = (raw) ->
  [addr, mask] = raw.split('/')
  mask = mask.split('.').map (x) ->
    Number.parseInt x
  mask = mask.reduce (a, b) ->
    if b?
      a * 256 + b
    else
      0
  n = 0
  while mask > 0
    n += mask & 1
    mask = mask >>> 1
  "#{addr}/#{n}"


make_nft_rules = (c, server_log) ->
  table_name = c.nft_table
  hook_p = c.nft_hook_priority
  queue_id = c.nfqueue_id
  ifname = server_log.interface
  chain_name = 'out'

  # setup script
  s = ['#!/usr/bin/nft -f']
  s.push "add table ip #{table_name}"
  s.push "add chain ip #{table_name} #{chain_name} { type filter hook postrouting priority #{hook_p} ; policy accept ; }"
  for i in server_log.server_res.route_filter
    s.push "add rule ip #{table_name} #{chain_name} ip daddr #{_net_mask_to_cidr(i)} meta oifname \"#{ifname}\" accept"
  s.push "add rule ip #{table_name} #{chain_name} meta oifname \"#{ifname}\" counter queue num #{queue_id} bypass"
  # reset script
  r = ['#!/bin/sh']
  r.push "nft delete table ip #{table_name}"
  [s.join('\n') + '\n', r.join('\n') + '\n']

module.exports = make_nft_rules
