# packet_util.coffee, vadsll/src/


# const data

# packet header  (8 Byte)
_HEADER_LOGIN  = [0x5f, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
_HEADER_LOGOUT = [0x5f, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
_HEADER_KEEP   = [0x5f, 0x4f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
# info item header  (4 Byte)
_HEADER_IP       = [0x14, 0x01, 0x00, 0x00]
_HEADER_MAC      = [0x14, 0x02, 0x00, 0x00]
_HEADER_ACCOUNT  = [0x14, 0x03, 0x00, 0x00]
_HEADER_PASS     = [0x14, 0x04, 0x00, 0x00]
_HEADER_VERSION  = [0x14, 0x05, 0x00, 0x00]
_HEADER_UNKNOW_1 = [0x14, 0x06, 0x00, 0x00]

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
  for i in [0.. pass.length - 1]
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


# TODO

module.exports = {
  make_logout_msg
  make_keep_msg
  make_login_msg

}
