﻿# Wiring SIM800L Blue

!!! danger "Make sure to switch to 5V on USB2TTL serial adapter" 

![FTDI FT232BL Pinout](files/FT232BL_pinout_transparent.drawio.png)

## Wiring USB2TTL

| VCC | to | VCC |
|:---:|:--:|:---:|
| GND | to | GND |
| RX  | to | TX  |
| TX  | to | RX  |

___

## Additional power information

!!! danger "IMPORTANT!!!" 

- SIM800L needs external power supply 5V/2A
- This can be bypassed with capacitor 16V 2200uF and provide stability during Calls & SMS due to higher power draw.

## Capacitor Wiring

| VCC | to | VCC |
|:---:|:--:|:---:|
| GND | to | GND |

## TODO

- Diagram
- Pictures with capacitor
!!! note "Can't find good image online, refer to [Wiring SIM800L](./wiringsim800l.md) temporally." 

{% include 'footer.md' %}
