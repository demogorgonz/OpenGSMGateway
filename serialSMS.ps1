param(
    [string]$number = '',
    [string]$message = ''
) 

# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

# UTF

if ($UTF) { 
    . "$PSScriptRoot\ConvertTo-HexString.ps1" 
    $numberHEX = $($number | ConvertTo-HexString -Encoding BigEndianUnicode -Delimiter '')
    $messageHEX = $($message | ConvertTo-HexString -Encoding BigEndianUnicode -Delimiter '')
}

# Select USB port
Get-Port

try {
$port.open()
$port.Write("AT+CMGF=1`r")
Start-Sleep 5
$port.ReadLine()
If ($UTF) {
    $port.Write("AT+CSCS=`"UCS2`"`r")
    $port.ReadLine()
    Start-Sleep 1
    $port.Write("AT+CSMP=17,168,0,8`r")
    $port.ReadLine()
    Start-Sleep 1
    $port.Write("AT+CMGS=`"$numberHEX`"`r")
    Start-Sleep 1
    $port.Write("$messageHEX`r")
    $port.ReadLine()

}
else {
    $port.Write("AT+CMGS=`"$number`"`r")
    Start-Sleep 1
    $port.ReadLine()
    $port.Write("$message`r")
    $port.ReadLine()
}
$z = new-Object String(26, 1)
$port.Write("`r")
$port.Write($z)
Start-Sleep 1
$output = $port.ReadExisting()
ForEach ($line in $output) {
  
    if ( $line.contains("ERR")) {
        Throw "ERROR IN COMMAND: $line"
    }
}
}
catch {
    Add-Content -Path $ErrLogFile -Value $("SMS [" + (LogFormat) + "] " + "`n" + $_.Exception.Message)
    $port.Close()
    Throw "ERROR FOUND $line"

}
$port.Close()
Start-Sleep 1
