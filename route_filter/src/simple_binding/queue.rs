
use std::mem;
use std::ptr::null;

use super::{
    ffi,
    Error,
    ErrType,
    err_,
    Callback,
    Packet,
};


#[derive(Debug, Clone, Copy)]
pub enum QueueMode {
    CopyNone = ffi::nfqnl_config_mode::NFQNL_COPY_NONE as isize,
    CopyMeta = ffi::nfqnl_config_mode::NFQNL_COPY_META as isize,
    CopyPacket = ffi::nfqnl_config_mode::NFQNL_COPY_PACKET as isize,
}

// buffer size: 4 KB
pub const PACKET_BUFFER_SIZE: usize = 4096;

pub struct Queue {
    _h: *mut ffi::nfq_handle,
    _qh: *mut ffi::nfq_q_handle,

    _fd: ffi::c_int,
    _buffer: [u8; PACKET_BUFFER_SIZE],

    _cb: Box<Callback>,
}

// callback function from libnetfilter_queue
#[allow(unused_variables)]
extern fn _f_callback(qh: *mut ffi::nfq_q_handle, nfmsg: *mut ffi::nfgenmsg, nfad: *mut ffi::nfq_data, data: *mut ffi::c_void) -> ffi::c_int {
    let p_queue: *mut Queue = unsafe { mem::transmute(data) };
    let q: &mut Queue = unsafe { (&p_queue).as_mut().unwrap() };
    // do callback
    q._callback(nfad) as ffi::c_int
}

impl Queue {
    pub fn new(h: *mut ffi::nfq_handle, num: u16, cb: Box<Callback>) -> Result<Box<Queue>, Error> {
        let p_zero: *const ffi::nfq_q_handle = null();
        let mut o: Box<Queue> = Box::new(Queue {
            _h: h,
            _qh: p_zero as *mut ffi::nfq_q_handle,
            _fd: 0,
            _buffer: [0; PACKET_BUFFER_SIZE],
            _cb: cb,
        });
        let p_q: *mut Queue = &mut * o;

        let qh = unsafe { ffi::nfq_create_queue(h, num, _f_callback, mem::transmute(p_q)) };
        if qh.is_null() {
            return Err(err_(ErrType::CreateQueue, &format!("nfq_create_queue(): bind this socket to {}", num), None));
        } else {
            o._qh = qh;
        }
        Ok(o)
    }

    pub fn _callback(&mut self, nfad: *mut ffi::nfq_data) -> isize {
        let p = Packet::new(self._h, self._qh, nfad);
        self._cb.callback(p);
        // FIXME error process
        0
    }

    pub fn set_mode(&mut self, mode: QueueMode) -> Result<(), Error> {
        let len = self._buffer.len() as u32;
        let r = unsafe { ffi::nfq_set_mode(self._qh, mode as u8, len) };
        if r < 0 {
            Err(err_(ErrType::SetMode, &format!("nfq_set_mode(): set copy_packet mode to {:?}", mode), Some(r)))
        } else {
            Ok(())
        }
    }

    pub fn set_maxlen(&mut self, len: u32) -> Result<(), Error> {
        let r = unsafe { ffi::nfq_set_queue_maxlen(self._qh, len) };
        if r < 0 {
            Err(err_(ErrType::SetMaxlen, &format!("nfq_set_queue_max_len(): set len to {}", len), Some(r)))
        } else {
            Ok(())
        }
    }

    pub fn init_fd(&mut self) {
        self._fd = unsafe { ffi::nfq_fd(self._h) };
    }

    // queue high level init function
    pub fn init(&mut self, mode: QueueMode) -> Result<(), Error> {
        match self.set_mode(mode) {
            Err(e) => {
                return Err(e);
            },
            _ => ()
        }
        self.init_fd();
        Ok(())
    }

    // if return <= 0, should exit loop
    pub fn recv_one(&mut self) -> usize {
        let rv = unsafe { ffi::recv(self._fd, self._buffer.as_mut_ptr() as *mut ffi::c_void, self._buffer.len(), 0) };
        if rv > 0 {
            unsafe { ffi::nfq_handle_packet(self._h, self._buffer.as_mut_ptr() as *mut ffi::c_char, rv as i32) };
        }
        rv as usize
    }
}

impl Drop for Queue {
    fn drop(&mut self) {
        unsafe { ffi::nfq_destroy_queue(self._qh) };
    }
}
