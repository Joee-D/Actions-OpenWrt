#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#


#Add Smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git feeds/luci/applications/luci-app-smartdns
./scripts/feeds update -a

rm -rf feeds/packages/net/smartdns
git clone https://github.com/pymumu/openwrt-smartdns.git feeds/packages/net/smartdns

# Change Theme
rm -rf feeds/luci/applications/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-app-argon-config.git feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

./scripts/feeds install -a

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate
