# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

CallCleanEmptyLines
SMSCleanEmptyLines

# Remove lock if older than 10 minutes and retry tasks.
Get-ChildItem -Path $PWD -Filter "Instance.Lock" -Force | Where-Object {$_.CreationTime -lt $((Get-Date).AddMinutes(-10))} | Remove-Item

if ($Locked) {Exit}

# Ping
& ".\ping.ps1"

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
