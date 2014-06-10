extern crate monamod;

#[link(name = "AppKit", kind = "framework")]
extern { }

extern {
	pub fn objc_main();
}

fn main() {
	unsafe {
		objc_main();
	}
}
