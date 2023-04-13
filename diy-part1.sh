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

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
echo 'src-git passwall_pkg https://github.com/xiaorouji/openwrt-passwall.git;packages' >>feeds.conf.default
echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;luci-smartdns-new-version' >>feeds.conf.default
echo 'src-git openclash https://github.com/vernesong/OpenClash.git' >>feeds.conf.default

#Add Smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git feeds/luci/applications/luci-app-smartdns
git clone https://github.com/pymumu/openwrt-smartdns.git feeds/packages/net/smartdns

# Change Theme
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
