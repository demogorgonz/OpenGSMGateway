﻿# Configuration

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
___

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

## Contacts

> contacts.ps1
```powershell
$contacts = @{ 
    'user@example.com'   = "123456789"
    'user1@example.com'  = "223456789"
    'user2@example.com'  = "323456789"
}
```
Contact emails are matched to phone number for `Email2Call` feature.

## Server Configuration

> server.ps1
```powershell
# Enter PSScriptRoot
cd $PSScriptRoot

Start-PodeServer -Threads 4 -RootPath "$PWD" {

    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http 
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging -Levels @("Error", "Warning")
    Add-PodeRoute -Method Get -Path '/call' -ScriptBlock {
        & "$PSScriptRoot\add2queueCALL.ps1" -number $WebEvent.Query['number']
    }
 
    Add-PodeRoute -Method Get -Path '/sms' -ScriptBlock {
        $parameters = $WebEvent.Query
        Write-Output $parameters
        $result = (& "$PSScriptRoot\add2queueSMS.ps1" @parameters)
    }

    Add-PodeSchedule -Name 'mail-check' -Cron '*/1 * * * *' -ScriptBlock {
        pwsh -File "$using:PWD/mail-check.ps1"
    }

    Add-PodeSchedule -Name 'task' -Cron '*/1 * * * *' -ScriptBlock {
        pwsh -File "$using:PWD/task.ps1"
    }


}
```

Pode server is preconfigured to run with 4 threads. [More info](https://pode.readthedocs.io/en/stable/Tutorials/Threading/ServerThreads/)

Currently server is not parameterized and features can't be excluded with config, but feel free to comment out any feature that is not wanted.

{% include 'footer.md' %}