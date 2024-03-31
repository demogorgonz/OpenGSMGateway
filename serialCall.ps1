param([string]$number = '') 

# Enter PSScriptRoot
cd $PSScriptRoot

# Import config
. "$PSScriptRoot\config.ps1"

# Model configuration
If ($Model -eq "A6PRO") { $Syntax = " `r" }
ElseIf ($Model -eq "SIM800L") { $Syntax = "" }

if ($IsWindows) {
    $port = new-Object System.IO.Ports.SerialPort COM$(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } |Select-Object Name | select-string \d+ | % { $_.matches.Value }), $BaudRate, None, 8, one
}
elseif ($IsLinux) {
    $device = $(dmesg | grep tty | grep -oE '[^ ]+$' | tail -n 1)
    $port = new-Object System.IO.Ports.SerialPort /dev/$device, $BaudRate, None, 8, one
}
elseif ($IsMacOS) {
    Write-Host "macOS"
    # TODO - needs testing
}   
$port.open()
$port.WriteLine("ATD$number;$Syntax")
Start-Sleep $CallDuration
$Port.WriteLine("AT+CHUP;$Syntax")    
$port.Close()

