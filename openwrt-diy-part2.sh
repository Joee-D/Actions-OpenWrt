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

# Change Cpu Mode
#sed -i 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE/g' target/linux/x86/64/config-5.15
#sed -i '/CONFIG_CPU_FREQ_GOV_SCHEDUTIL/a\CONFIG_CPU_FREQ_GOV_PERFORMANCE=y' target/linux/x86/64/config-5.15
#sed -i 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE/g' target/linux/x86/64/config-6.1
#sed -i '/CONFIG_CPU_FREQ_GOV_SCHEDUTIL/a\CONFIG_CPU_FREQ_GOV_PERFORMANCE=y' target/linux/x86/64/config-6.1

# Change Theme
#rm -rf feeds/luci/applications/luci-app-argon-config
#git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git feeds/luci/applications/luci-app-argon-config
#rm -rf feeds/luci/themes/luci-theme-argon
#git clone --depth 1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

# Add Packages
rm -r package/others -f
mkdir package/others

# ssr+
#git clone --depth 1 https://github.com/fw876/helloworld package/others/helloworld

# passwall
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/others/passwall_pkg
#git clone --depth 1 -b luci https://github.com/xiaorouji/openwrt-passwall.git package/others/passwall
#git clone --depth 1 -b luci-smartdns-new-version https://github.com/xiaorouji/openwrt-passwall.git package/others/passwall
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git package/others/passwall2

# smartdns
#mkdir package/others/smartdns_luci
#git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns.git package/others/smartdns_luci/luci-app-smartdns
#mkdir package/others/smartdns
#git clone --depth 1 https://github.com/pymumu/openwrt-smartdns.git package/others/smartdns/smartdns

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
#mkdir package/others/fileassistant
#cd package/others/fileassistant
#git init
#git remote add origin https://github.com/Lienol/openwrt-package.git
#git config core.sparsecheckout true
#echo "luci-app-fileassistant" >> .git/info/sparse-checkout
#git pull --depth 1 origin main
#git branch --set-upstream-to=origin/main master
#cd ../../..


# Modify default IP
#sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

# Modify Hostname
#sed -i 's/OpenWrt/Joee/g' package/base-files/files/bin/config_generate

# Modify Timezone
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate

# 添加 'i915/glk_dmc_ver1_04.bin' 到5.15的内核
mkdir -p firmware/i915
curl -L https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/glk_dmc_ver1_04.bin -o firmware/i915/glk_dmc_ver1_04.bin
echo 'CONFIG_FIRMWARE_IN_KERNEL=y' >> target/linux/x86/64/config-5.15
echo 'CONFIG_EXTRA_FIRMWARE="i915/glk_dmc_ver1_04.bin"' >> target/linux/x86/64/config-5.15
echo 'CONFIG_EXTRA_FIRMWARE_DIR="/workdir/openwrt/firmware"' >> target/linux/x86/64/config-5.15
