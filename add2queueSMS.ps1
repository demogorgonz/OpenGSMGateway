param(
    [ValidatePattern('^\d+$')]
    [string]$number = '',
    $message
) 
# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

"$number`:$message" | Out-File -Append $SMSfile
