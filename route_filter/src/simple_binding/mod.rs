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
pub use self::packet::Packet;


pub trait Callback {
    fn callback(&mut self, queue: Queue, packet: Packet);
}

// init the libnetfilter_queue library
fn lib_init() -> Result<Handle, Error> {
    Handle::new()
    // TODO
}
