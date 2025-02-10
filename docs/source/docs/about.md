# About OGG

Selfhosted GSM Gateway for Call and SMS Alerts

Welcome to Open Source GSM Gateway solution, designed to provide reliable, secure, and cost-effective communication for businesses and individuals who need a way to receive alerts via SMS/Call. With this advanced system, you can manage your call and SMS alerts efficiently without relying on third-party services. Whether you're running a small business, a remote operation, or a large enterprise, OGG ensures seamless integration with your existing systems to deliver real-time notifications for all your critical communication needs.

## What is a Open Source GSM Gateway?

A GSM Gateway is a device that connects your communication system to the Global System for Mobile Communications (GSM) network, allowing you to send and receive SMS messages and voice calls using a mobile network. The selfhosted version of this system gives you full control over the infrastructure, offering you enhanced security, customization, and scalability. By hosting it yourself, you eliminate dependence on third-party SMS and Call providers and reduce communication costs.

### Key Features:

1. Reliable Call & SMS Alerts

    Whether you're sending one-time password (OTP) alerts, reminders, system status updates, or emergency notifications, OGG ensures that your alerts are sent promptly and reliably.

2. Cost-Effective Solution

    By selfhosting, you avoid monthly fees from third-party SMS services. You pay only for the mobile data or calls made, significantly reducing operational costs in the long run. Total hardware cost is ~$5 to make your own GSM device!

3. Seamless Integration

    OGG is designed to integrate easily with existing applications and systems like monitoring tools, CRM platforms, and more. Whether you're automating notifications for security systems or customer service alerts, the gateway connects smoothly to your processes.

4. Full Control and Security

    Hosting the GSM Gateway on your own premises means full control over your communication data. You can secure your infrastructure, ensuring sensitive information remains private and under your direct supervision.

5. Scalable and Flexible

    Whether you’re a startup or a large enterprise, OGG scales with your needs. You can easily expand the system as your alert volume grows.

6. Voice Call Support

    In addition to SMS, the gateway also supports voice calls, which can be used for automated voice alerts, appointment reminders, and emergency notifications.

7. Comprehensive Monitoring

    Track your alerts in real-time with detailed logs that help you manage your communication efficiently.
___    

### Benefits of Selfhosting:

- Data Privacy: No need to worry about third-party data breaches, as all your communication data stays on your network.
- Customizable: Tailor the system to suit your specific requirements. Implement custom rules and workflows for different types of alerts.
- 24/7 Availability: Ensure your alerts are operational round the clock, with no downtime caused by external service providers.
- Flexible API Integration: Easily integrate the gateway with your CRM, IoT devices, or automated systems for smart alerts.

### Downsides of Selfhosting:

- Hardware acquirement can take anywhere from 1 week up to couple months from AliExpress. You could check local shops/websites and purchase locally.
- It might require some soldering to connect everything tightly. Some modules can be purchased with pre soldered pins, and connected with "[jumper wires](https://www.google.com/search?q=jumper+wires+female+to+female&udm=2&sxsrf=AHTn8zrk7VXu0ttDMsgRYR_LRxWD93FgGA%3A1739193365634&uact=5)". 
    - !!! danger "Soldering could be dangerous due to high heat 🔥 and fume exhausts 💨, so if unsure how to do it properly you could ask local repair shop to do it for you!"
- Some SIM providers do not allow automated or bulk interactions - please check their ToS.
___

# Idea behind OGG :light_bulb:

We needed a reliable solution to deliver critical alerts since *Android* and *iOS* devices had trouble keeping services like [ntfy](https://docs.ntfy.sh) active in background and notifications would often be delivered but not visible (no actual alert/buzz).
___

What have we tried :

1. Email alerts - custom long email melody which would be unheard if phone was left on mute.
1. ntfy - awesome service, but phone clients are unreliable since most phones just killed all background services which are not system default. (We tried exclusions, whitelists, disabling phone optimizations,  etc...)
1. Initial OGG system on Android phone via [adb](https://developer.android.com/tools/adb) - which proved unreliable as the bridge would keep disconnecting and would require manual confirmation on device.
1. Android apk which provided API for SMS - service would stop working due to "android optimizations", there was no feature to call numbers.
___

[Majkinetor](https://github.com/majkinetor) which is the author of this [mm-docs](https://github.com/majkinetor/mm-docs-template) template, endorsed the idea of developing custom reliable solution ✅.

Solution which could be hosted on-premise, behind UPS, independent from internet and expensive cloud services over which we had no control. 

Built on [PWSH](https://github.com/PowerShell/PowerShell) & [Pode](https://github.com/Badgerati/Pode) to provide highly customizable solution.
___

# History

- First prototype was hosted on HP laptop with "A6 GPRS Pro" module, it was quite stable but it was lacking some features - [Supported Hardware](./supported-hardware.md).
- After moving the system to Gigabyte Brix mini PC, device was loosing power and connectivity due to USB Hub not delivering constant current for *unknown reason*.
- Second prototype [SIM800L](wiringsim800l.md) is what we are currently using, it has been thoroughly tested on various devices and on different OSs.
    - Second prototype included much smaller hardware "SIM800L" with capacitor *16V 2200uF* which could provide enough current during fluctuations to keep device operatible.
___

{% include 'footer.md' %}
