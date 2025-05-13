$ErrorActionPreference = "Stop"

# Navigate to script root directory
cd $PSScriptRoot
. "$PSScriptRoot\init.ps1"
. "$PSScriptRoot\config.ps1"

# Select serial port
Get-Port

# Optional: Ping modem (optional check)
& ".\ping.ps1"

# Configure model-specific line ending
If ($Model -eq "A6PRO") {
    $Syntax = "`r"
}
ElseIf ($Model -eq "SIM800") {
    $Syntax = "`r" # SIM800 typically uses no line ending
}
ElseIf ($Model -eq "A7670E") {
    $Syntax = "`r`n"
}
Else {
    $Syntax = "`r`n"  # Default fallback
}

# Open serial port
$port.Open()

# Set text mode (works for both SIM800 and A7)
$port.Write("AT+CMGF=1$Syntax")
Start-Sleep -Milliseconds 300

# Optional: set UCS2 character set (works for both SIM800 and A7)
$port.Write("AT+CSCS=`"UCS2`"$Syntax")
Start-Sleep -Milliseconds 300

# Read all stored messages
$port.Write("AT+CMGL=`"REC UNREAD`"$Syntax")
Start-Sleep -Milliseconds 1000

# Capture modem response
$output = $port.ReadExisting()

# Optionally save raw output
#$output | Out-File -Append $ReceivedSMSFileLog

# Split response into lines
$lines = $output -split "`r`n"

# Container for decoded messages
$decodedMessages = @()

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -like "+CMGL:*") {
        $header = $lines[$i].Trim()

        # Extract phone number from header and decode UCS2 if needed
        $phoneNumber = ""
        if ($header -match '^\+CMGL: \d+,"[^"]+","([^"]+)"') {
            $encodedNumber = $matches[1]
            if ($encodedNumber -match '^[0-9A-Fa-f]{4,}$') {
                $hexPairs = $encodedNumber -split '(.{4})' | Where-Object { $_ -ne '' }
                $byteArray = @()
                foreach ($hex in $hexPairs) {
                    $byteArray += [byte]("0x" + $hex.Substring(0,2))
                    $byteArray += [byte]("0x" + $hex.Substring(2,2))
                }
                $phoneNumber = [System.Text.Encoding]::BigEndianUnicode.GetString($byteArray)
            } else {
                $phoneNumber = $encodedNumber
            }
        }

        # Extract date/time
        $dateTime = ""
        if ($header -match '\d{2}/\d{2}/\d{2},\d{2}:\d{2}:\d{2}') {
            $dateTime = $matches[0]
        }

        # Get the encoded message content (next line)
        $encoded = $lines[$i + 1].Trim()

        if ($encoded -ne "") {
            if ($Model -eq "A7670E" -or $Model -eq "SIM800") {
                # Decode UCS2 message
                $hexPairs = $encoded -split '(.{4})' | Where-Object { $_ -ne '' }
                $byteArray = @()
                foreach ($hex in $hexPairs) {
                    $byteArray += [byte]("0x" + $hex.Substring(0,2))
                    $byteArray += [byte]("0x" + $hex.Substring(2,2))
                }
                $decoded = [System.Text.Encoding]::BigEndianUnicode.GetString($byteArray)
                $decodedMessages += "📩 [$dateTime] From: $phoneNumber - $decoded"
            }
            elseif ($Model -eq "A7") {
                # Already readable
                $decodedMessages += "📩 [$dateTime] From: $phoneNumber - $encoded"
            }
        }
    }
}

# Output decoded messages
$decodedMessages | ForEach-Object { Write-Output $_ }

# Save to log
$decodedMessages | Out-File -Append -FilePath $ReceivedSMSFileLog -Encoding UTF8

# Delete Messages
$port.Write("AT+CMGDA=`"DEL ALL`"$Syntax")
Start-Sleep -Milliseconds 500
# Close port
$port.Close()
Start-Sleep 5
