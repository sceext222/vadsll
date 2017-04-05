# util.coffee, vadsll/src/

path = require 'path'
net = require 'net'

async_ = require './async'


_WRITE_REPLACE_FILE_SUFFIX = '.tmp'

# atomic write-replace for a file
write_file = (file_path, text) ->
  tmp_file = file_path + _WRITE_REPLACE_FILE_SUFFIX
  await async_.write_file tmp_file, text
  await async_.mv tmp_file, file_path

# copy file
cp = (from, to) ->
  text = await async_.read_file from
  await write_file to, text


# run command and check exit_code is 0  (else will throw Error)
run_check = (cmd) ->
  exit_code = await async_.run_cmd cmd
  if exit_code != 0
    throw new Error "run command FAILED  (exit_code = #{exit_code})"


# TCP connector
class TcpC
  constructor: ->
    this._addr = null
    this._socket = null
    # recv buffer
    this._buffer = Buffer.alloc(0)

  # async
  connect: (ip, port) ->
    that = this
    new Promise (resolve, reject) ->
      # save addr
      that._addr = ip + ':' + port
      # DEBUG
      console.log "vadsll.D: connect TCP to #{that._addr}"
      that._socket = net.connect port, ip, () ->
        that._socket.setNoDelay(true)
        resolve()
      that._socket.on 'error', (err) ->
        # FIXME DEBUG
        console.log "vadsll.E: TCP connection to #{that._addr}, ERROR: #{err}"
        reject err
  # async
  send: (data) ->
    that = this
    new Promise (resolve, reject) ->
      that._socket.write data, () ->
        resolve()
      # TODO error process

  # async
  recv: (size) ->
    that = this
    check_size = () ->
      if that._buffer.length < size
        return
      o = that._buffer[0...size]
      that._buffer = that._buffer[size..]
      o

    new Promise (resolve, reject) ->
      # check enough data first
      data = check_size()
      if data
        return resolve(data)
      # recv data function
      on_data = (data) ->
        # concat data
        that._buffer = Buffer.concat([that._buffer, data])
        data = check_size()
        if data
          # remove listener
          that._socket.removeListener 'data', on_data
          resolve data
      # add event listener
      that._socket.on 'data', on_data
      # TODO error process

  # async
  close: ->
    that = this
    new Promise (resolve, reject) ->
      that._socket.on 'close', () ->
        resolve()
      that._socket.end()
      # FIXME TODO error process

  # async
  wait_err: ->
    that = this
    new Promise (resolve, reject) ->
      that._socket.once 'error', () ->
        resolve()


_parse_ip_addr_output = (raw) ->
  _IP_ADDR_PREFIX = '    inet '
  o = null
  for i in raw.split('\n')
    if i.startsWith _IP_ADDR_PREFIX
      o = i[_IP_ADDR_PREFIX.length..].split('/')[0]
  o

# get IP addr from interface name
get_bind_ip = (ifname) ->
  raw = await async_.call_cmd ['ip', 'addr', 'show', ifname]
  ip = _parse_ip_addr_output raw
  if not ip?
    return ip
  ip.split('.').map (x) ->
    Number.parseInt x

# get Ethernet MAC address  (/sys/class/net/IFNAME/address)
get_mac_addr = (ifname) ->
  p = "/sys/class/net/#{ifname}/address"
  raw = await async_.read_file(p)

  o = raw.split(':').map (x) ->
    Number.parseInt x, 16
  [o, raw.trim()]

set_mtu = (ifname, mtu) ->
  console.log "vadsll.D: set MTU of #{ifname} to #{mtu} Byte "
  # TODO


# run `vadsll` (this program) with different args
call_this = (args) ->
  cmd = ['node', process.argv[1]].concat args
  await run_check cmd

# run a child_process, it should be still running after this process exit
run_detach = (cmd) ->
  # TODO


# connect to auth_server
connect_auth_server = (auth_server) ->
  t = new TcpC()
  [auth_ip, auth_port] = auth_server.split(':')
  auth_port = Number.parseInt auth_port
  # connecting to auth server
  await t.connect auth_ip, auth_port
  t

# pretty-print JSON text
print_json = (data) ->
  JSON.stringify data, '', '    '

create_pid_file = (file_path) ->
  try
    fd = await async_.fs_open file_path, 'wx'
  catch e
    console.log "vadsll.E: can not create PID file #{file_path} "
    throw e
  # write PID in file
  await async_.fs_write fd, (process.pid + '')
  await async_.fs_close fd


module.exports = {
  write_file  # async
  cp  # async
  run_check  # async

  get_bind_ip  # async
  get_mac_addr  # async
  set_mtu  # async

  call_this  # async
  run_detach

  connect_auth_server  # async
  print_json
  create_pid_file  # async

  TcpC
}
