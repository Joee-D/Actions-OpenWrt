openwrt builder

## Docker (arm64 / ext4)

`.github/workflows/build-docker.yml` 编译 `armsr/armv8`（aarch64）的 ext4 rootfs，
再把 rootfs 打包成 `linux/arm64` 镜像推到 GHCR。

- 配置：`config.arm64-docker`
- 镜像：`ghcr.io/joee-d/openwrt-arm64:25.12.6-arm64`（同时打 `:arm64`）
- 构建产物：ext4 rootfs 作为 Actions artifact 保留 7 天
- 触发：Actions → `OpenWrt Docker (arm64 / ext4)` → Run workflow

> 首次推送后，GHCR package 默认是 private。到仓库的 Packages → `openwrt-arm64`
> → Package settings 改可见性，或拉取前先 `docker login ghcr.io`。

```bash
# 交互 shell
docker run --rm -it --privileged ghcr.io/joee-d/openwrt-arm64:25.12.6-arm64

# 跑完整 OpenWrt（procd），LuCI 映射到宿主机 8080
docker run -d --name openwrt --privileged --restart unless-stopped \
  -p 8080:80 -p 8443:443 \
  ghcr.io/joee-d/openwrt-arm64:25.12.6-arm64 /sbin/init
```

说明：容器与宿主机共享内核，`kmod-*` 包在镜像里不会被加载；镜像默认把
`lan` 设为 `proto none`，地址交给 Docker，避免 netifd 生成 192.168.1.1/24。
