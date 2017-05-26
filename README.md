# VADSLL
Virtual ADSL tools for Linux <br />
<https://github.com/sceext222/vadsll>


## Description
(虚拟 ADSL)

(`zh_CN`) [**中文使用说明**](https://github.com/sceext222/vadsll/tree/master/doc/zh_CN)


## Install

+ **Install pre-build packages**

  Please see <https://github.com/sceext222/vadsll/tree/dist>

+ (or) **Build from source** <br />
  (NOTE: this is only for [`ArchLinux`](https://www.archlinux.org/) )

  Download
  [`vadsll-1.0.0_1-2.tar.gz`](https://github.com/sceext222/vadsll/raw/dist/ArchLinux/vadsll-1.0.0_1-2.tar.gz)
  from <https://github.com/sceext222/vadsll/tree/dist/ArchLinux>

  ```
  $ wget "https://github.com/sceext222/vadsll/raw/dist/ArchLinux/vadsll-1.0.0_1-2.tar.gz"
  $ tar -xvf "vadsll-1.0.0_1-2.tar.gz"
  $ cd vadsll
  $ makepkg -sri
  ```

Check install success:

```
$ vadsll --version
vadsll version 1.0.0-1 test20170525 1515
$
```


## Config and usage

+ Modify config file <br />
  ```
  $ sudo cp /etc/vadsll/config.toml.example /etc/vadsll/config.toml
  $ sudo vim /etc/vadsll/config.toml
  ```

+ Set login password <br />
  ```
  $ sudo vadsll-passwd
  ```

+ Login <br />
  ```
  $ sudo vadsll-login
  ```

+ Logout <br />
  ```
  $ sudo vadsll-logout
  ```

+ Show vadsll running status <br />
  ```
  $ vadsll-show
  ```

+ Show vadsll log <br />
  ```
  $ vadsll-log
  ```


```
$ vadsll --help
vadsll: Virtual ADSL tools for Linux
Usage:
   --login              The complete LOGIN process
   --logout             The complete LOGOUT process

   --init               Do init in system install mode
   --only-login         Only send LOGIN packet to auth server
   --only-logout        Only send LOGOUT packet to auth server
   --nft-gen            Generate nftables rules
   --nft-init           Setup nftables rules
   --nft-reset          Reset nftables rules
   --log-backup         Backup log files
   --log-clean          Clean log files
   --run-keep-alive     Run KEEP-ALIVE in background
   --run-route-filter   Run route_filter in background
   --route-filter       Daemon of route_filter
   --keep-alive         Daemon of KEEP-ALIVE
   --once-keep-alive    Only send KEEP-ALIVE packet to auth server ONCE
   --kill-keep-alive    Kill KEEP-ALIVE daemon
   --kill-route-filter  Kill route_filter daemon

   --help               Show this help text
   --version            Show version of this program

vadsll: <https://github.com/sceext222/vadsll>
$
```


Test `2017.05`

## LICENSE

`GNU GPLv3+`

<!-- end README.md for VADSLL
  <https://github.com/sceext222/vadsll>
-->
