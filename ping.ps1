# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

if ($PingDevice -eq 'true') {
    try {
        # Select USB port depending on OS
        Get-Port
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