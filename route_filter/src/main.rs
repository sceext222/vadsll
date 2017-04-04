
use std::process::exit;

mod simple_binding;
mod ip_header;
mod header;
mod process_packet;


fn main() {
    match process_packet::p_args() {
        Some(a) => {
            process_packet::process_loop(&a);
        },
        _ => {
            exit(1);
        }
    }
}

#[cfg(test)]
mod test;
