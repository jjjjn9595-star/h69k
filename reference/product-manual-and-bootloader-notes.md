# H69K product manual and H6XK bootloader notes

Files:

- `C:/Users/fit/Downloads/H69K产品说明书.pdf`
- `C:/Users/fit/Downloads/H6XK-Boot-Loader.bin`

## Product manual

The PDF is a one-page user note. It is useful for operation/defaults, not for
OpenWrt porting.

Useful details:

- Default web address: `192.168.1.1`.
- Default account: `root`.
- Default password shown in this manual: `password`.
- Wi-Fi password shown in this manual: `1234567890`.
- Power note: use a dual Type-C fast charger with a 12V profile and at least
  2A output.
- Boot behavior note: fan runs high then slows down, screen lights up, and time
  syncs after networking.

## H6XK-Boot-Loader.bin

Observed file facts:

- Size: `465344` bytes.
- SHA256: `7074db2b8f176cc9d0ba06b86740da1fce5b11a5433b04952d79e37f30e3d8b0`.
- Starts with Rockchip `LDR` magic.
- Contains DDR/eMMC/USB boot strings such as `DDR Version V1.13 20220218`,
  `Emmc IO init.`, and `UsbBoot`.

Comparison against the current H69K eMMC first 128 MiB backup:

- Exact bootloader blob was not found in the current eMMC backup.
- The current eMMC sector 64 starts with `RKNS`, not `LDR`.
- The current eMMC sector `0x4000` starts with FIT magic `d00dfeed`.

Conclusion:

- Keep this file as a rescue/line-flash reference.
- Do not inject it into the OpenWrt 25.12 sysupgrade build by default.
- Do not overwrite eMMC boot areas with it unless following a vendor recovery
  procedure or doing controlled serial/USB-maskrom recovery.
