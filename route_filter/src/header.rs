
use ip_header;
use ip_header::IpHeader;
// TODO improve error process ?
use simple_binding::{
    Error,
    ErrType,
    err_
};


// GRE header, length: 4 Byte
const GRE_HEADER: [u8; 4] = [0x00, 0x00, 0x08, 0x00];

// add header processor
pub struct HeaderP {
    // Ethernet MTU  (default: 1500 Byte)
    _mtu: usize,
    // src IP and dst IP used for GRE
    _src_ip: u32,
    _dst_ip: u32,
}

impl HeaderP {
    pub fn new() -> HeaderP {
        HeaderP {
            _mtu: 1500,
            _src_ip: 0,
            _dst_ip: 0,
        }
    }

    // config methods
    pub fn set_mtu(&mut self, mtu: usize) {
        self._mtu = mtu;
    }

    pub fn set_src_ip(&mut self, src_ip: u32) {
        self._src_ip = src_ip;
    }

    pub fn set_dst_ip(&mut self, dst_ip: u32) {
        self._dst_ip = dst_ip;
    }

    pub fn add_header(&self, raw_data: &Vec<u8>) -> Result<Vec<u8>, Error> {
        // check total length exced
        let total_len = ip_header::LEN + GRE_HEADER.len() + raw_data.len();
        if total_len > self._mtu {
            // not panic, just log
            // FIXME print to stderr
            println!("rf.WARNING: Packet too long: total_len = {}, MTU = {}, please set MTU to {}", total_len, self._mtu, (self._mtu - GRE_HEADER.len() - ip_header::LEN));
            return Err(err_(ErrType::PacketTooLong, &format!("packet total_len = {}, MTU = {}", total_len, self._mtu), None));
        }
        // TODO error process

        let mut o = vec![0; total_len];
        // make ip_header
        let oh = IpHeader::new_from(raw_data);  // old header
        let mut h = IpHeader::new();  // new header
        h.set_total_len(total_len as u16);
        h.set_ip_id(oh.get_ip_id());  // copy ip.id
        h.set_src_ip(self._src_ip);  // set src/dst IP
        h.set_dst_ip(self._dst_ip);
        h.update_checksum();
        let ih = h.get_data();  // done ip_header, copy data
        for i in 0..ih.len() {
            o[i] = ih[i];
        }
        // copy GRE header
        for i in 0..GRE_HEADER.len() {
            o[i + ip_header::LEN] = GRE_HEADER[i];
        }
        // copy raw data
        for i in 0..raw_data.len() {
            o[i + ip_header::LEN + GRE_HEADER.len()] = raw_data[i];
        }
        // done
        Ok(o)
    }
}
