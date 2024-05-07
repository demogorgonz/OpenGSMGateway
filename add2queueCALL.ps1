param(
    [ValidatePattern('^\d+$')]
    [string]$number = ''
) 
# Enter PSScriptRoot
cd $PSScriptRoot

# Init
. "$PSScriptRoot\init.ps1"

$number | Out-File -Append $CALLfile
