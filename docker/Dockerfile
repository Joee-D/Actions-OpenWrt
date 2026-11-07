# syntax=docker/dockerfile:1

# OpenWrt 是自包含的 rootfs，直接从 scratch 起，不引入任何发行版基础层
FROM scratch

# CI 会把 armsr/armv8 的 ext4 rootfs 挂载后打成 rootfs.tar
ADD rootfs.tar /

# 覆盖默认 system 配置（时区/NTP 等）
COPY files/ /

# 首次启动按 WAN_IF / LAN_IFS / WAN_PROTO 生成 /etc/config/network
COPY entrypoint.sh /entrypoint.sh

ENV PATH=/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT ["/entrypoint.sh"]

# 默认交互 shell；主路由用 docker compose ... command: /sbin/init
CMD ["/bin/sh"]
