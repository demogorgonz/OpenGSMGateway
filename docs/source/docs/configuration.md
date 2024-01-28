# Configuration

> config.ps1
```powershell
# MAIL
$SkipCertificateCheck = $False
$Server = "mail.example.com"
$Domain = "example.com"
$Account = "alert@example.com"
$Password = "P@ssw0rd"
$MoveMailToFolder = "Junk"

# Call
$CallDuration = "30"

# Baud Rate
$BaudRate = "115200"

```
## MAIL

#### SkipCertificateCheck

- Switch for skipping SSL check if your IMAP is using self signed cert or if root CA is not on the system.

#### $Server

- URL of IMAP server.

#### $Domain

- Domain is used for contacts validation in mail check.

#### $Account

- Unified mailbox/account where emails are sent/forwarded.

#### $Password

- Password of `$Account`

#### $MoveMailToFolder

- Script is moving processed email to defined IMAP folder.

___

## Call

#### $CallDuration 

- This is timer after which call is dropped. 

!!! Note "Depending of carrier load or signal, it could take anywhere from 1 to ~5 seconds to establish call, this time is deducted from $CallDuration. Meaning the phone will ring for ~25s if establishing call took 5s." 

___


## Baud Rate

#### $BaudRate

- For most devices default BaudRate is `115200`, if stated otherwise, replace it in config.

___

{% include 'footer.md' %}