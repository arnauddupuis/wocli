# This Makefile is only designed to install wocli, nothing fancy here...

prefix=/usr/local

all: install

install: uninstall
	install -m 0755 wocli $(prefix)/bin/
	
uninstall:
	rm -f $(prefix)/bin/wocli.pl
	rm -f $(prefix)/bin/wocli
