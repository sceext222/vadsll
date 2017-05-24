
BUILD_DIST=dist

# TODO support local install (not system install)

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


# system install for ArchLinux
system-install-archlinux:
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
	# install systemd unit file
	install -Dm644 os/systemd/vadsll.service $(DESTDIR)/usr/lib/systemd/system
	# install os mark
	install -Dm644 os/ArchLinux/os $(DESTDIR)/usr/lib/vadsll/os
	# install bin commands
	install -Dm755 os/vadsll.sh $(DESTDIR)/usr/lib/vadsll/vadsll.sh
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll-show
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll-login
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll-logout
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll-log
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll-conf
	ln -s /usr/lib/vadsll/vadsll.sh $(DESTDIR)/usr/bin/vadsll-passwd

.PHONY: system-install-archlinux


clean:
	- rm -r $(BUILD_DIST)
	- rm -r node_modules
	- rm -r route_filter/target
.PHONY: clean
