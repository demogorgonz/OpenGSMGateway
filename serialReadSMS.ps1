# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"


if ($IsWindows) {
    $port = new-Object System.IO.Ports.SerialPort COM$(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } |Select-Object Name | select-string \d+ | % { $_.matches.Value }), $BaudRate, None, 8, one
}
elseif ($IsLinux) {
    $device = $(dmesg | grep tty | grep -oE '[^ ]+$' | tail -n 1)   
    $port = New-Object System.IO.Ports.SerialPort /dev/$device, $BaudRate, None, 8, one
}
elseif ($IsMacOS) {
    Write-Host "MacOS"
    # TODO - needs testing
}

$port.open()
$port.Write("AT+CMGF=1`r")
Start-Sleep 5
$port.Write("AT+CMGL=`"REC UNREAD`" `r")
Start-Sleep 1
$output = $port.ReadExisting()
$output | Out-File -Append $ReceivedSMSFileLog 
$ParseOutput = Get-Content $ReceivedSMSFileLog | Select-String -Pattern 'CMGL' -Context 0,2 | Select -Skip 1
$ParseOutput -replace "`n","" -replace "`r","" -match "\d" -replace '.+?(UNREAD",")','' -replace '"','' -replace ',,',' ' -replace ',',' ' 
$port.Write("AT+CMGDA=`"DEL ALL`" `r")
$port.Close()
Start-Sleep 1
