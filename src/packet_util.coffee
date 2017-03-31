# packet_util.coffee, vadsll/src/


# const data

_HEADER_LOGOUT = [0x5f, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]  #  8 Byte
_HEADER_KEEP = [0x5f, 0x4f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]  # 8 Byte
_HEADER_IP = [0x14, 0x01, 0x00, 0x00]  #  4 Byte
_HEADER_ACCOUNT = [0x14, 0x03, 0x00, 0x00]  #  4 Byte
_END_9_ZERO = Buffer.alloc 9  #  9 Byte


_ip_info = (ip_a) ->
  # ip_a, eg: [192, 168, 1, 22]
  # header and data
  h = Buffer.from _HEADER_IP
  d = Buffer.from ip_a
  # set length in header
  h[2] = h.length + d.length
  Buffer.concat [h, d]

_account_info = (account_str) ->
  # account_str, eg: '12366664444'
  # header and data
  h = Buffer.from _HEADER_ACCOUNT
  d = Buffer.from account_str
  # TODO FIXME maybe improve add END
  # set length in header
  h[2] = h.length + d.length + _END_9_ZERO.length
  Buffer.concat [h, d, _END_9_ZERO]

_add_packet_header = (header, data) ->
  head = Buffer.from header
  body = Buffer.concat data
  # set length in header
  head[3] = body.length
  Buffer.concat [head, body]


# LOGOUT
make_logout_msg = (ip_a, account_str) ->
  _add_packet_header _HEADER_LOGOUT, [
    _ip_info ip_a
    _account_info account_str
  ]

# KEEP alive
make_keep_msg = (ip_a, account_str) ->
  _add_packet_header _HEADER_KEEP, [
    _ip_info ip_a
    _account_info account_str
  ]


# TODO

module.exports = {
  make_logout_msg
  make_keep_msg

}
