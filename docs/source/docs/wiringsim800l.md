# Wiring SIM800L

!!! danger "Make sure to switch to 5V on USB2TTL serial adapter" 

![notice](files/FT232BL_pinout_transparent.drawio.png)

## Wiring USB2TTL

| VCC | to | VCC |
|:---:|:--:|:---:|
| GND | to | GND |
| RX  | to | TX  |
| TX  | to | RX  |

![wiring](files/WiringSIM800L.drawio.png)

___

## Additional power information

!!! danger "IMPORTANT!!!" 

- SIM800L needs external power supply 5V/2A
- This can be bypassed with capacitor 16V 2200uF and provide stability during Calls & SMS due to higher power draw.

## Capacitor Wiring

| VCC | to | VCC |
|:---:|:--:|:---:|
| GND | to | GND |

{% include 'footer.md' %}
