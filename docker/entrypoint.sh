#!/bin/sh
set -eu

# 首次启动（或 OPENWRT_NETWORK_FORCE=1）时，按环境变量生成 /etc/config/network。
# 这样同一镜像既能跑 host 网络主路由，也能跑 macvlan / 独立 netns：
#   host:    WAN_IF=wan0 LAN_IFS="lan0 lan1"
#   macvlan: WAN_IF=eth0 LAN_IFS="eth1 eth2"
# 生成后由 LuCI/UCI 接管；要重新按环境变量生成，设 OPENWRT_NETWORK_FORCE=1
# 或删掉 /etc/config/network 后重启容器。
if [ ! -s /etc/config/network ] || [ "${OPENWRT_NETWORK_FORCE:-0}" = "1" ]; then
	WAN_IF="${WAN_IF:-eth0}"
	WAN_PROTO="${WAN_PROTO:-dhcp}"
	LAN_IFS="${LAN_IFS:-eth1}"
	LAN_IP="${LAN_IP:-192.168.1.1}"
	LAN_NETMASK="${LAN_NETMASK:-255.255.255.0}"

	mkdir -p /etc/config
	: > /etc/config/network

	cat >> /etc/config/network <<'EOF'
config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'
	option dhcp_default_duid 'auto'
EOF

	if [ -n "$LAN_IFS" ]; then
		{
			echo "config device"
			echo "	option name 'br-lan'"
			echo "	option type 'bridge'"
			for iface in $LAN_IFS; do
				printf "\tlist ports '%s'\n" "$iface"
			done
			echo
			echo "config interface 'lan'"
			echo "	option device 'br-lan'"
			echo "	option proto 'static'"
			printf "\toption ipaddr '%s'\n" "$LAN_IP"
			printf "\toption netmask '%s'\n" "$LAN_NETMASK"
			echo "	option ip6assign '60'"
		} >> /etc/config/network
	fi

	{
		echo
		echo "config interface 'wan'"
		printf "\toption device '%s'\n" "$WAN_IF"
		printf "\toption proto '%s'\n" "$WAN_PROTO"
		case "$WAN_PROTO" in
			pppoe)
				printf "\toption username '%s'\n" "${WAN_USER:-}"
				printf "\toption password '%s'\n" "${WAN_PASS:-}"
				;;
			static)
				printf "\toption ipaddr '%s'\n" "${WAN_IP:-}"
				printf "\toption netmask '%s'\n" "${WAN_NETMASK:-255.255.255.0}"
				printf "\toption gateway '%s'\n" "${WAN_GW:-}"
				;;
		esac
	} >> /etc/config/network
fi

exec "$@"
