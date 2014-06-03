use std::io;
use std::os;
use std::str;

fn main() {
	let args = os::args_as_bytes();

	if args.len() < 3 {
		fail!();
	}

	let orig = args.get(1);
	let replace = args.get(2);

	let mut file = io::File::open_mode(&Path::new("All.lang"), io::Open, io::ReadWrite).unwrap();
	let mut code = file.read_to_end().unwrap();

	let vec: Vec<u8> = orig.iter().flat_map(|&x| (box [x, 0, 0, 0]).move_iter()).take(4 * orig.len() - 3).collect();
	let sub: Vec<u8> = replace.iter().flat_map(|&x| (box [x, 0, 0, 0]).move_iter()).take(4 * replace.len() - 3).collect();

	println!("file length: {}", code.len());
	let len = vec.len();
	let mut x = 0;
	while x < code.len() - len {
		if code.slice(x, x + len) == vec.as_slice() {
			let mut count: int = 0;
			for _ in range(0, len) {
				code.remove(x);
				count -= 1;
			}
			for i in range(0, sub.len()).rev() {
				code.insert(x, *sub.get(i));
				count += 1;
			}
			for offset in std::iter::range_step::<uint>(0x148c, 0x6630, 0x10) {
				let mut val = *code.get(offset) as u32 + (*code.get(offset + 1) as u32 << 8) + (*code.get(offset + 2) as u32 << 16) + (*code.get(offset + 3) as u32 << 24);
				if val > x as u32 {
					val = (val as i64 + count as i64) as u32;
					code.remove(offset);
					code.remove(offset);
					code.remove(offset);
					code.remove(offset);
					code.insert(offset, (val >> 24) as u8);
					code.insert(offset, (val >> 16) as u8);
					code.insert(offset, (val >> 8) as u8);
					code.insert(offset, val as u8);
				}
			}
			println!("index of \"{}\": {}", str::from_utf8(orig.as_slice()).unwrap(), x);
			x = (x as int + count) as uint;
		}
		x += 1;
	}
	let _ = file.seek(0, io::SeekSet);
	let _ = file.write(code.as_slice());
}
