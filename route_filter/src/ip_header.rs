

// IP haeder length: 20 Byte (fixed)
pub const LEN: usize = 20;

pub struct IpHeader {
    // header data
    _d: Vec<u8>,
}

impl IpHeader {
    // create a empty header
    pub fn new() -> IpHeader {
        let data = vec![
            // IPv4 header template
            // (0)  1 Byte: version (4) and header length (20)
            0x45,
            // (1)  1 Byte: diff-srv
            0x00,
            // (2)  2 Byte: total length
            0x00, 0x00,
            // (4)  2 Byte: ip.id
            0x00, 0x00,
            // (6)  2 Byte: flags (0) + fragment offset (0)
            0x00, 0x00,
            // (8)  1 Byte: TTL (255)
            0xff,
            // (9)  1 Byte: protocol: GRE (47)
            0x2f,
            // (10) 2 Byte: header checksum
            0x00, 0x00,
            // (12) 4 Byte: source IP
            0x00, 0x00, 0x00, 0x00,
            // (16) 4 Byte: destination IP
            0x00, 0x00, 0x00, 0x00,
        ];  // (20)  total 20 Byte
        IpHeader {
            _d: data,
        }
    }
    // create header from exist data
    pub fn new_from(data: &Vec<u8>) -> IpHeader {
        // ip header size: 20 Byte
        let mut d = vec![0; LEN];
        // copy data
        for i in 0..LEN {
            d[i] = data[i];
        }
        IpHeader {
            _d: d,
        }
    }

    // read/write data, as BE
    fn _get_u16(&self, index: usize) -> u16 {
        let mut o = 0;
        for i in 0..2 {
            o = (o << 8) | (self._d[i + index] as u16);
        }
        o
    }

    fn _get_u32(&self, index: usize) -> u32 {
        let mut o = 0;
        for i in 0..4 {
            o = (o << 8) | (self._d[i + index] as u32);
        }
        o
    }

    fn _set_u16(&mut self, index: usize, value: u16) {
        let mut t = value;
        for i in (0..2).rev() {
            self._d[i + index] = (t & 0xff) as u8;
            t = t >> 8;
        }
    }

    fn _set_u32(&mut self, index: usize, value: u32) {
        let mut t = value;
        for i in (0..4).rev() {
            self._d[i + index] = (t & 0xff) as u8;
            t = t >> 8;
        }
    }

    // exports method
    pub fn get_total_len(&self) -> u16 {
        self._get_u16(2)
    }

    pub fn set_total_len(&mut self, value: u16) {
        self._set_u16(2, value);
    }

    pub fn get_ip_id(&self) -> u16 {
        self._get_u16(4)
    }

    pub fn set_ip_id(&mut self, value: u16) {
        self._set_u16(4, value);
    }

    pub fn get_src_ip(&self) -> u32 {
        self._get_u32(12)
    }

    pub fn set_src_ip(&mut self, value: u32) {
        self._set_u32(12, value);
    }

    pub fn get_dst_ip(&self) -> u32 {
        self._get_u32(16)
    }

    pub fn set_dst_ip(&mut self, value: u32) {
        self._set_u32(16, value);
    }

    // update header checksum
    pub fn update_checksum(&mut self) {
        // clear old checksum
        self._set_u16(10, 0);

        let mut sum: u32 = 0;
        for i in 0..(self._d.len() / 2) {
            sum += self._get_u16(i * 2) as u32;
        }
        sum = (sum >> 16) + (sum & 0xffff);
    	sum += sum >> 16;
        // set new checksum
        self._set_u16(10, (! sum) as u16);
    }

    // get header data
    pub fn get_data(&self) -> Vec<u8> {
        self._d.clone()
    }
}
