# Enter PSScriptRoot
cd $PSScriptRoot

# Define and create queue files
$Callfile = ".\queue\call.txt"
$SMSfile  = ".\queue\sms.txt"

if (!(Test-Path $CALLfile)) {
    New-Item -itemType File -Name $CALLfile -Force
}
if (!(Test-Path $SMSfile)) {
    New-Item -itemType File -Name $SMSfile -Force
}

# Logs folder

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

# Clean empty lines from queue 
function CALLCleanEmptyLines() { 
    (Get-Content $Callfile) | ? { $_ }  | Set-Content $Callfile
}
function SMSCleanEmptyLines() { 
    (Get-Content $SMSfile) | ? { $_ }  | Set-Content $SMSfile
}

CallCleanEmptyLines
SMSCleanEmptyLines

$LockFilePath =  ".\Instance.Lock"

$Locked = $null -ne (Get-Item -Path $LockFilePath -EA 0)
if ($Locked) {Exit}

# Lock
New-Item -Path $LockFilePath

if ((Get-Content $Callfile).Length -gt 0) {
    
    foreach ($phoneNumber in $(Get-Content $CALLfile)) {
        Write-Host "calling $phoneNumber"
        Write-Output "$(LogFormat) - Calling: $phoneNumber" | Out-File -Append .\$LogsFolder\call-$(logFileFormat).log
        .\serialCall.ps1 -number $phoneNumber
            (Get-Content $CALLfile).Replace($phoneNumber, '') -join "`r`n"  | Set-Content $CALLfile -Force -NoNewline
        CALLCleanEmptyLines
    }

}

else {
    "File is empty, no numbers to call."
}

if ((Get-Content $SMSfile).Length -gt 0) {
    
    foreach ($sms in $(Get-Content $SMSfile)) {
        Write-Host "Sending Message to $sms"
        Write-Output "$(LogFormat) - SMS to: $sms" | Out-File -Append .\$LogsFolder\sms-$(logFileFormat).log
        $number, $message = $sms.Split(":")
        .\serialSMS.ps1 -number $number -message $message
        write-host "deb1 $number, deb2 $message"
            (Get-Content $SMSfile).Replace($sms, '') -join "`r`n"  | Set-Content $SMSfile -Force -NoNewline
        SMSCleanEmptyLines
    }

}

else {
    "File is empty, no numbers to call."
}

# Remove lock
Remove-Item -Path $LockFilePath
