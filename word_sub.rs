use std::io;
use std::num;
use std::os;
use std::str;

fn main() {
	let args = os::args_as_bytes();

	if args.len() < 3 {
		fail!();
	}

	let orig = args.get(1);
	let replace = args.get(2);
	if orig.len() < replace.len() {
		let _ = writeln!(&mut io::stderr() as &mut Writer,
		                 "warning: original string length should be >= new string \
		                  length");
	}

	let mut file = io::File::open_mode(&Path::new("All.lang"), io::Open, io::ReadWrite).unwrap();
	let mut code = file.read_to_end().unwrap();

	let mut vec: Vec<u8> = orig.iter().flat_map(|&x| (box [x, 0, 0, 0]).move_iter()).take(4 * orig.len() - 3).collect();
	let mut sub: Vec<u8> = replace.iter().flat_map(|&x| (box [x, 0, 0, 0]).move_iter()).take(4 * replace.len() - 3).collect();
	equilize(&mut vec, &mut sub);

	println!("file length: {}", code.len());
	let len = vec.len();
	for x in range(0, code.len() - len) {
		if code.slice(x, x + len) == vec.as_slice() {
			for i in range(0, len) {
				code.insert(x + len, *sub.get(i));
				code.remove(x);
			}
			println!("index of \"{}\": {}", str::from_utf8(orig.as_slice()).unwrap(), x);
		}
	}
	let _ = file.seek(0, io::SeekSet);
	let _ = file.write(code.as_slice());
}

fn equilize(a: &mut Vec<u8>, b: &mut Vec<u8>) {
	let alen = a.len();
	let blen = b.len();
	let pushee = if alen > blen { b } else { a };
	for _ in range(0, num::abs(alen as int - blen as int) as uint) {
		pushee.push(0);
	}
}
