# VADSLL
Virtual ADSL tools for Linux


## Description
(虚拟 ADSL)


## Usage

+ **1**. Install some softwares
  (under [`ArchLinux`](https://www.archlinux.org/))

  ```
  $ sudo pacman -S --needed nftables libnetfilter_queue nodejs npm rust cargo git make
  ```

+ **2**. Download source code

  ```
  $ git clone https://github.com/sceext222/vadsll --single-branch --depth=1
  ```

+ **3**. Build from source

  ```
  $ cd vadsll
  $ make init
  $ make build
  ```

+ **4**. Install

  ```
  $ sudo make install
  ```

+ **5**. Modify config file

  ```
  $ cd /usr/local/etc/vadsll
  $ sudo cp config.json.example config.json
  $ sudo vim config.json
  ```

+ **6**. Login

  ```
  $ sudo systemctl start vadsll
  ```

+ **7**. Logout

  ```
  $ sudo systemctl stop vadsll
  ```


```
$ node /usr/local/lib/vadsll/vadsll/vadsll.js --help
vadsll: Virtual ADSL tools for Linux
Usage:
    --login              The complete LOGIN process
    --logout             The complete LOGOUT process

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


## Dependencies

Under `archlinux`:
```
$ sudo pacman -S --needed nftables libnetfilter_queue nodejs npm rust cargo
```

+ **`nftables`** <br />
  <https://wiki.nftables.org/wiki-nftables/index.php/Main_Page>

  ```
  $ nft --version
  nftables v0.7 (Scrooge McDuck)
  $
  ```

+ **`libnetfilter_queue`** <br />
  <https://www.netfilter.org/projects/libnetfilter_queue/index.html>

  ```
  $ pacman -Ss libnetfilter_queue
  extra/libnetfilter_queue 1.0.2-2 [installed]
      Userspace API to packets that have been queued by the kernel packet filter
  $
  ```

Test `2017.04`
```
$ uname -a
Linux SCEEXT-ARCH-LT-201603 4.10.6-1-zen #1 ZEN SMP PREEMPT Sun Mar 26 18:10:57 UTC 2017 x86_64 GNU/Linux
$ node --version
v7.7.3
$ npm --version
4.4.4
$ rustc --version
rustc 1.16.0 (30cf806ef 2017-03-10)
$ cargo --version
cargo-0.17.0-nightly (f9e5481 2017-03-03)
$
```


## LICENSE

`GNU GPLv3+`
