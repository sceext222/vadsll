
DIST=dist

INSTALL_DIR=/usr/local/lib/vadsll
INSTALL_ETC=/usr/local/etc/vadsll
INSTALL_LOG=/var/log/vadsll


target: build
.PHONY: target


# TODO FIXME init before build
init:
	mkdir -p $(DIST)
	mkdir -p tmp
	npm install
	mkdir -p $(DIST)/vadsll
.PHONY: init

build:
	node ./node_modules/.bin/coffee -o $(DIST)/vadsll src
	cd route_filter; cargo build --release
	cp route_filter/target/release/vadsll_route_filter $(DIST)/route_filter


# $ sudo make install
install:
	mkdir -p $(INSTALL_DIR)
	mkdir -p $(INSTALL_ETC)
	mkdir -p $(INSTALL_LOG)

	cp $(DIST)/* $(INSTALL_DIR)
	cp etc/* $(INSTALL_ETC)
.PHONY: install

# $ sudo make uninstall
uninstall:
	rm -r $(INSTALL_DIR)
.PHONY: uninstall

clean:
	rm -r $(DIST)
	rm -r node_modules
	rm -r route_filter/target
.PHONY: clean
