# RPM spec file for vadsll (Fedora 25)

Summary: Virtual ADSL for Linux (for Fedora 25)
Name: vadsll
Version: 1.0.0_1
Release: 1%{?dist}
License: GPLv3+
URL: https://github.com/sceext222/vadsll
Packager: sceext <sceext@foxmail.com>
Group: Applications/System
Requires: nodejs, nftables, libnetfilter_queue
BuildRequires: npm, rust, cargo, libnetfilter_queue-devel
Source0: vadsll-1.0.0-1.tar.gz
Source1: https://nodejs.org/dist/v7.10.0/node-v7.10.0-linux-x64.tar.xz
BuildArch: x86_64
BuildRoot: %{_tmppath}/%{name}-%{version}-root

%prep
%setup -q -n vadsll-1.0.0-1


%build
make init
make build

%install
make DESTDIR=%{buildroot} system-install-fedora
# install node
tar -C %{buildroot}/opt/vadsll -xf %SOURCE1
ln -s node-v7.10.0-linux-x64/bin/node %{buildroot}/opt/vadsll/node

%clean
#rm -rf %{buildroot}

%files
%defattr(-,root,root)
/usr/bin/vadsll*
/usr/lib/vadsll/
/usr/lib/systemd/system/vadsll.service
/etc/vadsll/
/opt/vadsll/

%post
# msg show to user
_msg() {
  echo "  -> Please modify config file with command \`vadsll-conf\` "
  echo "  -> And set password with command \`vadsll-passwd\` "
  echo "  -> More information online <https://github.com/sceext222/vadsll> "
}

post_install() {
  # create vadsll system user
  useradd --system --shell /usr/sbin/nologin --home-dir /usr/lib/vadsll --comment "System user for VADSLL " vadsll

  _msg
}

post_install

%preun
pre_remove() {
  echo "  Stop vadsll service .. . "
  systemctl stop vadsll

  # remove vadsll system user
  userdel vadsll
}
pre_remove

%description
Virtual ADSL tools for Linux (for Fedora 25)
Please see <https://github.com/sceext222/vadsll> for more information.

%changelog

# EOF
