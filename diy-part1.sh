#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

git clone -b lede https://github.com/pymumu/luci-app-smartdns.git tmp/smartdns_luci/luci-app-smartdns
git clone https://github.com/pymumu/openwrt-smartdns.git tmp/smartdns/smartdns
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git tmp/argon_luci/luci-theme-argon

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
echo 'src-git passwall_pkg https://github.com/xiaorouji/openwrt-passwall.git;packages' >>feeds.conf.default
echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;luci' >>feeds.conf.default
echo 'src-git openclash https://github.com/vernesong/OpenClash.git' >>feeds.conf.default
echo 'src-cpy smartdns tmp/smartdns' >>feeds.conf.default
echo 'src-cpy smartdns_luci tmp/smartdns_luci' >>feeds.conf.default
echo 'src-cpy argon_luci tmp/argon_luci' >>feeds.conf.default
