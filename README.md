# VADSLL
Virtual ADSL tools for Linux


## Description
TODO


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
