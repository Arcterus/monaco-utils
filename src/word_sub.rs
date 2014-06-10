extern crate monamod;

use std::io;
use std::os;

fn main() {
	let args = os::args();

	if args.len() < 3 {
		let _ = writeln!(&mut io::stderr() as &mut Writer, "expected at least two arguments");
		os::set_exit_status(1);
	} else {
		monamod::sub_word(args.tail());
	}
}
