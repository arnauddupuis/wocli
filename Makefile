# This Makefile is only designed to install wocli, nothing fancy here...

prefix=/usr/local

all: install

install:
	install -m 0755 wocli.pl $(prefix)/bin
	ln -s $(prefix)/bin/wocli.pl $(prefix)/bin/wocli
	
uninstall:
	rm -f $(prefix)/bin/wocli.pl
	rm -f $(prefix)/bin/wocli