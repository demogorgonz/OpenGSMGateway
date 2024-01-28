param(
    [ValidatePattern('^\d+$')]
    [string]$number = '',
    $message
) 
# Enter PSScriptRoot
cd $PSScriptRoot

# Define queue file
$SMSfile = ".\queue\sms.txt"
if (!(Test-Path $SMSfile)) {
    New-Item -itemType File -Name $SMSfile -Force
}

"$number`:$message" | Out-File -Append $SMSfile
