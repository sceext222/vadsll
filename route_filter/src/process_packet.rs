
use std::env;

use simple_binding;
use simple_binding::{
    QueueMode,
    Packet,
    VerdictType,
};
use header::HeaderP;


// # command line process part
const P_VERSION: &'static str = "vadsll: route_filter version 0.1.0 test20170406 2208";
// command line arguments and usage
fn _print_help() {
    println!("{}",
"route_filter for vadsll
Usage:
    --queue QUEUE_NUM  Number (ID) of the queue (of nftables NFQUEUE) to process
    --src-ip SRC_IP    Source IP address (local interface)
    --dst-ip DST_IP    Destination IP address (the transfer gateway)

    --mtu MTU          MTU of Ethernet (default: 1500 Byte)

    --help             Show this help text
    --version          Show version of this program

vadsll: <https://github.com/sceext222/vadsll>");
}


pub struct ArgsInfo {
    pub queue: u16,
    pub src_ip: u32,
    pub dst_ip: u32,
    pub mtu: usize,
}

impl ArgsInfo {
    pub fn new() -> ArgsInfo {
        ArgsInfo {
            queue: 1,
            src_ip: 0,
            dst_ip: 0,
            mtu: 1500,
        }
    }
}

pub enum PargsResult {
    Ok(ArgsInfo),
    Err,
    None,
}

// parse process command line arguments and get some info
pub fn p_args() -> PargsResult {
    let args: Vec<String> = env::args().collect();
    // check empty argument
    if args.len() < 2 {
        _bad_args();
        return PargsResult::Err;
    }
    let mut o = ArgsInfo::new();
    // ignore first argument
    let mut i = 1;
    while i < args.len() {
        let a = &args[i];  i += 1;
        if a == "--help" {
            _print_help();
            return PargsResult::None;
        } else if a == "--version" {
            _print_version();
            return PargsResult::None;
        } else if a == "--queue" {
            match u16::from_str_radix(&args[i], 10) {
                Ok(id) => {
                    o.queue = id;
                },
                _ => {
                    // FIXME improve error info
                    _bad_args();
                    return PargsResult::Err;
                }
            }
            i += 1;
        } else if a == "--src-ip" {
            match _parse_ip(&args[i]) {
                Some(ip) => {
                    o.src_ip = ip;
                },
                _ => {
                    _bad_args();
                    return PargsResult::Err;
                }
            }
            i += 1;
        } else if a == "--dst-ip" {
            match _parse_ip(&args[i]) {
                Some(ip) => {
                    o.dst_ip = ip;
                },
                _ => {
                    _bad_args();
                    return PargsResult::Err;
                }
            }
            i += 1;
        } else if a == "--mtu" {
            match usize::from_str_radix(&args[i], 10) {
                Ok(mtu) => {
                    o.mtu = mtu;
                },
                _ => {
                    _bad_args();
                    return PargsResult::Err;
                }
            }
            i += 1;
        } else {
            // FIXME print to stderr
            println!("rf.ERROR: unknow comamnd line argument `{}`. Please try `--help` ", a);
            return PargsResult::Err;
        }
    }
    // check bad command line
    if (o.src_ip == 0) || (o.dst_ip == 0) {
        _bad_args();
        return PargsResult::Err;
    }
    PargsResult::Ok(o)
}

// parse IPv4 addr, eg: 10.0.0.1
fn _parse_ip(raw: &str) -> Option<u32> {
    let mut o: u32 = 0;
    let p: Vec<&str> = raw.split('.').collect();
    if p.len() != 4 {
        return None;
    }
    for i in 0..p.len() {
        match u8::from_str_radix(p[i], 10) {
            Ok(n) => {
                o = (o << 8) | (n as u32);
            },
            _ => {
                return None;
            }
        }
    }
    Some(o)
}

fn _print_version() {
    println!("{}", P_VERSION);
}

// FIXME print to stderr
fn _bad_args() {
    println!("rf.ERROR: bad command line. Please try `--help` ");
}

fn _print_ip(ip: u32) -> String {
    let a: u8 = ((ip >> (8 * 3)) & 0xff) as u8;
    let b: u8 = ((ip >> (8 * 2)) & 0xff) as u8;
    let c: u8 = ((ip >> (8 * 1)) & 0xff) as u8;
    let d: u8 = (ip & 0xff) as u8;
    format!("{}.{}.{}.{}", a, b, c, d)
}


// # packet process part (route filter core)

struct PacketP {
    _p: HeaderP,
}

impl PacketP {
    pub fn new(a: &ArgsInfo) -> PacketP {
        let mut p = HeaderP::new();
        // set config
        p.set_mtu(a.mtu);
        p.set_src_ip(a.src_ip);
        p.set_dst_ip(a.dst_ip);

        PacketP {
            _p: p,
        }
    }
}

impl simple_binding::Callback for PacketP {
    fn callback(&mut self, packet: Result<Packet, simple_binding::Error>) {
        let mut p = packet.unwrap();
        let data = p.get_data();
        // add header
        let data = self._p.add_header(&data);

        p.set_data(&data).unwrap();
        p.verdict(VerdictType::Accept);
    }
}


pub fn process_loop(a: &ArgsInfo) {
    // DEBUG
    println!("rf.DEBUG: queue = {}, src_ip = {}, dst_ip = {}, MTU = {} ",
        a.queue, _print_ip(a.src_ip), _print_ip(a.dst_ip), a.mtu);
    // init library
    let mut h = simple_binding::lib_init().unwrap();

    let cb = Box::new(PacketP::new(a));
    println!("rf.DEBUG: create queue");
    let mut q = h.queue(a.queue, cb).unwrap();
    q.init(QueueMode::CopyPacket).unwrap();

    // TODO support exit function
    // recv packet loop
    println!("rf.DEBUG: enter recv packet loop");
    loop {
        q.recv_one();
    }
    // FIXME
}
