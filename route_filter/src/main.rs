
use std::process::exit;

mod simple_binding;
mod ip_header;
mod header;
mod process_packet;

use process_packet::{
    p_args,
    process_loop,
    PargsResult,
};

// TODO FIXME exit function
fn main() {
    match p_args() {
        PargsResult::Ok(a) => {
            process_loop(&a);
        },
        PargsResult::Err => {
            exit(1);
        },
        _ => ()
    }
}

#[cfg(test)]
mod test;
