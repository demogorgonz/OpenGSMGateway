# Wiring SIM800L

!!! danger "Make sure to switch to 5V on USB2TTL serial adapter" 

![FTDI FT232BL Pinout](files/FT232BL_pinout_transparent.drawio.png)

## Wiring USB2TTL

| VCC | to | VCC |
|:---:|:--:|:---:|
| GND | to | GND |
| RX  | to | TX  |
| TX  | to | RX  |

![FTDI FT232BL SIM800L Wiring Pinout](files/WiringSIM800L.drawio.png)

___

## Additional power information

!!! danger "IMPORTANT!!!" 

- SIM800L needs external power supply 5V/2A
- This can be bypassed with capacitor 16V 2200uF and provide stability during Calls & SMS due to higher power draw.
    - !!! danger "Soldering could be dangerous due to high heat 🔥 and fume exhausts 💨, so if unsure how to do it properly you could ask local repair shop to do it for you!"

## Capacitor Wiring

| VCC | to | VCC |
|:---:|:--:|:---:|
| GND | to | GND |

{% include 'footer.md' %}
