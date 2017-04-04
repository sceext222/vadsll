// A simple_binding to libnetfilter_queue

mod ffi;

mod error;
mod handle;
mod queue;
mod packet;

pub use self::error::{
    Error,
    ErrType,
    err_
};
pub use self::handle::{
    Handle,
    ProtocolFamily,
};
pub use self::queue::{
    Queue,
    QueueMode,
};
pub use self::packet::{
    Packet,
    VerdictType,
};


pub trait Callback {
    fn callback(&mut self, packet: Result<Packet, Error>);
}

// high level simple init function (init the libnetfilter_queue library)
pub fn lib_init() -> Result<Handle, Error> {
    match Handle::new() {
        Err(e) => Err(e),
        Ok(mut h) => match h.init() {
            Err(e) => Err(e),
            _ => Ok(h)
        }
    }
}
