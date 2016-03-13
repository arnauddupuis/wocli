# This Makefile is only designed to install wocli, nothing fancy here...

prefix=/usr/local

all: build

build:
	cp wocli.pl wocli

install: build
	install -m 0755 wocli $(prefix)/bin
	
uninstall:
	rm -f $(prefix)/bin/wocli

clean:
	rm wocli