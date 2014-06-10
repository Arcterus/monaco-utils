PLATFORM ?= mac

RUSTC ?= rustc
RUSTCFLAGS ?= -O -L .
OBJCC ?= clang
OBJCFLAGS ?= -mmacosx-version-min=10.5.0

PROGS := monamod word_sub

LIBMONAMOD := $(shell rustc --crate-type=dylib --crate-file-name src/lib.rs)

ifeq ($(PLATFORM),mac)
	GUI_PLATFORM := monamod-mac
else
	$(error Unknown platform)
endif

all: $(PROGS)

monamod: $(GUI_PLATFORM)

monamod-mac: src/mac/*.h src/mac/*.m src/mac/*.rs src/mac/Info.plist src/mac/en.lproj $(LIBMONAMOD)
	$(OBJCC) $(OBJCFLAGS) -c src/mac/*.m
	$(RUSTC) $(RUSTFLAGS) -L . -C link-args="`ls . | grep '\.o'`" -o monamod src/mac/main.rs
	mkdir -p Monamod.app/Contents/Resources
	mkdir -p Monamod.app/Contents/MacOS
	cp monamod $(LIBMONAMOD) Monamod.app/Contents/MacOS
	cp src/mac/Info.plist Monamod.app/Contents
	cp -r src/mac/en.lproj Monamod.app/Contents/Resources
	touch $@

word_sub: src/word_sub.rs $(LIBMONAMOD)
	$(RUSTC) $(RUSTCFLAGS) -o $@ $<

$(LIBMONAMOD): src/lib.rs
	$(RUSTC) $(RUSTCFLAGS) $<

clean:
	rm -rf $(PROGS) libmonamod* monamod-mac *.o Monamod.app
