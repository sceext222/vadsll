
use std::ptr::null;

use super::{
    ffi,
    Error,
    ErrType,
    err_,
};
use super::queue::PACKET_BUFFER_SIZE;


pub enum VerdictType {
    Drop,
    Accept,
    Stolen,
    // queue_num: u16
    Queue(u16),
    Repeat,
    _Max,
}

impl VerdictType {
    fn as_u32(&self) -> u32 {
        match *self {
            VerdictType::Drop => ffi::NF_DROP,
            VerdictType::Accept => ffi::NF_ACCEPT,
            VerdictType::Stolen => ffi::NF_STOLEN,
            VerdictType::Queue(queue_num) => ffi::NF_QUEUE | (queue_num as u32) << 16,
            VerdictType::Repeat => ffi::NF_REPEAT,
            VerdictType::_Max => ffi::NF_MAX_VERDICT,
        }
    }
}


pub struct Packet {
    _h: *mut ffi::nfq_handle,
    _qh: *mut ffi::nfq_q_handle,

    // packet_id
    _id: u32,
    // packet data (payload)
    _buffer: [u8; PACKET_BUFFER_SIZE],
    _len: usize,
}

impl Packet {
    pub fn new(h: *mut ffi::nfq_handle, qh: *mut ffi::nfq_q_handle, nfad: *mut ffi::nfq_data) -> Result<Packet, Error> {
        let mut buffer = [0; PACKET_BUFFER_SIZE];
        // get packet info
        let header = unsafe {
            let hdr = ffi::nfq_get_msg_packet_hdr(nfad);
            match (&hdr).as_ref() {
                Some(h) => h,
                None => {
                    return Err(err_(ErrType::GetPacketHeader, "nfq_get_msg_packet_hdr()", None));
                }
            }
        };
        // FIXME
        println!("DEBUG: Packet::new(): packet_id = {}", header.packet_id);

        // get packet data
        match unsafe { _get_payload(&mut buffer, nfad) } {
            Err(e) => Err(e),
            Ok(len) => Ok(Packet {
                _h: h,
                _qh: qh,
                _id: header.packet_id,
                _buffer: buffer,
                _len: len,
            })
        }
    }

    // get packet id
    pub fn id(&self) -> u32 {
        self._id
    }

    pub fn get_data(&self) -> Vec<u8> {
        let mut o = vec![0; self._len];
        // FIXME simple copy
        for i in 0..o.len() {
            o[i] = self._buffer[i];
        }
        o
    }

    pub fn set_data(&mut self, data: &Vec<u8>) -> Result<(), Error> {
        // check length
        if data.len() > self._buffer.len() {
            return Err(err_(ErrType::PacketDataTooLong, &format!("Packet.set_data(): data length can to exceed {} Byte", self._buffer.len()), None));
        }
        // do not forget to update len
        self._len = data.len();
        // copy data to buffer
        for i in 0..self._len {
            self._buffer[i] = data[i];
        }
        Ok(())
    }

    pub fn verdict(self, vtype: VerdictType) {
        unsafe { ffi::nfq_set_verdict(
            self._qh,
            self._id,
            vtype.as_u32(),
            self._len as u32,
            // FIXME
            (self._buffer).as_ptr() as *mut ffi::c_uchar
        ) };
        // FIXME error process
    }
}


unsafe fn _get_payload(buffer: &mut [u8; PACKET_BUFFER_SIZE], nfad: *mut ffi::nfq_data) -> Result<usize, Error> {
    // FIXME FIXME FIXME FIXME
    let mut data: *mut u8 = 0 as usize as *mut u8;
    // FIXME
    //let ptr: *mut *mut u8 = &mut (data as *mut u8);
    // FIXME
    println!("DEBUG: packet._get_payload: ptr: data = {}, ptr = {}", data as usize, (&mut data) as *mut *mut u8 as usize);

    let len = ffi::nfq_get_payload(nfad, (&mut data) as *mut *mut ffi::c_uchar);
    if len < 0 {
        return Err(err_(ErrType::GetPacketData, "nfq_get_payload()", Some(len)));
    }
    // FIXME
    println!("DEBUG: packet._get_payload: ptr.2: data = {}, ptr = {}", data as usize, (&mut data) as *mut *mut u8 as usize);

    let len = len as usize;
    // copy data to buffer
    match (data as *mut [u8; PACKET_BUFFER_SIZE]).as_ref() {
        None => {
            return Err(err_(ErrType::GetPacketData, &format!("nfq_get_payload(): null data pointer, len = {}", len), None));
        },
        Some(data) => {
            for i in 0..len {
                buffer[i] = data[i];
            }
            Ok(len)
        }
    }
}
