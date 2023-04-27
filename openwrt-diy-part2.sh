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

### Replace Packages
# dockerman
rm -rf feeds/luci/applications/luci-app-dockerman
git clone --depth 1 https://github.com/lisaac/luci-app-dockerman.git tmp/luci-app-dockerman
cp -r tmp/luci-app-dockerman/applications/luci-app-dockerman feeds/luci/applications
rm -rf tmp/luci-app-dockerman

### Add Packages
rm -r package/others -f
mkdir package/others
# ssr+
git clone --depth 1 https://github.com/fw876/helloworld package/others/helloworld
# passwall
git clone --depth 1 -b packages https://github.com/xiaorouji/openwrt-passwall.git package/others/passwall_pkg
git clone --depth 1 -b luci-smartdns-new-version https://github.com/xiaorouji/openwrt-passwall.git package/others/passwall_luci
# smartdns
mkdir package/others/smartdns
git clone --depth 1 https://github.com/pymumu/openwrt-smartdns.git package/others/smartdns/smartdns
mkdir package/others/smartdns_luci
git clone --depth 1 https://github.com/pymumu/luci-app-smartdns.git package/others/smartdns_luci/luci-app-smartdns
sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/others/smartdns_luci/luci-app-smartdns/Makefile
# openclash
mkdir package/others/openclash
cd package/others/openclash
git init
git remote add origin https://github.com/vernesong/OpenClash.git
git config core.sparsecheckout true
echo "luci-app-openclash" >> .git/info/sparse-checkout
git pull --depth 1 origin master
git branch --set-upstream-to=origin/master master
cd ../../..
# fileassistant
mkdir package/others/fileassistant
cd package/others/fileassistant
git init
git remote add origin https://github.com/Lienol/openwrt-package.git
git config core.sparsecheckout true
echo "luci-app-fileassistant" >> .git/info/sparse-checkout
git pull --depth 1 origin main
git branch --set-upstream-to=origin/main master
cd ../../..

### Others
# Change Cpu Mode
sed -i 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE/g' target/linux/x86/64/config-5.10
sed -i '/CONFIG_CPU_FREQ_GOV_SCHEDUTIL/a\CONFIG_CPU_FREQ_GOV_PERFORMANCE=y' target/linux/x86/64/config-5.10
# Modify default IP
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate
# Modify Hostname
sed -i 's/OpenWrt/Joee/g' package/base-files/files/bin/config_generate
# Modify Timezone
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate
