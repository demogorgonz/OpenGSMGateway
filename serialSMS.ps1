param(
    [string]$number = '',
    [string]$message = ''
) 

# Enter PSScriptRoot
cd $PSScriptRoot

# Import config
. "$PSScriptRoot\config.ps1"

if ($IsWindows) {
    $port = new-Object System.IO.Ports.SerialPort COM$(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } |Select-Object Name | select-string \d+ | % { $_.matches.Value }), $BaudRate, None, 8, one
    $port.open()
    $port.Write("AT+CMGF=1`r")
    Start-Sleep 5
    $port.ReadLine()
    $port.Write("AT+CMGS=`"$number`"`r")
    start-sleep 1
    $port.ReadLine()
    $port.Write("$message`r")
    $port.ReadLine()
    $z = new-Object String(26, 1)
    $port.Write("`r")
    $port.Write($z)
    Start-Sleep 1
    $port.Close()
    Start-Sleep 1
}

elseif ($IsMacOS) {
    Write-Host "macOS"
    # TODO - needs testing
}

elseif ($IsLinux) {
    $device = $(dmesg | grep tty | grep -oE '[^ ]+$' | tail -n 1)   
    $port = New-Object System.IO.Ports.SerialPort /dev/$device, $BaudRate, None, 8, one
    $port.open()
    $port.Write("AT+CMGF=1`r")
    Start-Sleep 5
    $port.ReadLine()
    $port.Write("AT+CMGS=`"$number`"`r")
    start-sleep 1
    $port.ReadLine()
    $port.Write("$message`r")
    $port.ReadLine()
    $z = new-Object String(26, 1)
    $port.Write("`r")
    $port.Write($z)
    Start-Sleep 1
    $port.Close()
    Start-Sleep 1
}