<!-- vadsll/doc/zh_CN/
-->

# 配置 / 使用

+ 查看 VADSLL 版本号 (验证安装是否成功)

  ```
  $ vadsll --version
  vadsll version 1.0.0-1 test20170525 1515
  $
  ```

## 简单命令

VADSLL 提供了若干命令以方便用户使用.

+ **`vadsll-conf`** <br />
  编辑 VADSLL 的 配置文件 ( `/etc/vadsll/config.toml` )

  + 使用 `gedit` 编辑配置文件: <br />
    ```
    $ sudo vadsll-conf
    ```

    (实际执行 `$ gedit /etc/vadsll/config.toml` )

  + (或者) 使用 `vim` 编辑配置文件: <br />
    ```
    $ sudo vadsll-conf vim
    ```

+ **`vadsll-passwd`** <br />
  设置 登陆口令 ( `/etc/vadsll/shadow` )

  ```
  $ sudo vadsll-passwd
  password:
  $
  ```

  **注意**: 输入 口令 时, 光标不会移动 ! (输入后按 *回车* 键保存)

  (将 登陆口令 保存在单独的文件中, 并且 设置权限 (只有 `root` 能 读取)
  有助于防止口令泄露. )

+ **`vadsll-show`** <br />
  显示 VADSLL 运行状态

  ```
  $ vadsll-show
  ● vadsll.service - vadsll login service
     Loaded: loaded (/usr/lib/systemd/system/vadsll.service; static; vendor preset: disabled)
     Active: inactive (dead)
  $
  ```

  (实际执行 `$ systemctl status vadsll` )

+ **`vadsll-login`** <br />
  登陆

  ```
  $ sudo vadsll-login
  ```

  (实际执行 `$ sudo systemctl start vadsll` )

+ **`vadsll-logout`** <br />
  下线

  ```
  $ sudo vadsll-logout
  ```

  (实际执行 `$ sudo systemctl stop vadsll` )

+ **`vadsll-log`** <br />
  查看 VADSLL 运行日志

  ```
  $ vadsll-log
  ```

  (实际执行 `$ journalctl -e -u vadsll` )

  当 VADSLL 工作出现问题时, 日志能提供许多有用信息 !


## 配置文件

```
$ cat /etc/vadsll/config.toml.zh_CN.example
# VADSLL 的配置文件 (zh_CN)

# 网络接口 (网卡)
interface = "enp0s3"
# 登陆 帐号
account = "<帐号>"
# 注意: 密码 存储在 `shadow` 文件中!


# !!! 高级配置 (请勿修改 !!!)
auth_server = "<认证服务器 IP 地址>:1812"
ethernet_mtu = 1500
vadsl_mtu = 1476
keep_alive_timeout_s = 300

nfqueue_id = 44001
nft_table = "vadsll"
nft_hook_priority = 150

# end config.toml
$
```

通常 有以下 3 项配置需要更改:

+ **网络接口 (网卡)** <br />
  连接到 外网 (Internet) 的 网络接口 名称.

  使用 `$ ip link` 命令查看网络接口:

  ```
  $ ip link
  1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
      link/ether 01:00:00:11:bb:ee brd ff:ff:ff:ff:ff:ff
  $
  ```

+ **登陆帐号**

  注意: 请使用 `vadsll-passwd` 命令 设置对应的 口令.

+ **认证服务器 IP 地址** <br />
  此项 不同学校 的 IP 可能不同

  TODO

修改之后的 配置文件, 看起来类似:

```
# VADSLL 的配置文件 (zh_CN)

# 网络接口 (网卡)
interface = "enp0s8"
# 登陆 帐号
account = "12344446666"
# 注意: 密码 存储在 `shadow` 文件中!


# !!! 高级配置 (请勿修改 !!!)
auth_server = "172.16.123.233:1812"
ethernet_mtu = 1500
vadsl_mtu = 1476
keep_alive_timeout_s = 300

nfqueue_id = 44001
nft_table = "vadsll"
nft_hook_priority = 150

# end config.toml
```


## 高级命令

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

TODO


## NAT

如需使用 NAT 功能 (比如用于 网络共享), 请按照 `nftables` 官方的说明设置 NAT:

<http://www.netfilter.org/projects/nftables/index.html> <br />
<https://wiki.nftables.org/wiki-nftables/index.php/Main_Page> <br />
<https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)>

VADSLL 兼容 NAT (在 `ArchLinux` 下测试), 可以和 NAT 配合使用.
