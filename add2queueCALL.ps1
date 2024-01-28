param(
    [ValidatePattern('^\d+$')]
    [string]$number = ''
) 
# Enter PSScriptRoot
cd $PSScriptRoot

# Define queue file
$CALLfile = ".\queue\call.txt"
if (!(Test-Path $CALLfile)) {
    New-Item -itemType File -Name $CALLfile -Force
}

$number | Out-File -Append $CALLfile
