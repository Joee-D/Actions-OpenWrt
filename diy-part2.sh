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

# Support turboacc
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh  --no-sfe

# Add Packages
rm -r package/others -f
mkdir package/others

#OpenWrt-mihomo
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git package/others

# 添加 'i915/glk_dmc_ver1_04.bin' 到6.6的内核
#mkdir -p firmware/i915
#curl -L https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/glk_dmc_ver1_04.bin -o firmware/i915/glk_dmc_ver1_04.bin
#echo 'CONFIG_FIRMWARE_IN_KERNEL=y' >> target/linux/x86/64/config-5.15
#echo 'CONFIG_EXTRA_FIRMWARE="i915/glk_dmc_ver1_04.bin"' >> target/linux/x86/64/config-5.15
#echo 'CONFIG_EXTRA_FIRMWARE_DIR="/workdir/openwrt/firmware"' >> target/linux/x86/64/config-5.15


# 以下为其他配置

# openclash
#mkdir package/others/openclash
#cd package/others/openclash
#git init
#git remote add origin https://github.com/vernesong/OpenClash.git
#git config core.sparsecheckout true
#echo "luci-app-openclash" >> .git/info/sparse-checkout
#git pull --depth 1 origin master
#git branch --set-upstream-to=origin/master master

# ssr+
#git clone --depth 1 https://github.com/fw876/helloworld package/others/helloworld

# passwall
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/others/passwall_pkg
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall.git package/others/passwall
#git clone --depth 1 -b luci-smartdns-new-version https://github.com/xiaorouji/openwrt-passwall.git package/others/passwall
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git package/others/passwall2

# smartdns
#mkdir package/others/smartdns_luci
#git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns.git package/others/smartdns_luci/luci-app-smartdns
#mkdir package/others/smartdns
#git clone --depth 1 https://github.com/pymumu/openwrt-smartdns.git package/others/smartdns/smartdns

# Change Cpu Mode
#sed -i 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE/g' target/linux/x86/64/config-5.15
#sed -i '/CONFIG_CPU_FREQ_GOV_SCHEDUTIL/a\CONFIG_CPU_FREQ_GOV_PERFORMANCE=y' target/linux/x86/64/config-5.15
#sed -i 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE/g' target/linux/x86/64/config-6.1
#sed -i '/CONFIG_CPU_FREQ_GOV_SCHEDUTIL/a\CONFIG_CPU_FREQ_GOV_PERFORMANCE=y' target/linux/x86/64/config-6.1

# Modify default IP
#sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

# Modify Hostname
#sed -i 's/OpenWrt/Joee/g' package/base-files/files/bin/config_generate

# Modify Timezone
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate

# Fix docker network
# sed -i 's/v.IPAM and/v.IPAM and v.IPAM.Config and/g' package/feeds/luci/luci-app-dockerman/luasrc/model/cbi/dockerman/networks.lua

# Change Theme
#rm -rf feeds/luci/applications/luci-app-argon-config
#git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git feeds/luci/applications/luci-app-argon-config
#rm -rf feeds/luci/themes/luci-theme-argon
#git clone --depth 1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
