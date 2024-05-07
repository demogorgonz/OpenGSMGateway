param([string]$number = '') 

# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

# Model configuration
If ($Model -eq "A6PRO") { $Syntax = " `r" }
ElseIf ($Model -eq "SIM800") { $Syntax = "" }

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

try {
$port.open()
$port.WriteLine("ATD$number;$Syntax")
Start-Sleep $CallDuration
$output = $port.ReadExisting()
ForEach ($line in $output) {
  
    if ( $line.contains("ERR")) {
        Throw "ERROR IN COMMAND: $line"
    }
}
}
catch {
    Add-Content -Path $ErrLogFile -Value $("CALL [" + (LogFormat) + "] " + "`n" + $_.Exception.Message)
    $port.Close()
    Throw "ERROR FOUND $line"

}
$Port.WriteLine("AT+CHUP;$Syntax")
$port.Close()
