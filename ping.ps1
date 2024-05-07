# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

if ($PingDevice -eq 'true') {

    try {
        $port = new-Object System.IO.Ports.SerialPort COM$(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } |Select-Object Name | select-string \d+ | % { $_.matches.Value }), 115200, None, 8, one
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