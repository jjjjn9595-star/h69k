# OpenWrt 25.12 H69K build kit

This build kit adds a local `hinlink_opc-h69k` profile to official OpenWrt
25.12.4 `rockchip/armv8` source.

The included DTS was extracted from the known-good H69K firmware named
`openwrt-h69k-or5700-40度起小风版本.img.gz`, so it keeps the 40 C fan-start
thermal policy.

## What it builds

- Target: `rockchip/armv8`
- Device: `hinlink_opc-h69k`
- Kernel/rootfs partitions: 32 MiB / 512 MiB, matching the current H69K layout
- Kernel: OpenWrt 25.12.4 default, Linux 6.12
- Drivers: `kmod-r8125`, `kmod-hwmon-pwmfan`, `kmod-hwmon-gpiofan`
- UI: LuCI with Chinese base/firewall translations
- Overlay: `h69k-fan` helper and init script

## Build with GitHub Actions

1. Put this directory in a GitHub repository.
2. Open the repository Actions tab.
3. Run `Build OpenWrt 25.12 H69K`.
4. Download the `openwrt-h69k-25.12` artifact.

The expected firmware file is:

```text
openwrt-25.12.4-rockchip-armv8-hinlink_opc-h69k-squashfs-sysupgrade.img.gz
```

## Build on Linux

```sh
sudo apt-get update
sudo apt-get install -y build-essential clang flex bison g++ gawk gcc-multilib \
  g++-multilib gettext git libncurses-dev libssl-dev python3-setuptools rsync \
  swig unzip zlib1g-dev file wget python3 python3-distutils libelf-dev ccache \
  ecj fastjar java-propose-classpath zstd

chmod +x scripts/*.sh
./scripts/build-openwrt-h69k.sh
```

Artifacts are copied to `artifacts/`.

## Flash test

Always test on the router before flashing:

```sh
scp openwrt-25.12.4-rockchip-armv8-hinlink_opc-h69k-squashfs-sysupgrade.img.gz root@192.168.1.1:/tmp/h69k-25.img.gz
ssh root@192.168.1.1
sysupgrade -T /tmp/h69k-25.img.gz
```

If the test exits `0`, flash without preserving old config:

```sh
sysupgrade -n /tmp/h69k-25.img.gz
```

Keep the existing 24.10 recovery image nearby until Ethernet, LuCI, fan control,
and package installation are verified.

## Important caution

This first build intentionally uses the H69K DTS extracted from the existing
Linux 6.6 firmware. It should be treated as a test build for Linux 6.12, not a
vendor-certified release. Do not force flash if `sysupgrade -T` fails.
