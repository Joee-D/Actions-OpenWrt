openwrt builder

## Docker 镜像（arm64 / ext4）

`.github/workflows/build-docker.yml` 编译 `armsr/armv8`（aarch64）的 ext4 rootfs，
再把 rootfs 打包成 `linux/arm64` 镜像推到 GHCR。

- 配置：`config.arm64-docker`
- 镜像：`ghcr.io/joee-d/openwrt-arm64:25.12.6-arm64`（同时打 `:arm64`）
- 构建产物：ext4 rootfs 作为 Actions artifact 保留 7 天
- 触发：Actions → `OpenWrt Docker (arm64 / ext4)` → Run workflow

> 首次推送后 GHCR package 默认 private。到仓库 Packages → `openwrt-arm64`
> → Package settings 改可见性，或拉取前先 `docker login ghcr.io`。

## 主路由模式（host 网络）

```
             ┌──────────────────────────────┐
Internet ────│ wan0    OpenWrt 容器    lan0  │──── LAN
             │         (host netns)    lan1  │
             └──────────────────────────────┘
```

`network_mode: host` 让容器和宿主共享网络栈，OpenWrt 直接管理物理网卡：
PPPoE、DHCP、NAT、防火墙都按正常路由器工作，WAN 用的是物理网卡 MAC，
不会每次启动变。

> 两个 “network” 别混：
> - Docker 的 `network_mode`：主路由用 `host`，**不是 `none`**。
> - OpenWrt 的 `/etc/config/network`：WAN/LAN 也**不能是 `none`**。
>   `proto none` 是旁路由/纯容器、地址交给 Docker 时才用的。

### 1. 固定网卡名

按 MAC 把网卡固定成 `wan0` / `lan0` / `lan1`，避免 `enp1s0`/`enp2s0` 顺序漂移：

```bash
ip -br link        # 查 MAC
sudo cp docker/udev/70-openwrt-nics.rules.example /etc/udev/rules.d/70-openwrt-nics.rules
sudo vim /etc/udev/rules.d/70-openwrt-nics.rules   # 换成自己的 MAC
sudo udevadm control --reload
sudo udevadm trigger --subsystem-match=net --action=add
sudo reboot
```

### 2. 让宿主机放开这些网卡

宿主不能再给 WAN/LAN 配 IP、跑 DHCP 客户端，否则会和 netifd 抢：

```bash
sudo nmcli device set wan0 managed no
sudo nmcli device set lan0 managed no
sudo nmcli device set lan1 managed no
# 或者整机专用时直接停掉：
# sudo systemctl disable --now NetworkManager systemd-networkd
```

还要处理端口/服务冲突（host 模式下宿主和容器共用一个网络栈）：

```bash
# dnsmasq 要占 53
sudo systemctl disable --now systemd-resolved
# OpenWrt 的 dropbear 默认 22，会和宿主 sshd 冲突：
# 把宿主 sshd 改到 2222，或只在管理口监听
```

PPPoE / NAT / TUN 需要宿主内核模块：

```bash
sudo modprobe tun pppoe ppp_generic nf_nat nft_chain_nat
```

> host 模式下 `ports:` 无效（没有独立的网络命名空间），所有端口直接占用宿主。
> 也**不要在 LuCI 里点“重启/关机”**，那会作用于整台宿主；用
> `docker compose restart` / `reboot` 管理宿主。

### 3. 启动

```bash
# 按需改 docker-compose.yml 里的 WAN_PROTO / WAN_USER / WAN_PASS / LAN_IFS
docker compose up -d
docker logs -f openwrt
```

`LAN_IFS` 支持多个口，空格分隔（会一起桥接进 `br-lan`）：

```yaml
LAN_IFS: "lan0 lan1 lan2"
```

PPPoE 示例：

```yaml
WAN_PROTO: pppoe
WAN_USER: "宽带账号"
WAN_PASS: "宽带密码"
```

并把 compose 里的 `/dev/ppp` 取消注释。

### 4. 访问

LuCI：<http://192.168.1.1>，用户名 `root`，首次为空密码，进去后马上设置。
LAN 口默认由 dnsmasq 发 192.168.1.100–250。

### 镜像里的网络生成逻辑

容器首次启动时 `docker/entrypoint.sh` 按环境变量生成 `/etc/config/network`：

| 变量 | 默认 | 说明 |
| --- | --- | --- |
| `WAN_IF` | `eth0` | WAN 物理网卡名 |
| `WAN_PROTO` | `dhcp` | `dhcp` / `pppoe` / `static` |
| `WAN_USER` / `WAN_PASS` | 空 | PPPoE 账号密码 |
| `WAN_IP` / `WAN_NETMASK` / `WAN_GW` | 空 | 静态 WAN |
| `LAN_IFS` | `eth1` | 一个或多个 LAN 口，空格分隔 |
| `LAN_IP` | `192.168.1.1` | LAN 网关 |
| `LAN_NETMASK` | `255.255.255.0` | LAN 掩码 |
| `OPENWRT_NETWORK_FORCE` | `0` | 设为 `1` 时每次启动重写 network |

生成一次后由 LuCI/UCI 接管；改了环境变量要 `OPENWRT_NETWORK_FORCE=1`
或 `docker compose down -v` 才会重新生成。`/etc` 挂在 named volume 里，
root 密码、LuCI 配置都会保留。

### 注意

- 容器共享宿主内核，`kmod-*` 用的是**宿主内核模块**；宿主缺 `pppoe`、
  `nf_nat`、`nft_chain_nat` 等模块时，OpenWrt 里装 kmod 也没用。
- host 模式下 OpenWrt 会改宿主的路由、防火墙、IP；只适合整机专用软路由。
- 如果这台机器还要跑 NAS/其他容器，不要用 host 模式：用 macvlan（容器固定
  `eth0/eth1`，但宿主与容器在 macvlan 上不通，PPPoE/多口桥接需实测），
  或把指定网卡 move 进独立 netns 再 `--network container:...`；
  最稳的是 OpenWrt 跑 KVM 虚拟机。
