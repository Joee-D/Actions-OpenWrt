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

# Change Theme
#rm -rf feeds/luci/applications/luci-app-argon-config
#git clone https://github.com/jerrykuku/luci-app-argon-config.git feeds/luci/applications/luci-app-argon-config
#rm -rf feeds/luci/themes/luci-theme-argon
#git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

# Modify default IP
#sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

# Change Cpu Mode
sed -i 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE/g' target/linux/x86/generic/config-5.15
sed -i 's/CONFIG_CPU_FREQ_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_GOV_PERFORMANCE/g' target/linux/x86/generic/config-5.15
sed -i 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE/g' target/linux/x86/generic/config-6.1
sed -i 's/CONFIG_CPU_FREQ_GOV_SCHEDUTIL/CONFIG_CPU_FREQ_GOV_PERFORMANCE/g' target/linux/x86/generic/config-6.1
