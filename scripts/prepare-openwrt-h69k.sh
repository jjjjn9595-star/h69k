#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OPENWRT_DIR="${1:-openwrt}"

if [ ! -d "$OPENWRT_DIR" ]; then
  echo "OpenWrt tree not found: $OPENWRT_DIR" >&2
  exit 1
fi

cd "$OPENWRT_DIR"

DTS_TARGET="target/linux/rockchip/files/arch/arm64/boot/dts/rockchip"
mkdir -p "$DTS_TARGET"
cp "$ROOT_DIR/device/rk3568-hinlink-opc-h69k.dts" "$DTS_TARGET/rk3568-hinlink-opc-h69k.dts"

ARMV8_MK="target/linux/rockchip/image/armv8.mk"
if ! grep -q "Device/hinlink_opc-h69k" "$ARMV8_MK"; then
  cat >> "$ARMV8_MK" <<'EOF_H69K'

define Device/hinlink_opc-h69k
  $(Device/rk3568)
  DEVICE_VENDOR := HINLINK
  DEVICE_MODEL := OPC-H69K
  DEVICE_DTS := rk3568-hinlink-opc-h69k
  SUPPORTED_DEVICES := hinlink,opc-h69k
  UBOOT_DEVICE_NAME := radxa-e25-rk3568
  DEVICE_PACKAGES := blkdiscard block-mount ethtool kmod-r8125 kmod-hwmon-pwmfan kmod-hwmon-gpiofan
endef
TARGET_DEVICES += hinlink_opc-h69k
EOF_H69K
fi

cp "$ROOT_DIR/.config.seed" .config

if [ -d "$ROOT_DIR/files" ]; then
  rm -rf files
  mkdir -p files
  cp -a "$ROOT_DIR/files/." files/
fi

echo "H69K device files prepared in $OPENWRT_DIR"
