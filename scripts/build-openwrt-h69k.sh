#!/usr/bin/env bash
set -euo pipefail

OPENWRT_TAG="${OPENWRT_TAG:-v25.12.4}"
JOBS="${JOBS:-$(nproc)}"

if [ ! -d openwrt ]; then
  git clone --depth 1 --branch "$OPENWRT_TAG" https://github.com/openwrt/openwrt.git openwrt
fi

./scripts/prepare-openwrt-h69k.sh openwrt

cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a

make defconfig
make download -j"$JOBS"

if ! make -j"$JOBS" V=s; then
  echo "Parallel build failed; retrying single-threaded for a clearer error log." >&2
  make -j1 V=s
fi

mkdir -p ../artifacts
cp -a bin/targets/rockchip/armv8/*hinlink_opc-h69k* ../artifacts/ 2>/dev/null || true
cp -a bin/targets/rockchip/armv8/profiles.json ../artifacts/ 2>/dev/null || true
cp -a bin/targets/rockchip/armv8/sha256sums ../artifacts/ 2>/dev/null || true

(
  cd ../artifacts
  sha256sum * 2>/dev/null || true
)
