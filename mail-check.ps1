if (-not (Get-Module Mailozaurr -ListAvailable)) {
    Install-Module Mailozaurr -AllowClobber -Force
}

Import-Module -Name Mailozaurr -Force

# Enter PSScriptRoot
cd $PSScriptRoot

# Define queue file
$file = "./queue/call.txt"
if (!(Test-Path $file)) {
    New-Item -itemType File -Name $file -Force
}

# Import config
. "$PSScriptRoot\config.ps1"

# IMAP client
if ($SkipCertificateCheck -eq 'true') { [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true } }


$Client = Connect-IMAP -Server $Server -Password $Password -UserName $Account -Port 993 -Options Auto
Get-IMAPFolder -FolderAccess ReadWrite -Client $Client -Verbose

$inbox = $Client.data.Inbox.Search("All")
# Moving processed emails to preexisting Junk folder
$MoveToFolder = $Client.data.GetFolder("$MoveMailToFolder")

#loop through email UID-s and retrieve messages
function Get-Headers {
    foreach ($id in $inbox.UniqueIds) {
        $Client.data.Inbox.GetMessage($id)
        $Client.Data.Inbox.GetMessage($id).from.address
        $Client.Data.Inbox.GetMessage($id).to.address
        $Client.Data.Inbox.MoveTo($id, $MoveToFolder)
    }
}

# Import contacts
. "$PSScriptRoot\contacts.ps1"



# Match email to phone numbers and write to file
foreach ($line in $(Get-Headers | Select-String -Pattern [a-zA-Z0-9_.-]+@$domain | foreach { $_.Matches.Value }) | Get-Unique ) {
    if ($contacts.ContainsKey($line)) {
        $phone = $contacts[$line]
        $phone | Out-File -Append $file -Force
    }
}

# Disconnect from the IMAP server.
Disconnect-IMAP -Client $Client
