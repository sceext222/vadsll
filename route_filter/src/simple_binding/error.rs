
use std::error::Error as Base;
use std::fmt;

use super::{
    ffi,
};


#[derive(Debug)]
pub enum ErrType {
    OpenLibHandle,
    Unbind,
    Bind,
    CreateQueue,
    SetMode,
    SetMaxlen,
    GetPacketHeader,
    GetPacketData,
    PacketDataTooLong,
    // packet length > MTU 1500
    PacketTooLong,
}

// FIXME use errno
pub struct Error {
    _type: ErrType,
    _ret: Option<ffi::c_int>,
    _errno: ffi::c_int,

    description: String,
    cause: Option<Box<Base>>,
}

impl fmt::Debug for Error {
    fn fmt(&self, o: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        let text = match self._ret {
            Some(r) => format!(
                "{:?}: {:?} (errno: {}, ret: {}, cause: {:?})",
                self._type,
                self.description,
                self._errno,
                r,
                self.cause
            ),
            _ => format!(
                "{:?}: {:?} (errno: {}, cause: {:?})",
                self._type,
                self.description,
                self._errno,
                self.cause
            )
        };
        o.write_str(text.as_ref())
    }
}

impl fmt::Display for Error {
    fn fmt(&self, o: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        let text = format!(
            "{:?}: {:?}",
            self._type,
            self.description
        );
        o.write_str(text.as_ref())
    }
}

impl Base for Error {
    fn description(&self) -> &str {
        self.description.as_ref()
    }
    fn cause(&self) -> Option<&Base> {
        self.cause.as_ref().map(|c| &**c)
    }
}

// create a Error object
pub fn err_(t: ErrType, msg: &str, ret: Option<ffi::c_int>) -> Error {
    Error {
        _type: t,
        _ret: ret,
        _errno: unsafe { ffi::nfq_errno },

        description: msg.to_string(),
        cause: None,
    }
}
