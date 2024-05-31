# Enter PSScriptRoot
cd $PSScriptRoot

# Select USB port depending on OS
function Get-Port() {
    if ($IsWindows) {
        $global:port = new-Object System.IO.Ports.SerialPort COM$(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } |Select-Object Name | select-string \d+ | % { $_.matches.Value }), $BaudRate, None, 8, one
    }
    elseif ($IsLinux) {
        $global:device = $(dmesg | grep tty | grep -oE '[^ ]+$' | tail -n 1)   
        $global:port = New-Object System.IO.Ports.SerialPort /dev/$device, $BaudRate, None, 8, one
    }
    elseif ($IsMacOS) {
        Write-Host "MacOS"
        # TODO - needs testing
    }
}

# Define and create queue files
$Callfile = ".\queue\call.txt"
$SMSfile  = ".\queue\sms.txt"

if (!(Test-Path $CALLfile)) {
    New-Item -itemType File -Name $CALLfile -Force
}
if (!(Test-Path $SMSfile)) {
    New-Item -itemType File -Name $SMSfile -Force
}

# Define and create logs folder

$LogsFolder = ".\logs"
if (!(Test-Path $LogsFolder)) {
    New-Item -Type Directory -Name $LogsFolder -Force
}

# Date Formats
function logFileFormat() { 
    $(Get-Date -Format "dd.MM.yyyy")
}
function LogFormat() { 
    $( Get-Date -Format "HH:mm:ss dd.MM.yyyy" )
}

# Received SMS Log
$ReceivedSMSFileLog = ".\$LogsFolder\receivedSMS-$(logFileFormat).log"

# Error file
$ErrLogFile = ".\$LogsFolder\error-$(logFileFormat).log"


# Clean empty lines from queue 
function CALLCleanEmptyLines() { 
    (Get-Content $Callfile) | ? { $_ }  | Set-Content $Callfile
}
function SMSCleanEmptyLines() { 
    (Get-Content $SMSfile) | ? { $_ }  | Set-Content $SMSfile
}

# Lock

$LockFilePath =  ".\Instance.Lock"

$Locked = $null -ne (Get-Item -Path $LockFilePath -EA 0)
