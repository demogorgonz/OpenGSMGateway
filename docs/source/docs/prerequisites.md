# Prerequisites

- OS: Windows or Linux (ARM is supported, e.g. RPI)
- GSM module with SIM card (Check [supported hardware page](supported-hardware.md))
- Unified mailbox for Email2Call alerts, e.g alerts@example.com (**Optional**)
- FT232RL drivers [Linux](https://ftdichip.com/wp-content/uploads/2020/08/AN_220_FTDI_Drivers_Installation_Guide_for_Linux-1.pdf) or [Windows](https://ftdichip.com/drivers/d2xx-drivers/). If you are using another USB2TTL device, make sure to install correct drivers for your OS.

___

# Software Prerequisites

- PowerShell
    - Installed [Pode](https://badgerati.github.io/Pode/Getting-Started/Installation/#minimum-requirements) module (for API purposes)
    - Mailozaurr (**Optional** | Will be installed during mail script run) 
- [GIT](https://git-scm.com/downloads) (**Optional**)
- [Chocolatey](https://chocolatey.org/install) (**Optional | Windows only**)
- [NSSM](https://community.chocolatey.org/packages/NSSM) (**Optional | Windows only | Running OGG as service**)
___

{% include 'footer.md' %}