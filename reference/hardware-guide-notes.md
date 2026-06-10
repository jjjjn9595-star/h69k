# H68K/H69K 2023 hardware guide notes

Source PDF:
`C:/Users/fit/Downloads/H68K与H69K 2023年款 硬件快速开发指南_2023912.pdf`

This is useful as a hardware reference for the H69K OpenWrt 25.12 port, but it
is not a build recipe and does not replace the DTS extracted from a known-good
firmware.

Useful facts found in the guide:

- SoC: RK3568.
- 2.5G Ethernet uses RTL8125B.
- 2.5G port 2:
  - PCIe data is on the PCIe 3.0 x2 PHY channel 1.
  - RTL8125B reset GPIO: `GPIO2_D0_d`.
  - RTL8125B power enable GPIO: `GPIO0_C4_d`.
- 2.5G port 3:
  - PCIe data is on the PCIe 3.0 x2 PHY channel 0.
  - RTL8125B reset GPIO: `GPIO3_A4_d`.
  - RTL8125B power enable GPIO: `GPIO0_C4_d`.
- Fan:
  - Signal `FAN_EN` is connected to `GPIO0_B7` / `PWM0_M0`.
  - Fan input power is 5V.
  - Higher PWM duty cycle means higher fan speed.
- OLED/screen:
  - Controller: SSD1306.
  - Bus pins: `I2C5_SDA_M0`, `I2C5_SCL_M0`.
- TF card:
  - Detect GPIO: `GPIO0_A4` / `SDMMC0_DET`.
  - Power enable GPIO: `GPIO0_A6` / `SD_PWREN`.
- Factory key:
  - Connected to `GPIO0_A0`, active low.
- IR receiver:
  - Connected to `GPIO0_C2` / `PWM3_IR`.

Porting impact:

- Keep `kmod-r8125` in the 25.12 build.
- Keep `kmod-hwmon-pwmfan` and `kmod-hwmon-gpiofan`.
- The extracted DTS fan node using PWM0 is consistent with the hardware guide.
- The guide says some GPIO details are still DTS-dependent, so the extracted
  working DTS remains the primary source of truth.
