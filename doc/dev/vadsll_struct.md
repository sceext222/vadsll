<!-- vadsll/doc/dev/
-->

# VADSLL 架构


## 源代码 文件 (目录) 结构

```
vadsll            # vadsll 源代码 根目录
├── LICENSE       # LICENSE: GNU GPLv3+
├── package.json  # 定义 `npm` 依赖
├── makefile      # 用于 编译/安装 VADSLL
├── doc           # 文档
│   ├── dev       # VADSLL 开发者文档
│   └── zh_CN     # 用户文档
├── src                        # vadsll 主程序 (coffee-script + node.js) 源代码
│   ├── vadsll.coffee          # 主程序 入口文件 (main)
│   ├── config.coffee          # 程序内部配置
│   ├── p_args.coffee          # 解析 命令行 参数
│   ├── async.coffee           # 用 `Promise` 对 node.js 的 callback API 进行封装, 以便使用 ECMAScript 7 的 `await` 语法
│   ├── util.coffee            # 底层工具函数
│   ├── log.coffee             # 打印日志信息 (功能封装)
│   ├── make_nft_rules.coffee  # 生成 `nftables` 需要的 规则文件
│   ├── packet_util.coffee     # 对 VADSL 协议 的 二进制数据包 进行 构建/解析
│   └── sub                           # vadsll 子命令
│       ├── login_.coffee             # `--login`
│       ├── logout_.coffee            # `--logout`
│       ├── init.coffee               # `--init`
│       ├── keep_alive.coffee         # `--keep-alive`
│       ├── kill_keep_alive.coffee    # `--kill-keep-alive`
│       ├── kill_route_filter.coffee  # `--kill-route-filter`
│       ├── log_backup.coffee         # `--log-backup`
│       ├── log_clean.coffee          # `--log-clean`
│       ├── nft_gen.coffee            # `--nft-gen`
│       ├── nft_init.coffee           # `--nft-init`
│       ├── nft_reset.coffee          # `--nft-reset`
│       ├── once_keep_alive.coffee    # `--once-keep-alive`
│       ├── only_login.coffee         # `--only-login`
│       ├── only_logout.coffee        # `--only-logout`
│       ├── route_filter.coffee       # `--route-filter`
│       ├── run_keep_alive.coffee     # `--run-keep-alive`
│       └── run_route_filter.coffee   # `--run-route-filter`
├── etc                            # VADSLL 用户配置文件
│   ├── config.toml.example        # 配置文件 模板 (英文注释)
│   └── config.toml.zh_CN.example  # 配置文件 模板 (中文注释)
├── os
│   ├── ArchLinux
│   │   ├── os                  # 操作系统 标志 (ArchLinux)
│   │   └── vadsll              # pacman 软件包 (makepkg) 文件
│   │       ├── PKGBUILD
│   │       └── vadsll.install
│   ├── Fedora25
│   │   ├── os            # 操作系统 标志 (Fedora 25)
│   │   └── vadsll.spec   # `.rpm` 软件包 的 `.spec` 文件
│   ├── Ubuntu16.04LTS
│   │   ├── os            # 操作系统 标志 (Ubuntu 16.04 LTS)
│   │   └── debian        # `.deb` 软件包 文件
│   │       ├── control
│   │       ├── postinst
│   │       └── prerm
│   ├── systemd             # systemd unit 文件
│   │   └── vadsll.service  # vadsll login service
│   └── vadsll.sh           # vadsll 命令 (`/usr/bin/vadsll`)
└── route_filter            # 路由过滤 (IP 数据包 处理) 程序
```


TODO
