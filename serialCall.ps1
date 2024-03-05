param([string]$number = '') 

# Enter PSScriptRoot
cd $PSScriptRoot

# Import config
. "$PSScriptRoot\config.ps1"

if ($IsWindows) {
    $port = new-Object System.IO.Ports.SerialPort COM$(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } |Select-Object Name | select-string \d+ | % { $_.matches.Value }), $BaudRate, None, 8, one
    $port.open()
    $port.WriteLine("ATD$number; `r")
    Start-Sleep $CallDuration
    $Port.WriteLine("AT+CHUP; `r")    
    $port.Close()
}

elseif ($IsMacOS) {
    Write-Host "macOS"
    # TODO - needs testing
}

elseif ($IsLinux) {
    $device = $(dmesg | grep tty | grep -oE '[^ ]+$' | tail -n 1)
    $port = new-Object System.IO.Ports.SerialPort /dev/$device, $BaudRate, None, 8, one
    $port.open()
    $port.WriteLine("ATD$number; `r")
    Start-Sleep $CallDuration
    $Port.WriteLine("AT+CHUP; `r")
    $port.Close()
}
