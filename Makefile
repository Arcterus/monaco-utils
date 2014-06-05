PLATFORM ?= mac

RUSTC ?= rustc
RUSTCFLAGS ?= -O -L . -L src/rust-cocoa -L src/rust-core-foundation
OBJCC ?= clang
OBJCFLAGS ?= -framework AppKit -mmacosx-version-min=10.4.0

PROGS := monamod word_sub

ifeq ($(PLATFORM),mac)
	GUI_PLATFORM := monamod-mac
else
	$(error Unknown platform)
endif

all: $(PROGS)

monamod: $(GUI_PLATFORM)

monamod-mac: src/mac/*.h src/mac/*.m src/mac/Info.plist src/mac/en.lproj
	$(OBJCC) $(OBJCFLAGS) -o monamod src/mac/*.m
	mkdir -p Monamod.app/Contents/Resources
	mkdir -p Monamod.app/Contents/MacOS
	cp monamod Monamod.app/Contents/MacOS
	cp src/mac/Info.plist Monamod.app/Contents
	cp -r src/mac/en.lproj Monamod.app/Contents/Resources
	touch $@

word_sub: src/word_sub.rs libmonamod
	$(RUSTC) $(RUSTCFLAGS) -o $@ $<

libmonamod: src/lib.rs
	$(RUSTC) $(RUSTCFLAGS) $<
	touch $@

clean:
	rm -rf $(PROGS) libmonamod* monamod-mac
