# Wiring A6 PRO 

!!! danger "Make sure to switch to 5V on USB2TTL serial adapter" 

![FTDI FT232BL Pinout](files/FT232BL_pinout_transparent.drawio.png)

## Wiring

| VCC | to | VCC |
|:---:|:--:|:---:|
| GND | to | GND |
| RX  | to | TX  |
| TX  | to | RX  |

!!! info "This device need external power supply"
!!! info "Seems like device can read SMS while serial is attached, but there is no way to retrieve SMS on command"
!!! danger "Soldering could be dangerous due to high heat 🔥 and fume exhausts 💨, so if unsure how to do it properly you could ask local repair shop to do it for you!"

![FTDI FT232BL A6PRO Wiring Pinout](files/WiringFT232BL-A6.png)

{% include 'footer.md' %}
