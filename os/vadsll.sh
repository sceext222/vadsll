#!/bin/bash
# vadsll.sh, vadsll/os/
# vadsll start script, only used in system install mode

# global config
NODE_BIN=/usr/bin/node
VADSLL_BIN=/usr/lib/vadsll/vadsll/vadsll.js

VADSLL_CONFIG_FILE=/etc/vadsll/config.toml
VADSLL_CONFIG_EXAMPLE=/etc/vadsll/config.toml.zh_CN.example
VADSLL_PASSWD_FILE=/etc/vadsll/shadow
# default text editor is `gedit`
DEFAULT_EDITOR=gedit


OS_TYPE_FILE=/usr/lib/vadsll/os
# check os type
_check_os_type() {
  local _os
  _os=$(cat $OS_TYPE_FILE)
  case $_os in
    UbuntuLTS|Ubuntu|Fedora|CentOS)
      NODE_BIN=/opt/vadsll/node
      ;;
    # default as ArchLinux
    *)
      NODE_BIN=/usr/bin/node
      ;;
  esac
}


# sub commands

# run vadsll (bin)
_vadsll() {
  _check_os_type
  $NODE_BIN $VADSLL_BIN $*
}

# show vadsll running status
_vadsll_show() {
  systemctl status vadsll
}

# NOTE run this as root (sudo)
# start login
_vadsll_login() {
  systemctl start vadsll
}

# NOTE run this as root (sudo)
# start logout
_vadsll_logout() {
  systemctl stop vadsll
}

# show vadsll log
_vadsll_log() {
  journalctl -e -u vadsll
}

# NOTE run this as root (sudo)
# edit vadsll config file
_vadsll_conf() {
  local _editor

  # check and copy config example file
  if [ ! -e $VADSLL_CONFIG_FILE ]; then
    cp $VADSLL_CONFIG_EXAMPLE $VADSLL_CONFIG_FILE
  fi

  # check default text editor
  if [ "x" = "x$1" ]; then
    _editor=$DEFAULT_EDITOR
  else
    _editor=$1
  fi

  $_editor $VADSLL_CONFIG_FILE
}

# NOTE run this as root (sudo)
# set login password for vadsll
_vadsll_passwd() {
  local _pass
  set -e

  read -s -p "password: " _pass

  # save password
  touch $VADSLL_PASSWD_FILE
  chmod 600 $VADSLL_PASSWD_FILE
  echo -n "$_pass" >$VADSLL_PASSWD_FILE
  chmod 400 $VADSLL_PASSWD_FILE
  # done
  echo
}


_main() {
  local _exec_name

  _exec_name=$(basename $0)
  # check sub-command
  case $_exec_name in
    vadsll-show)
      _vadsll_show $*
      ;;
    vadsll-login)
      _vadsll_login $*
      ;;
    vadsll-logout)
      _vadsll_logout $*
      ;;
    vadsll-log)
      _vadsll_log $*
      ;;
    vadsll-conf)
      _vadsll_conf $*
      ;;
    vadsll-passwd)
      _vadsll_passwd $*
      ;;
    # vadsll
    *)
      _vadsll $*
      ;;
  esac
}

# start from main
_main $*

# end vadsll.sh
