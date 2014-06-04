#![crate_id = "monamod#0.1"]

#![crate_type = "dylib"]

use std::io;

pub static STRING_TABLE_START: uint = 0x1480;
pub static STRING_TABLE_END: uint = 0x6630;

pub fn sub_word(args: Vec<String>) {
	let orig = args.get(1);
	let replace = args.get(2);

	let mut file = io::File::open_mode(&Path::new("All.lang"), io::Open, io::ReadWrite).unwrap();
	let mut code = file.read_to_end().unwrap();

	let vec: Vec<u8> = orig.as_slice().bytes().flat_map(|x| (box [x as u8, 0, 0, 0]).move_iter()).take(4 * orig.len() - 3).collect();
	let sub: Vec<u8> = replace.as_slice().bytes().flat_map(|x| (box [x as u8, 0, 0, 0]).move_iter()).take(4 * replace.len() - 3).collect();

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
			for offset in std::iter::range_step::<uint>(STRING_TABLE_START + 0xc, STRING_TABLE_END, 0x10) {
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
			println!("index of \"{}\": {}", orig.as_slice(), x);
			x = (x as int + count) as uint;
		}
		x += 1;
	}
	let _ = file.seek(0, io::SeekSet);
	let _ = file.write(code.as_slice());
}