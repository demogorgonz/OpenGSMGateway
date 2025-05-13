param([string]$number = '') 

# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

# Model configuration
if ($Model -eq "A6PRO") {
    $Syntax = " `r"
}
elseif ($Model -eq "SIM800") {
    $Syntax = ""
}
elseif ($Model -eq "A7670E") {
    $Syntax = "`r`n"
}

# Select USB port
Get-Port

try {
    $port.Open()
    $port.WriteLine("ATD$number;$Syntax")
    Start-Sleep $CallDuration
    $output = $port.ReadExisting()

    foreach ($line in $output) {
        if ($line.Contains("ERR")) {
            Throw "ERROR IN COMMAND: $line"
        }
    }
}
catch {
    Add-Content -Path $ErrLogFile -Value $("CALL [" + (LogFormat) + "] " + "`n" + $_.Exception.Message)
    $port.Close()
    Throw "ERROR FOUND $line"
}

$port.WriteLine("AT+CHUP$Syntax")
$port.Close()
