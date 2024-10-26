#!/bin/bash
###
# @Date         : 2024-02-16 11:03:16
# @Description  : 用于在 github actions 中编译 OpenWrt 固件
###

# 可选版本 6.6 | 6.1 | 5.15 | 5.10 | 5.4
KERNEL_VERSION_DEFAULT="6.6"

# 计时函数
timer() {
    local start_time event end_time time_elapsed hours minutes seconds
    start_time=$1 # 添加一个新的参数来传递开始时间
    event=$2      # 添加一个新的参数来传递自定义的文本
    end_time=$(date +%s)
    time_elapsed=$((end_time - start_time))
    hours=$((time_elapsed / 3600))
    minutes=$(((time_elapsed / 60) % 60))
    seconds=$((time_elapsed % 60))
    echo "======================================== ${event}共计用时: ${hours}时${minutes}分${seconds}秒"
}

# 编译函数
make_download() {
    KERNEL_VERSION=$1
    # 记录开始时间
    start_time=$(date +%s)

    # 打印当前目录
    echo "======================================== 版本:$KERNEL_VERSION 当前下载目录"
    cd openwrt || exit
    pwd

    # 指定内核版本
    sed -i "s/^KERNEL_PATCHVER:=.*$/KERNEL_PATCHVER:=$KERNEL_VERSION/" target/linux/x86/Makefile
    sed -i "s/^KERNEL_TESTING_PATCHVER:=.*$/KERNEL_TESTING_PATCHVER:=$KERNEL_VERSION/" target/linux/x86/Makefile

    echo "======================================== 版本:$KERNEL_VERSION 修改指定内核完成."

    # 删除原来的 .config 文件 自定义定制 - x86_64.config
    echo "======================================== 版本:$KERNEL_VERSION 自定义定制 - x86_64.config"
    rm -f .config
    touch .config
    cat >>.config <<EOF
# x86_64.config
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_KERNEL_PARTSIZE=256
CONFIG_TARGET_ROOTFS_PARTSIZE=1024

CONFIG_KERNEL_BUILD_USER="jpz"
CONFIG_GRUB_TITLE="OpenWrt Build by jiaopengzi"
# CONFIG_GRUB_CONSOLE is not set

# 编译固件输出格式
CONFIG_GRUB_EFI_IMAGES=y
CONFIG_TARGET_IMAGES_GZIP=y

# vmware 虚拟机镜像
# CONFIG_VMDK_IMAGES is not set

# iso 镜像
# CONFIG_ISO_IMAGES is not set

# PVE/KVM 镜像 CONFIG_QCOW2_IMAGES is not set
# CONFIG_QCOW2_IMAGES is not set

# virtualbox 镜像
# CONFIG_VDI_IMAGES is not set

# hyper-v 镜像
# CONFIG_VHDX_IMAGES is not set

CONFIG_PACKAGE_grub2-efi=y
CONFIG_PACKAGE_dnsmasq_full_auth=y
CONFIG_PACKAGE_dnsmasq_full_conntrack=y
CONFIG_PACKAGE_dnsmasq_full_dnssec=y
CONFIG_PACKAGE_ddns-scripts_cloudflare.com-v4=y
CONFIG_PACKAGE_ddns-scripts_freedns_42_pl=y
CONFIG_PACKAGE_ddns-scripts_godaddy.com-v1=y
CONFIG_PACKAGE_ddns-scripts_no-ip_com=y
CONFIG_PACKAGE_ddns-scripts_nsupdate=y
CONFIG_PACKAGE_ddns-scripts_route53-v1=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_wget-nossl=y
CONFIG_PACKAGE_wget-ssl=y
CONFIG_PACKAGE_kmod-kvm-amd=y
CONFIG_PACKAGE_kmod-kvm-intel=y
CONFIG_PACKAGE_kmod-kvm-x86=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-ohci-pci=y
CONFIG_PACKAGE_kmod-usb-storage-uas=y
CONFIG_PACKAGE_kmod-usb-uhci=y
CONFIG_PACKAGE_kmod-sdhci=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb2-pci=y
CONFIG_PACKAGE_kmod-usb3=y
# CONFIG_PACKAGE_luci-theme-argon is not set
# CONFIG_PACKAGE_luci-app-ttyd is not set
CONFIG_PACKAGE_luci-app-frpc=y
CONFIG_PACKAGE_luci-app-diag-core=y
CONFIG_PACKAGE_upx=y
CONFIG_PACKAGE_lsblk=y

# openssl
CONFIG_OPENSSL_WITH_CAMELLIA=y
CONFIG_OPENSSL_WITH_COMPRESSION=y
CONFIG_OPENSSL_WITH_DTLS=y
CONFIG_OPENSSL_WITH_EC2M=y
CONFIG_OPENSSL_WITH_ERROR_MESSAGES=y
CONFIG_OPENSSL_WITH_IDEA=y
CONFIG_OPENSSL_WITH_MDC2=y
CONFIG_OPENSSL_WITH_RFC3779=y
CONFIG_OPENSSL_WITH_SEED=y
CONFIG_OPENSSL_WITH_WHIRLPOOL=y

# openssl 安装
CONFIG_PACKAGE_luci-app-openvpn=y
CONFIG_PACKAGE_luci-app-openvpn-server=y
CONFIG_PACKAGE_openvpn-easy-rsa=y
CONFIG_PACKAGE_openvpn-openssl=y

# ssl证书获取
CONFIG_PACKAGE_acme=y
CONFIG_PACKAGE_acme-deploy=y
CONFIG_PACKAGE_acme-dnsapi=y
CONFIG_PACKAGE_acme-notify=y
CONFIG_PACKAGE_luci-app-acme=y

# ssrp 将所有的 ssrp 服务都安装
CONFIG_DEFAULT_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_libustream-mbedtls=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_libustream-openssl=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_PACKAGE_libustream-wolfssl=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_NONE_Client=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Client=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_NONE_Server=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Server=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_NONE_V2RAY=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ChinaDNS_NG=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_MosDNS=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Tuic_Client=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadow_TLS=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_IPT2Socks=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Redsocks2=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_V2ray_Plugin=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Client=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Server=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan=y
CONFIG_PACKAGE_luci-i18n-ssr-plus-zh-cn=y

# 磁盘管理工具
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_mdadm=y

# docker 后台使用命令行
CONFIG_PACKAGE_dockerd=y
CONFIG_PACKAGE_docker=y
CONFIG_PACKAGE_docker-compose=y

# ssh vim
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_vim-full=y

# ttyd 终端默认不安装
# CONFIG_PACKAGE_ttyd is not set
# CONFIG_PACKAGE_luci-app-ttyd is not set
EOF

    # defconfig
    echo "======================================== 版本:$KERNEL_VERSION make defconfig"
    make defconfig

    # 查看编译线程最大值
    echo "======================================== 版本:$KERNEL_VERSION 下载线程数量:$(nproc)"

    # 下载dl库
    echo "======================================== 版本:$KERNEL_VERSION 下载dl库"
    make download -j"$(nproc)"

    # 返回上层目录
    cd ..
    # 计算所用时间并输出
    timer "$start_time" "版本:$KERNEL_VERSION 下载dl库"
}

# 释放存储空间
free_up_storage_space() {
    echo "======================================== 查看当前磁盘空间 磁盘空间清理完成前,"
    df -h
    # 停止所有docker容器
    docker stop "$(docker ps -a -q)" 2>/dev/null
    # 删除所有docker容器
    docker rm "$(docker ps -a -q)" 2>/dev/null
    # 删除所有docker镜像
    docker rmi "$(docker images -q)" 2>/dev/null

    # 删除不必要的软件包
    sudo apt-get -y purge azure-cli* docker* ghc* zulu* hhvm* llvm* firefox* google* dotnet* aspnetcore* powershell* openjdk* adoptopenjdk* mysql* php* mongodb* moby* snapd* || true

    # 删除不必要的文件和目录
    sudo rm -rf \
        /usr/share/dotnet \
        /usr/local/lib/android \
        /opt/ghc \
        /etc/mysql \
        /etc/php \
        /tmp/* \
        /var/tmp/* \
        /home/*/.cache/* \
        /root/.cache/* \
        /usr/share/man/* \
        /usr/share/doc/* \
        /usr/share/locale/* \
        /usr/share/zoneinfo/* \
        /usr/share/info/* \
        /var/lib/apt/lists/* \
        /var/log/* \
        /usr/lib/jvm/* \
        /usr/lib/x86_64-linux-gnu/libLLVM* \
        /usr/lib/x86_64-linux-gnu/libQt* \
        /usr/lib/x86_64-linux-gnu/libmozjs* \
        /usr/lib/x86_64-linux-gnu/libvulkan* \
        /usr/lib/x86_64-linux-gnu/mesa* \
        /usr/lib/x86_64-linux-gnu/libwebkit2gtk* \
        /usr/lib/x86_64-linux-gnu/libx264* \
        /usr/lib/x86_64-linux-gnu/libx265* \
        /usr/lib/x86_64-linux-gnu/libxvid* \
        /usr/lib/x86_64-linux-gnu/libzstd* \
        /usr/lib/x86_64-linux-gnu/libicu* \
        /usr/lib/x86_64-linux-gnu/libharfbuzz* \
        /usr/lib/x86_64-linux-gnu/libfontconfig* \
        /usr/lib/x86_64-linux-gnu/libfreetype* \
        /usr/lib/x86_64-linux-gnu/libgraphite2* \
        /usr/lib/x86_64-linux-gnu/libpango* \
        /usr/lib/x86_64-linux-gnu/libcairo* \
        /usr/lib/x86_64-linux-gnu/libpixman* \
        /usr/lib/x86_64-linux-gnu/libpng* \
        /usr/lib/x86_64-linux-gnu/libjpeg* \
        /usr/lib/x86_64-linux-gnu/libsndfile* \
        /usr/lib/x86_64-linux-gnu/libvorbis* \
        /usr/lib/x86_64-linux-gnu/libogg* \
        /usr/lib/x86_64-linux-gnu/libflac* \
        /usr.lib/x86_64-linux-gnu/libspeex* \
        /usr.lib/x86_64-linux-gnu/libopus* \
        /usr.lib/x86_64-linux-gnu/libtheora* \
        /usr.lib/x86_64-linux-gnu/libavcodec* \
        /usr.lib/x86_64-linux-gnu/libavutil* \
        /usr.lib/x86_64-linux-gnu/libavformat* \
        /usr.lib/x86_64-linux-gnu/libavfilter* \
        /usr.lib/x86_64-linux-gnu/libswscale* \
        /usr.lib/x86_64-linux-gnu/libswresample* \
        /usr.lib/x86_64-linux-gnu/libpostproc* \
        /usr.lib/x86_64-linux-gnu/libva* \
        /usr.lib/x86_64-linux-gnu/libvdpau* \
        /usr.lib/x86_64-linux-gnu/libxkbcommon* \
        /usr.lib/x86_64-linux-gnu/libwayland* \
        /usr.lib/x86_64-linux-gnu/libinput* \
        /usr.lib/x86_64-linux-gnu/libwacom* \
        /usr.lib/x86_64-linux-gnu/libmtdev* \
        /usr.lib/x86_64-linux-gnu/libevdev* \
        /usr.lib/x86_64-linux-gnu/libudev* \
        /usr.lib/x86_64-linux-gnu/libsystemd* \
        /usr.lib/x86_64-linux-gnu/libdbus* \
        /usr.lib/x86_64-linux-gnu/libselinux* \
        /usr.lib/x86_64-linux-gnu/libseccomp* \
        /usr.lib/x86_64-linux-gnu/libcap* \
        /usr.lib/x86_64-linux-gnu/libpam* \
        /usr.lib/x86_64-linux-gnu/libaudit* \
        /usr.lib/x86_64-linux-gnu/libcrypt* \
        /usr.lib/x86_64-linux-gnu/libattr* \
        /usr.lib/x86_64-linux-gnu/libacl* \
        /usr.lib/x86_64-linux-gnu/libgmp* \
        /usr.lib/x86_64-linux-gnu/libnettle* \
        /usr.lib/x86_64-linux-gnu/libhogweed* \
        /usr.lib/x86_64-linux-gnu/libp11-kit* \
        /usr.lib/x86_64-linux-gnu/libgnutls* \
        /usr.lib/x86_64-linux-gnu/libtasn1* \
        /usr.lib/x86_64-linux-gnu/libidn* \
        /usr.lib/x86_64-linux-gnu/libunistring* \
        /usr.lib/x86_64-linux-gnu/libgcrypt* \
        /usr.lib/x86_64-linux-gnu/libgpg-error* \
        /usr.lib/x86_64-linux-gnu/libgssapi* \
        /usr.lib/x86_64-linux-gnu/libkrb5* \
        /usr.lib/x86_64-linux-gnu/libk5crypto* \
        /usr.lib/x86_64-linux-gnu/libcom_err* \
        /usr.lib/x86_64-linux-gnu/libss* \
        /usr.lib/x86_64-linux-gnu/libext2fs* \
        /usr.lib/x86_64-linux-gnu/libblkid* \
        /usr.lib/x86_64-linux-gnu/libuuid* \
        /usr.lib/x86_64-linux-gnu/liblzma* \
        /usr.lib/x86_64-linux-gnu/libbz2* \
        /usr.lib/x86_64-linux-gnu/libz* \
        /usr.lib/x86_64-linux-gnu/liblz4* \
        /usr.lib/x86_64-linux-gnu/liblzo2* \
        /usr.lib/x86_64-linux-gnu/libm* \
        /usr.lib/x86_64-linux-gnu/libpthread* \
        /usr.lib/x86_64-linux-gnu/libdl* \
        /usr.lib/x86_64-linux-gnu/libc* \
        /usr.lib/x86_64-linux-gnu/libnss* \
        /usr.lib/x86_64-linux-gnu/libresolv* \
        /usr.lib/x86_64-linux-gnu/libnsl* \
        /usr.lib/x86_64-linux-gnu/libutil* \
        /usr.lib/x86_64-linux-gnu/libstdc++* \
        /usr.lib/x86_64-linux-gnu/libgcc_s* \
        /usr.lib/x86_64-linux-gnu/libtinfo* \
        /usr.lib/x86_64-linux-gnu/libncurses* \
        /usr.lib/x86_64-linux-gnu/libreadline* \
        /usr.lib/x86_64-linux-gnu/libhistory* \
        /usr.lib/x86_64-linux-gnu/libpanel* \
        /usr.lib/x86_64-linux-gnu/libmenu* \
        /usr.lib/x86_64-linux-gnu/libform* \
        /usr.lib/x86_64-linux-gnu/libgpm* \
        /usr.lib/x86_64-linux-gnu/libslang* \
        /usr.lib/x86_64-linux-gnu/libncursesw* \
        /usr.lib/x86_64-linux-gnu/libpanelw* \
        /usr.lib/x86_64-linux-gnu/libmenuw* \
        /usr.lib/x86_64-linux-gnu/libformw*

    # 删除不必要的软件包
    sudo apt-get -y autoremove --purge
    sudo apt-get clean 2>/dev/null

    # 清理缓存
    sudo sync
    sudo sysctl -w vm.drop_caches=3
    echo "======================================== 查看当前磁盘空间 下载必要依赖和磁盘空间清理完成后,"
    df -h
}

# 更新编译环境依赖及源码
update_env_source() {
    # 记录开始时间
    start_time=$(date +%s)

    # 每次执行手动输入密码 更新软件包 & 安装依赖
    sudo apt-get update -y
    sudo apt-get full-upgrade -y
    sudo apt-get install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
        bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
        git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev libgmp3-dev \
        libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libpython3-dev libreadline-dev \
        libssl-dev libtool lrzsz mkisofs msmtp ninja-build p7zip p7zip-full patch pkgconf python3 \
        python3-pyelftools python3-setuptools qemu-utils rsync scons squashfs-tools subversion swig texinfo \
        uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev \
        make clang llvm nano python3-pip aria2 \
        bc lm-sensors pciutils curl miniupnpd conntrack conntrackd jq liblzma-dev \
        libpcre2-dev libpam0g-dev libkmod-dev libtirpc-dev libaio-dev libcurl4-openssl-dev libtins-dev libyaml-cpp-dev libglib2.0-dev libgpiod-dev

    # 下载源码
    echo "======================================== 下载源码"

    git clone --depth 1 https://github.com/coolsnowwolf/lede -b master openwrt
    cd openwrt || exit

    # 添加 ssrp 源
    echo "src-git ssrp https://github.com/fw876/helloworld.git" >>./feeds.conf.default

    # 更新软件包 & 安装依赖,出现 warning 信息不影响编译
    echo "======================================== 更新软件包"
    ./scripts/feeds update -a

    echo "======================================== 安装依赖"
    ./scripts/feeds install -a

    echo "======================================== 二次安装依赖,确保安装完整"
    ./scripts/feeds install -a

    # 返回上层目录
    cd ..
    # 打印当前目录
    echo "======================================== 当前目录"
    pwd

    # 初次下载dl库
    make_download "$KERNEL_VERSION_DEFAULT"

    echo "======================================== 查看当前磁盘空间 make_download 完成时"
    df -h

    # 计算所用时间并输出
    timer "$start_time" "更新编译环境依赖及源码"
}

# 编译函数
build_openwrt() {
    KERNEL_VERSION=$1
    # 记录开始时间
    start_time=$(date +%s)

    make_download "$KERNEL_VERSION"

    # 编译固件 稳妥起见，使用单线程编译
    # 打印当前目录
    echo "======================================== 版本:$KERNEL_VERSION 当前编译目录"
    cd openwrt || exit
    pwd

    echo "======================================== 版本:$KERNEL_VERSION 开始编译固件"
    make -j"$(nproc)"
    # make V=s -j1

    echo "======================================== 版本:$KERNEL_VERSION 编译完成"

    # 返回上层目录
    echo "======================================== 当前目录"
    cd ..
    pwd

    echo "======================================== 查看当前磁盘空间 编译完成,清理临时文件前"
    df -h

    # 删除基础镜像
    rm -f ./openwrt/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-rootfs.img.gz

    # 删除 kernel 文件
    rm -f ./openwrt/bin/targets/x86/64/openwrt-x86-64-generic-kernel.bin

    # 删除 packages 文件夹
    rm -rf ./openwrt/bin/targets/x86/64/packages

    # 清理临时文件
    echo "======================================== 清理临时文件"
    make clean

    echo "======================================== 查看当前磁盘空间 编译完成,清理临时文件后"
    df -h

    # 计算所用时间并输出
    timer "$start_time" "版本:$KERNEL_VERSION 编译"
}

# 记录开始时间
start_time_all=$(date +%s)

# 释放存储空间
free_up_storage_space

# 更新编译环境
update_env_source

# 编译默认版本
build_openwrt "$KERNEL_VERSION_DEFAULT"

timer "$start_time_all" "编译"
