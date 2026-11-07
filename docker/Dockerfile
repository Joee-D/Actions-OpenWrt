# syntax=docker/dockerfile:1

# OpenWrt 是自包含的 rootfs，直接从 scratch 起，不引入任何发行版基础层
FROM scratch

# CI 会把 armsr/armv8 的 ext4 rootfs 挂载后打成 rootfs.tar
ADD rootfs.tar /

# 覆盖首次启动才生成的配置：容器网络由 Docker 管理，
# 避免 netifd 把 eth0 改成 192.168.1.1 的 br-lan，导致容器失联。
COPY files/ /

ENV PATH=/usr/sbin:/usr/bin:/sbin:/bin

# 默认交互 shell；要跑完整 OpenWrt 服务：docker run ... <image> /sbin/init
CMD ["/bin/sh"]
