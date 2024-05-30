# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

if ($PingDevice -eq 'true') {
    try {
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
        $port.Open()
        start-sleep 5
        if (-not $port.IsOpen) {
            Write-Error "COM port cannot be opened";
        }

    }
    catch {
        Add-Content -Path $ErrLogFile -Value $("PING [" + (LogFormat) + "] " + "`n" + $_.Exception.Message)
    }

    Write-Host "ATTEMTING TO CLOSE COM PORT"
    $port.close()

}