<!-- vadsll/doc/dev/
-->

# 背景

**VADSL** (Virtual ADSL, 虚拟 ADSL) 是一种网络接入方式,
某些 校园网 使用 VADSL 上网.
但是, 官方的 VADSL 客户端只有 *Windows* 版, 在 `GNU/Linux` 操作系统 中
无法使用 VADSL.

**VADSLL** (VADSL for Linux) 就是一个在 GNU/Linux 下工作的,
支持 VADSL 上网的软件.


## 编写

VADSLL 的原型是 `张敬强 <godfrey.public@gmail.com>` 的
项目 <http://code.google.com/p/vadsl/>. <br />
(<http://forum.ubuntu.org.cn/viewtopic.php?t=398847> <br />
<https://github.com/sceext222/vadsl_linux>)

这是一个使用 `C` 语言 (以及 bash 脚本) 编写的软件,
并且使用 Linux 内核的 `iptables` 功能.

然而, VADSL 的工作方式, 导致 `iptables` 无法兼容 `NAT` 功能 (NAT 用于网络共享).
以及其它一些不太方便的地方, 所以在研究 VADSL (以及这个软件) 工作方式后,
使用 `coffee-script` 和 `rust` (完全) 重写.

VADSLL 使用 `nftables` (替代 `iptables`), 能够兼容 NAT,
并且增加了一些功能特性.

VADSLL 最初在 [`ArchLinux`](https://www.archlinux.org/) 上 开发/测试,
但是也能够支持其它的 GNU/Linux 发行版本.

(VADSLL 首个可工作版本, 完成于 `2017.04` )
