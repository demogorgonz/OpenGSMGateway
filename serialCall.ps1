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

# Select USB port
Get-Port

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
