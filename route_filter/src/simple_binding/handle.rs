// library handle for libnetfilter_queue
use super::{
    ffi,
    Error,
    ErrType,
    err_,
    Queue,
    Callback,
};


pub enum ProtocolFamily {
    INET = ffi::AF_INET as isize,
    INET6 = ffi::AF_INET6 as isize,
}

pub struct Handle {
    _h: *mut ffi::nfq_handle,
}

impl Handle {
    pub fn new() -> Result<Handle, Error> {
        // open library handle
        let h = unsafe { ffi::nfq_open() };
        if h.is_null() {
            Err(err_(ErrType::OpenLibHandle, "nfq_open(): open library handle", None))
        } else {
            Ok(Handle {
                _h: h
            })
        }
    }

    pub fn unbind(&mut self, pf: ProtocolFamily) -> Result<(), Error> {
        let r = unsafe { ffi::nfq_unbind_pf(self._h, pf as u16) };
        if r < 0 {
            Err(err_(ErrType::Unbind, "nfq_unbind_pf(): unbind existing nf_queue handler for AF_INET (if any)", Some(r)))
        } else {
            Ok(())
        }
    }

    pub fn bind(&mut self, pf: ProtocolFamily) -> Result<(), Error> {
        let r = unsafe { ffi::nfq_bind_pf(self._h, pf as u16) };
        if r < 0 {
            Err(err_(ErrType::Bind, "nfq_bind_pf(): bind nfnetlink_queue as nf_queue handler for AF_INET", Some(r)))
        } else {
            Ok(())
        }
    }

    // library (handle) high level init function
    pub fn init(&mut self) -> Result<(), Error> {
        // TODO FIXME is this step essential  ?
        match self.unbind(ProtocolFamily::INET) {
            Err(e) => {
                return Err(e);
            },
            _ => ()
        }
        match self.bind(ProtocolFamily::INET) {
            Err(e) => {
                return Err(e);
            },
            _ => ()
        }
        Ok(())
    }

    // create a queue
    pub fn queue(&mut self, num: u16, cb: Box<Callback>) -> Result<Box<Queue>, Error> {
        Queue::new(self._h, num, cb)
    }
}

impl Drop for Handle {
    fn drop(&mut self) {
        unsafe { ffi::nfq_close(self._h) };
        // TODO failed to close nfq_handle
    }
}
