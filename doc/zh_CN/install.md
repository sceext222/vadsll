<!-- vadsll/doc/zh_CN/
-->

# 安装 VADSLL

VADSLL 最初在 [`ArchLinux`](https://www.archlinux.org/) 下 开发/测试,
但是 VADSLL 也能支持其它的 `GNU/Linux` 发行版本.

目前提供以下 GNU/Linux 发行版本 的 安装方法:

+ `ArchLinux`
+ `Ubuntu 16.04 LTS`
+ `Fedora 25`

对于其它发行版本, 请自行研究安装方法 !


## ArchLinux
(<https://github.com/sceext222/vadsll/tree/dist/ArchLinux>)

+ **安装已经编译的 二进制软件包**

  下载
  [`vadsll-1.0.0_1-1-x86_64.pkg.tar.xz`](https://github.com/sceext222/vadsll/raw/dist/ArchLinux/vadsll-1.0.0_1-1-x86_64.pkg.tar.xz)
  进行安装. 请运行以下命令:

  ```
  $ wget "https://github.com/sceext222/vadsll/raw/dist/ArchLinux/vadsll-1.0.0_1-1-x86_64.pkg.tar.xz"
  $ sudo pacman -U vadsll-1.0.0_1-1-x86_64.pkg.tar.xz
  ```

+ **从 源代码 编译/安装**

  下载
  [`vadsll-1.0.0_1-2.tar.gz`](https://github.com/sceext222/vadsll/raw/dist/ArchLinux/vadsll-1.0.0_1-2.tar.gz)

  ```
  $ wget "https://github.com/sceext222/vadsll/raw/dist/ArchLinux/vadsll-1.0.0_1-2.tar.gz"
  $ tar -xvf "vadsll-1.0.0_1-2.tar.gz"
  $ cd vadsll
  $ makepkg -sri
  ```


## Ubuntu 16.04 LTS
(<https://github.com/sceext222/vadsll/tree/dist/Ubuntu16.04LTS>)

**安装 `.deb` 软件包**

下载
[`vadsll_1.0.0~1-2_amd64.deb`](https://github.com/sceext222/vadsll/raw/dist/Ubuntu16.04LTS/vadsll_1.0.0~1-2_amd64.deb)

```
$ wget "https://github.com/sceext222/vadsll/raw/dist/Ubuntu16.04LTS/vadsll_1.0.0~1-2_amd64.deb"
$ sudo apt install gdebi-core
$ sudo gdebi vadsll_1.0.0~1-2_amd64.deb
```


## Fedora 25
(<https://github.com/sceext222/vadsll/tree/dist/Fedora25>)

**安装 `.rpm` 软件包**

下载
[`vadsll-1.0.0_1-1.fc25.x86_64.rpm`](https://github.com/sceext222/vadsll/raw/dist/Fedora25/vadsll-1.0.0_1-1.fc25.x86_64.rpm)

```
$ wget "https://github.com/sceext222/vadsll/raw/dist/Fedora25/vadsll-1.0.0_1-1.fc25.x86_64.rpm"
$ sudo dnf install vadsll-1.0.0_1-1.fc25.x86_64.rpm
```
