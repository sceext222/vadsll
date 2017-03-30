# packet_util.coffee, vadsll/src/


# const data

LOGOUT_HEADER = [0x5f, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]  #  8 Byte
LOGOUT_HEADER_IP = [0x14, 0x01, 0x00, 0x00]  #  4 Byte
LOGOUT_HEADER_ACCOUNT = [0x14, 0x03, 0x00, 0x00]  #  4 Byte
LOGOUT_END = Buffer.alloc 9  #  9 Byte


make_logout_msg = (ip_a, account_str) ->
  # ip_a, eg: [192, 168, 1, 22]
  # account_str, eg: '12366664444'

  # packet header
  ph = Buffer.from LOGOUT_HEADER

  # host IP info (header and data)
  h_ip = Buffer.from LOGOUT_HEADER_IP
  d_ip = Buffer.from ip_a
  # set info len in header
  h_ip[2] = h_ip.length + d_ip.length

  # account info (header and data)
  h_a = Buffer.from LOGOUT_HEADER_ACCOUNT
  d_a = Buffer.from account_str
  # set len in header
  h_a[2] = h_a.length + d_a.length + LOGOUT_END.length

  # concat
  o = Buffer.concat [ph, h_ip, d_ip, h_a, d_a, LOGOUT_END]
  # set len in packet header
  o[3] = o.length - ph.length
  # done
  o


# TODO

module.exports = {
  make_logout_msg

}
