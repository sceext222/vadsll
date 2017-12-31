
BUILD_DIST=dist


target: build
.PHONY: target

init: node_modules
.PHONY: init
node_modules:
	npm install

build:
	# build route_filter
	cd route_filter; cargo build --release
	# compile coffee-script
	mkdir -p $(BUILD_DIST)/vadsll
	node ./node_modules/.bin/coffee -o $(BUILD_DIST)/vadsll src/
.PHONY: build


# common system install
_common_system_install:
	# create directory
	mkdir -p $(DESTDIR)/usr/lib/vadsll
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/etc/vadsll
	mkdir -p $(DESTDIR)/opt/vadsll
	# install route_filter
	install -Dm755 route_filter/target/release/vadsll_route_filter \
		$(DESTDIR)/usr/lib/vadsll/route_filter
	# install compiled js files
	cp -r $(BUILD_DIST)/vadsll -t $(DESTDIR)/usr/lib/vadsll
	# install node_modules
	cp -r node_modules -t $(DESTDIR)/opt/vadsll
	ln -s /opt/vadsll/node_modules $(DESTDIR)/usr/lib/vadsll
	# install config files
	install -Dm644 etc/config.toml.example -t $(DESTDIR)/etc/vadsll
	install -Dm644 etc/config.toml.zh_CN.example -t $(DESTDIR)/etc/vadsll
	# install bin commands
	install -Dm755 os/vadsll.sh $(DESTDIR)/usr/lib/vadsll/vadsll.sh
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll
	ln -s vadsll $(DESTDIR)/usr/bin/vadsll-show
	ln -s vadsll $(DESTDIR)/usr/bin/vadsll-login
	ln -s vadsll $(DESTDIR)/usr/bin/vadsll-logout
	ln -s vadsll $(DESTDIR)/usr/bin/vadsll-log
	ln -s vadsll $(DESTDIR)/usr/bin/vadsll-conf
	ln -s vadsll $(DESTDIR)/usr/bin/vadsll-passwd
.PHONY: _common_system_install

# install systemd unit files to default location
_common_install_systemd:
	# install systemd unit file
	install -Dm644 os/systemd/vadsll.service -t $(DESTDIR)/usr/lib/systemd/system/
.PHONY: _common_install_systemd

# system install for ArchLinux
system-install-archlinux: _common_system_install _common_install_systemd
	# install os mark
	install -Dm644 os/ArchLinux/os $(DESTDIR)/usr/lib/vadsll/os
.PHONY: system-install-archlinux

# system install for Fedora
system-install-fedora: _common_system_install _common_install_systemd
	# install os mark
	install -Dm644 os/Fedora25/os $(DESTDIR)/usr/lib/vadsll/os
	# TODO install node
.PHONY: system-install-fedora

# system install for UbuntuLTS
system-install-ubuntu-lts: _common_system_install
	# install systemd unit file
	install -Dm644 os/systemd/vadsll.service -t $(DESTDIR)/lib/systemd/system/
	# install os mark
	install -Dm644 os/Ubuntu16.04LTS/os $(DESTDIR)/usr/lib/vadsll/os
	# install node
	# FIMXE link node to right place
	#ln -s node-bin/bin/node $(DESTDIR)/opt/vadsll/node
.PHONY: system-install-ubuntu-lts

# system install for Raspberrypi3B
system-install-raspberrypi3b: _common_system_install
	# install systemd unit file
	install -Dm644 os/systemd/vadsll.service -t $(DESTDIR)/lib/systemd/system/
	# install os mark
	install -Dm644 os/Raspberrypi3B/os $(DESTDIR)/usr/lib/vadsll/os
	# TODO install node
.PHONY: system-install-raspberrypi3b


clean:
	- rm -r $(BUILD_DIST)
	- rm -r node_modules
	- rm -r route_filter/target
.PHONY: clean

# NOTE not support local install
