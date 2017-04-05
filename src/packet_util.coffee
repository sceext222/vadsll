# packet_util.coffee, vadsll/src/
# FIXME TODO process packet size over 255 Byte

# const data
PACKET_HEADER_SIZE = 8
# packet header  (8 Byte)
_HEADER_LOGIN      = [0x5f, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
_HEADER_LOGIN_ACK  = [0x5f, 0x41, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
_HEADER_LOGOUT     = [0x5f, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
_HEADER_KEEP       = [0x5f, 0x4f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
_HEADER_SERVER_OK  = [0x5f, 0x51, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
_HEADER_SERVER_ERR = [0x5f, 0x52, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
# info item header  (4 Byte)
_HEADER_IP        = [0x14, 0x01, 0x00, 0x00]
_HEADER_MAC       = [0x14, 0x02, 0x00, 0x00]
_HEADER_ACCOUNT   = [0x14, 0x03, 0x00, 0x00]
_HEADER_PASS      = [0x14, 0x04, 0x00, 0x00]
_HEADER_VERSION   = [0x14, 0x05, 0x00, 0x00]
_HEADER_UNKNOW_1  = [0x14, 0x06, 0x00, 0x00]

_END_9_ZERO = Buffer.alloc 9  #  9 Byte
_VERSION_DATA = [0x01, 0x05, 0x00, 0x00]  #  4 Byte


# create packet (msg, add packet header)
_packet = (header, data) ->
  head = Buffer.from header
  body = Buffer.concat data
  # set length in header
  head[3] = body.length
  Buffer.concat [head, body]

# create item (add item header)
_item = (header, data) ->
  head = Buffer.from header
  body = Buffer.concat data
  # set length in header
  head[2] = head.length + body.length
  Buffer.concat [head, body]


_info_ip = (ip_a) ->
  # ip_a, eg: [192, 168, 1, 22]
  _item _HEADER_IP, [
    Buffer.from ip_a
  ]

_info_mac = (mac_a) ->
  # mac_a, eg: [1, 2, 3, 4, 5, 6]
  _item _HEADER_MAC, [
    Buffer.from mac_a
  ]

_info_account = (account_str) ->
  # account_str, eg: '12366664444'
  _item _HEADER_ACCOUNT, [
    Buffer.from account_str
    _END_9_ZERO
  ]

_info_pass = (pass_str, ip_a) ->
  # pass_str, eg: '12345678'
  pass = Buffer.from pass_str
  # `xor` for pass
  p = ip_a[ip_a.length - 1]
  for i in [0... pass.length]
    pass[i] ^= p
  _item _HEADER_PASS, [
    pass
    Buffer.from [p]
  ]

_info_version = ->
  _item _HEADER_VERSION, [
    Buffer.from _VERSION_DATA
  ]

_info_unknow_1 = ->
  _item _HEADER_UNKNOW_1, [
    Buffer.alloc 4  #  4 Byte
  ]


# LOGOUT
make_logout_msg = (ip_a, account_str) ->
  _packet _HEADER_LOGOUT, [
    _info_ip ip_a
    _info_account account_str
  ]
# KEEP alive
make_keep_msg = (ip_a, account_str) ->
  _packet _HEADER_KEEP, [
    _info_ip ip_a
    _info_account account_str
  ]
# LOGIN
make_login_msg = (mac_a, ip_a, account_str, pass_str) ->
  _packet _HEADER_LOGIN, [
    _info_mac mac_a
    _info_ip ip_a
    _info_account account_str
    _info_pass pass_str, ip_a
    _info_version()
    _info_unknow_1()
  ]
# login-OK ack msg
login_ack = ->
  Buffer.from _HEADER_LOGIN_ACK


# parse server msg

_check_parse_text = (raw) ->
  o = raw.toString 'utf-8'
  check = Buffer.from o, 'utf-8'
  if Buffer.compare(raw, check) == 0
    ' ' + o
  else
    'base64: ' + raw.toString 'base64'

_parse_err = (info) ->
  {
    'type': 'error'
    'info': _check_parse_text info.text
  }

_parse_ok = (info) ->
  _c = (raw) ->
    Array.from(raw).join('.')
  c = (data) ->
    _c(data[0...4]) + '/' + _c(data[4...8])
  # parse route filter
  rf = []
  head = info.route_filter[0...12]
  body = info.route_filter[12..]
  for i in [0... head[8]]
    rf.push c(body[12 * i ... 12 * i + 12])
  {
    'type': 'OK'
    'gateway': _c(info.gateway)
    'route_filter': rf
  }


# parse server msg struct (get each msg from it)
_unpack = (data) ->
  # known header types
  kh = {
    0x05: 'gateway'
    0x09: 'route_filter'
    0x15: 'text'
  }
  # FIXME TODO other types: unknow
  rest = data[..]
  o = {}
  while rest.length > 0
    head = rest[0...4]
    info_len = head[2]
    # check and fix info_len
    if (head[0] == 0x15) and (head[1] == 0x15)
      info_len += 4
    body = rest[4...info_len]
    rest = rest[info_len..]

    info_type = kh[head[1]]
    if info_type?
      o[info_type] = body
    else
      # TODO unknow type
  o

# TODO strict check server_msg packet
parse_server_msg = (head, body) ->
  # check packet type
  switch head[1]
    when _HEADER_SERVER_ERR[1]
      _parse_err _unpack(body)
    when _HEADER_SERVER_OK[1]
      _parse_ok _unpack(body)
    else
      throw new Error 'unknow packet header: ' + head.toString('hex')

# get body size (unit: Byte) from packet header
get_body_size = (head) ->
  head[3]


module.exports = {
  PACKET_HEADER_SIZE

  make_logout_msg
  make_keep_msg
  make_login_msg
  login_ack
  parse_server_msg
  get_body_size
}
