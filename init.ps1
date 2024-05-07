# Enter PSScriptRoot
cd $PSScriptRoot

# Define and create queue files
$Callfile = ".\queue\call.txt"
$SMSfile  = ".\queue\sms.txt"

if (!(Test-Path $CALLfile)) {
    New-Item -itemType File -Name $CALLfile -Force
}
if (!(Test-Path $SMSfile)) {
    New-Item -itemType File -Name $SMSfile -Force
}

# Define and create logs folder

$LogsFolder = ".\logs"
if (!(Test-Path $LogsFolder)) {
    New-Item -Type Directory -Name $LogsFolder -Force
}

# Date Formats
function logFileFormat() { 
    $(Get-Date -Format "dd.MM.yyyy")
}
function LogFormat() { 
    $( Get-Date -Format "HH:mm:ss dd.MM.yyyy" )
}

# Error file
$ErrLogFile = ".\$LogsFolder\error-$(logFileFormat).log"


# Clean empty lines from queue 
function CALLCleanEmptyLines() { 
    (Get-Content $Callfile) | ? { $_ }  | Set-Content $Callfile
}
function SMSCleanEmptyLines() { 
    (Get-Content $SMSfile) | ? { $_ }  | Set-Content $SMSfile
}

# Lock

$LockFilePath =  ".\Instance.Lock"

$Locked = $null -ne (Get-Item -Path $LockFilePath -EA 0)