
use simple_binding;
use simple_binding::{
    QueueMode,
    Packet,
    VerdictType,
};


struct TestCb {
    _count: usize,
}

impl TestCb {
    pub fn new() -> TestCb {
        TestCb {
            _count: 0,
        }
    }

    fn _process_one(&mut self, mut p: Packet) {
        println!("DEBUG: packet_id = {}", p.id());
        // test get and set data
        let data = p.get_data();
        println!("DEBUG: packet data, len = {}", data.len());
        p.set_data(&data).unwrap();
        // set verdict
        println!("DEBUG: set verdict to Accept");
        p.verdict(VerdictType::Accept);
    }
}

impl simple_binding::Callback for TestCb {
    fn callback(&mut self, packet: Result<Packet, simple_binding::Error>) {
        self._count += 1;
        println!("DEBUG: callback: recv {} packet", self._count);

        self._process_one(packet.unwrap());
    }
}

#[test]
fn simple_binding() {
    println!("DEBUG: start init library");
    let mut h = simple_binding::lib_init().unwrap();

    let cb = Box::new(TestCb::new());
    // test queue_num = 1
    let queue_num = 1;
    println!("DEBUG: create queue, queue_num = {}", queue_num);
    let mut q = h.queue(queue_num, cb).unwrap();
    println!("DEBUG: init queue");
    q.init(QueueMode::CopyPacket).unwrap();
    // test recv packet count
    let test_count = 4;
    println!("DEBUG: test recv {} packet", test_count);

    for _ in 0..test_count {
        let r = q.recv_one();
        println!("DEBUG: q.recv_one() -> {}", r);
    }
    println!("DEBUG: test done");
}
