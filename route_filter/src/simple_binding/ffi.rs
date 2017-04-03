// ffi: link to libnetfilter_queue
// <https://www.netfilter.org/projects/libnetfilter_queue/doxygen/>
#![allow(non_camel_case_types)]

extern crate libc;
extern crate errno;

use self::libc::{
    c_uint,
    uint8_t,
    uint16_t,
    uint32_t,
};
pub use self::libc::{
    c_int,
    c_void,
    c_char,
    c_uchar,

    AF_INET,
    AF_INET6,

    recv,
};


#[repr(C)]
pub enum nfqnl_config_mode {
    NFQNL_COPY_NONE = 0,
    NFQNL_COPY_META = 1,
    NFQNL_COPY_PACKET = 2,
}

pub const NF_DROP: u32 = 0;
pub const NF_ACCEPT: u32 = 1;
pub const NF_STOLEN: u32 = 2;
pub const NF_QUEUE: u32 = 3;
pub const NF_REPEAT: u32 = 4;
pub const NF_MAX_VERDICT: u32 = NF_REPEAT;

// extern struct, detail is not useful
#[repr(C)]
pub struct nfq_handle {
    _void: usize,
}
#[repr(C)]
pub struct nfq_q_handle {
    _void: usize,
}
#[repr(C)]
pub struct nfgenmsg {
    _void: usize,
}
#[repr(C)]
pub struct nfq_data {
    _void: usize,
}

pub type nfq_callback = extern "C" fn (
    qh: *mut nfq_q_handle,
    nfmsg: *mut nfgenmsg,
    nfad: *mut nfq_data,
    data: *mut c_void
) -> c_int;


#[link(name="netfilter_queue")]
extern {
    pub static nfq_errno: c_int;

    pub fn nfq_open() -> *mut nfq_handle;
    pub fn nfq_close(h: *mut nfq_handle) -> c_int;
    pub fn nfq_unbind_pf(h: *mut nfq_handle, pf: uint16_t) -> c_int;
    pub fn nfq_bind_pf(h: *mut nfq_handle, pf: uint16_t) -> c_int;

    pub fn nfq_destroy_queue(qh: *mut nfq_q_handle) -> c_int;
    pub fn nfq_set_mode(qh: *mut nfq_q_handle, mode: uint8_t, len: c_uint) -> c_int;
    pub fn nfq_set_queue_maxlen(qh: *mut nfq_q_handle, queuelen: uint32_t) -> c_int;
    pub fn nfq_fd(h: *mut nfq_handle) -> c_int;

    pub fn nfq_create_queue(
        h: *mut nfq_handle,
        num: uint16_t,
        cb: nfq_callback,
        data: *mut c_void
    ) -> *mut nfq_q_handle;

    pub fn nfq_handle_packet(h: *mut nfq_handle, buf: *mut c_char, len: c_int) -> c_int;
    pub fn nfq_set_verdict(
        qh: *mut nfq_q_handle,
        id: uint32_t,
        verdict: uint32_t,
        data_len: uint32_t,
        buf: *const c_uchar
    ) -> c_int;

    pub fn nfq_get_msg_packet_hdr(nfad: *mut nfq_data) -> *const nfqnl_msg_packet_hdr;
    pub fn nfq_get_payload(nfad: *mut nfq_data, data: *mut *mut c_uchar) -> c_int;
}

#[repr(C, packed)]
pub struct nfqnl_msg_packet_hdr {
    pub packet_id: uint32_t,
    pub hw_protocol: uint16_t,
    pub hook: uint8_t,
}


// FIXME
extern {
    pub fn ntohl(netlong: u32) -> u32;
}
