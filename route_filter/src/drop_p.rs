
extern crate libc;

use process_packet::ArgsInfo;


// use libc to get/set uid/gid
fn _getuid() -> u32 {
    unsafe { libc::getuid() }
}
fn _getgid() -> u32 {
    unsafe { libc::getgid() }
}
fn _setuid(uid: u32) {
    unsafe { libc::setuid(uid) };
    // TODO check return result
}
fn _setgid(gid: u32) {
    unsafe { libc::setgid(gid) };
    // TODO check return result
}


// TODO support different UID / GID
pub fn check_drop(a: &ArgsInfo) {
    // print current UID / GID
    let uid = _getuid();
    let gid = _getgid();

    println!("rf.DEBUG: uid = {}, gid = {} ", uid, gid);
    // check drop
    match a.drop_uid {
        Some(uid2) => {
            // check is root
            if 0 != uid {
                println!("rf.WARN: current not root, no DROP ");
                return;
            }
            println!("rf.DEBUG: drop to UID = {} ", uid);
            // try to drop
            _setgid(uid2);  // NOTE setgid before setuid, and gid is the same as uid
            _setuid(uid2);
            // check drop result
            let uid = _getuid();
            let gid = _getgid();
            println!("rf.DEBUG: (after drop) uid = {}, gid = {} ", uid, gid);

            if (uid != uid2) || (gid != uid2) {
                panic!("rf.ERROR: drop to uid = {} failed !", uid2);
            }
        },
        None => {
            println!("rf.WARN: no `--drop` in command line arguments ");
        }
    }
}
