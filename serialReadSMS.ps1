$ErrorActionPreference = "Stop"
# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

# Import config
. "$PSScriptRoot\config.ps1"

# Select USB port depending on OS
Get-Port

# Ping
& ".\ping.ps1"

$port.open()
$port.Write("AT+CMGF=1`r")
Start-Sleep 5
$port.Write("AT+CMGL=`"REC UNREAD`" `r")
Start-Sleep 1
$output = $port.ReadExisting()
$output | Out-File -Append $ReceivedSMSFileLog 
$ParseOutput = Get-Content $ReceivedSMSFileLog | Select-String -Pattern 'CMGL' -Context 0,2 | Select -Skip 1
$ParseOutput -replace "`n","" -replace "`r","" -match "\d" -replace '.+?(UNREAD",")','' -replace '"','' -replace ',,',' ' -replace ',',' ' 
$port.Write("AT+CMGDA=`"DEL ALL`" `r")
$port.Close()
Start-Sleep 5
