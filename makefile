
DIST=dist

INSTALL_DIR=/usr/local/lib/vadsll
INSTALL_ETC=/usr/local/etc/vadsll
INSTALL_LOG=/var/log/vadsll


target: build
.PHONY: target


# TODO FIXME init before build
init: node_modules
.PHONY: init
node_modules:
	mkdir -p $(DIST)
	mkdir -p tmp
	npm install
	mkdir -p $(DIST)/vadsll

build: c rf
.PHONY: build

rf:
	cd route_filter; cargo build --release
	cp route_filter/target/release/vadsll_route_filter $(DIST)/route_filter
.PHONY: rf
c:
	node ./node_modules/.bin/coffee -o $(DIST)/vadsll src/
.PHONY: c


# $ sudo make install
install:
	mkdir -p $(INSTALL_DIR)
	mkdir -p $(INSTALL_ETC)
	mkdir -p $(INSTALL_LOG)

	cp -r $(DIST)/* -t $(INSTALL_DIR)
	cp etc/* -t $(INSTALL_ETC)
.PHONY: install

# $ sudo make uninstall
uninstall:
	rm -r $(INSTALL_DIR)
.PHONY: uninstall

clean:
	- rm -r $(DIST)
	- rm -r node_modules
	- rm -r route_filter/target
.PHONY: clean
