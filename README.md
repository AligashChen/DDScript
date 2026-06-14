# 介绍

- 一键重装到 Linux，支持 19 种常见发行版
- 一键重装到 Windows，使用官方原版 ISO 而非自制镜像，脚本支持自动查找 ISO 链接、自动安装 `VirtIO` 等公有云驱动
- 支持任意方向重装，即 `Linux to Linux`、`Linux to Windows`、`Windows to Windows`、`Windows to Linux`
- 自动设置 IP，智能设置动静态，支持 `/32`、`/128`、`网关不在子网范围内`、`纯 IPv6`、`IPv4/IPv6 在不同的网卡`
- 专门适配低配小鸡，比官方 netboot 需要更少的内存
- 全程用分区表 ID 识别硬盘，确保不会写错硬盘
- 支持 BIOS、EFI 引导，支持 ARM 服务器
- 不含自制包，所有资源均实时从镜像源获得

# 系统要求

原系统可以是表格中的任意系统

目标系统的配置要求如下：

| 系统                                                         | 版本                                  | 内存      | 硬盘         |
| ------------------------------------------------------------ | ------------------------------------- | --------- | ------------ |
| <img width="16" height="16" src="https://www.alpinelinux.org/alpine-logo.ico" /> Alpine | 3.21, 3.22, 3.23, 3.24                | 256 MB    | 1 GB         |
| <img width="16" height="16" src="https://www.debian.org/favicon.ico" /> Debian | 9, 10, 11, 12, 13                     | 256 MB    | 1 ~ 1.5 GB ^ |
| <img width="16" height="16" src="https://github.com/bin456789/reinstall/assets/7548515/f74b3d5b-085f-4df3-bcc9-8a9bd80bb16d" /> Kali | 滚动                                  | 256 MB    | 1 ~ 1.5 GB ^ |
| <img width="16" height="16" src="https://documentation.ubuntu.com/server/_static/favicon.png" /> Ubuntu | 18.04 LTS - 26.04 LTS                 | 512 MB \* | 2 GB         |
| <img width="16" height="16" src="https://img.alicdn.com/imgextra/i1/O1CN01oJnJZg1yK4RzI4Rx2_!!6000000006559-2-tps-118-118.png" /> Anolis | 7, 8, 23                              | 512 MB \* | 5 GB         |
| <img width="16" height="16" src="https://www.redhat.com/favicon.ico" /> RHEL &nbsp;<img width="16" height="16" src="https://almalinux.org/fav/favicon.ico" /> AlmaLinux &nbsp;<img width="16" height="16" src="https://rockylinux.org/favicon.png" /> Rocky &nbsp;<img width="16" height="16" src="https://www.oracle.com/asset/web/favicons/favicon-32.png" /> Oracle | 8, 9, 10                              | 512 MB \* | 5 GB         |
| <img width="16" height="16" src="https://opencloudos.org/qq.ico" /> OpenCloudOS | 8, 9, Stream 23                       | 512 MB \* | 5 GB         |
| <img width="16" height="16" src="https://www.centos.org/assets/icons/favicon.svg" /> CentOS Stream | 9, 10                                 | 512 MB \* | 5 GB         |
| <img width="16" height="16" src="https://fedoraproject.org/favicon.ico" /> Fedora | 43, 44                                | 512 MB \* | 5 GB         |
| <img width="16" height="16" src="https://www.openeuler.org/favicon.ico" /> openEuler | 20.03 LTS - 24.03 LTS                 | 512 MB \* | 5 GB         |
| <img width="16" height="16" src="https://static.opensuse.org/favicon.ico" /> openSUSE | Leap 16.0, Tumbleweed (滚动)          | 512 MB \* | 5 GB         |
| <img width="16" height="16" src="https://nixos.org/favicon.svg" /> NixOS | 26.05                                 | 512 MB    | 5 GB         |
| <img width="16" height="16" src="https://archlinux.org/static/favicon.png" /> Arch | 滚动                                  | 512 MB    | 5 GB         |
| <img width="16" height="16" src="https://www.gentoo.org/assets/img/logo/gentoo-g.png" /> Gentoo | 滚动                                  | 512 MB    | 5 GB         |
| <img width="16" height="16" src="https://aosc.io/distros/aosc-os.svg" /> 安同 OS | 滚动                                  | 512 MB    | 5 GB         |
| <img width="16" height="16" src="https://www.fnnas.com/favicon.ico" /> 飞牛 fnOS &nbsp;<img width="16" height="16" src="https://fygonas.com/favicon.ico" /> FygoOS | 1                                     | 512 MB    | 8 GB         |
| <img width="16" height="16" src="https://blogs.windows.com/wp-content/uploads/prod/2022/09/cropped-Windows11IconTransparent512-32x32.png" /> Windows (DD) | 任何                                  | 512 MB    | 取决于镜像   |
| <img width="16" height="16" src="https://blogs.windows.com/wp-content/uploads/prod/2022/09/cropped-Windows11IconTransparent512-32x32.png" /> Windows (ISO) | Vista, 7, 8.x (Server 2008 - 2012 R2) | 512 MB    | 25 GB        |
| <img width="16" height="16" src="https://blogs.windows.com/wp-content/uploads/prod/2022/09/cropped-Windows11IconTransparent512-32x32.png" /> Windows (ISO) | 10, 11 (Server 2016 - 2025)           | 1 GB      | 25 GB        |

\* 表示使用云镜像安装，非传统网络安装

^ 表示需要 256 MB 内存 + 1.5 GB 硬盘，或 512 MB 内存 + 1 GB 硬盘

# 下载（当前系统是 <img width="20" height="20" src="https://www.kernel.org/theme/images/logos/favicon.png" /> Linux）

```bash
curl -O https://raw.githubusercontent.com/AligashChen/ServerScript/main/reinstall.sh || wget -O ${_##*/} $_
```

# 安装

> [!CAUTION]
>
> 此功能会清除当前系统**整个硬盘**的全部数据（包含其它分区）！
>
> 如果不小心运行了脚本，可以在重启前运行 `bash reinstall.sh reset` 取消重装

- 脚本会提示输入用户名和密码，不输入则使用 `root` 和随机密码
- 不输入版本号则安装最新版
- 最大化利用磁盘空间：不含 boot 和 swap 分区
- 自动根据机器类型和商家安装优化内核
- 安装 Red Hat 时需填写 <https://access.redhat.com/downloads/content/rhel> 得到的 `qcow2` 镜像链接，也可以安装其它类 RHEL 系统的 `qcow2`，例如 `Alibaba Cloud Linux` 和 `TencentOS Server`
- 重装后如需修改 SSH 端口或者改成密钥登录，注意还要修改 `/etc/ssh/sshd_config.d/` 里面的文件
- 为了快速安装，重装时不会对新系统进行更新，请在重装后自行更新

```bash
bash reinstall.sh anolis      7|8|23
                  rocky       8|9|10
                  oracle      8|9|10
                  almalinux   8|9|10
                  opencloudos 8|9|23
                  centos      9|10
                  fnos        1
                  fygoos      1
                  nixos       26.05
                  fedora      43|44
                  debian      9|10|11|12|13
                  opensuse    16.0|tumbleweed
                  openeuler   20.03|22.03|24.03
                  alpine      3.21|3.22|3.23|3.24
                  ubuntu      18.04|20.04|22.04|24.04|26.04 [--minimal]
                  kali
                  arch
                  gentoo
                  aosc
                  redhat      --img="http://access.cdn.redhat.com/xxx.qcow2"
```

## 可选参数

- `--username USERNAME` 设置用户名
- `--password PASSWORD` 设置密码
- `--ssh-key KEY` 设置 SSH 登录公钥，[格式如下](#--ssh-key)。当使用公钥时，密码为空
- `--ssh-port PORT` 修改 SSH 端口
- `--web-port PORT` 修改 Web 端口（安装期间观察日志用）
- `--frpc-config PATH` 添加 frpc 内网穿透，参数填配置文件的本地路径或 HTTP 链接
- `--hold 1` 仅重启到安装环境，不运行安装，用于 SSH 登录验证网络连通性
- `--hold 2` 安装结束后不重启，用于 SSH 登录修改系统内容，Debian/Kali 会挂载在 `/target`，其它系统会挂载在 `/os`

## 安装命令示例

```bash
bash reinstall.sh <填自己要安装的系统版本号> --username root --password <填自己服务器root用户登录密码> --ssh-port 22
```

# 取消重装

- 如果不小心运行了脚本，可以运行以下命令取消重装
- 需要在重启前运行

```bash
bash reinstall.sh reset
```

# 说明

- 特别感谢原作者：[bin456789](https://github.com/bin456789)
- 脚本可以跑在云服务器上，也可以跑在自己本地内网实体服务器上（前提是：本地内网实体服务器需要能够联网）
- 亲测x86架构可以完美运行，ARM架构机器没跑过

# 感谢

感谢以下商家提供白嫖机器

[![Oracle Cloud](https://github.com/bin456789/reinstall/assets/7548515/8b430ed4-8344-4f96-b4da-c2bda031cc90)](https://www.oracle.com/cloud/)
