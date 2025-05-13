param(
    [string]$number = '',
    [string]$message = ''
)

$ErrorActionPreference = "Stop"

cd $PSScriptRoot
. "$PSScriptRoot\init.ps1"
. "$PSScriptRoot\config.ps1"

if ($UTF) {
    . "$PSScriptRoot\ConvertTo-HexString.ps1"
    $numberHEX = $number | ConvertTo-HexString -Encoding BigEndianUnicode -Delimiter ''
    $messageHEX = $message | ConvertTo-HexString -Encoding BigEndianUnicode -Delimiter ''
}

# Get correct line ending
if ($Model -eq "A6PRO") {
    $Syntax = " `r"
}
elseif ($Model -eq "SIM800") {
    $Syntax = "`r"
}
elseif ($Model -eq "A7670E") {
    $Syntax = "`r`n"
}

# Select serial port
Get-Port

try {
    $port.Open()

    # Set text mode
    $port.Write("AT+CMGF=1$Syntax")
    Start-Sleep -Milliseconds 300
    $null = $port.ReadExisting()

    if ($UTF) {
        $port.Write("AT+CSCS=`"UCS2`"$Syntax")
        Start-Sleep -Milliseconds 300
        $null = $port.ReadExisting()

        $port.Write("AT+CSMP=17,168,0,8$Syntax")
        Start-Sleep -Milliseconds 300
        $null = $port.ReadExisting()

        # Send AT+CMGS with UCS2 phone number
        $port.Write("AT+CMGS=`"$numberHEX`"$Syntax")
        Start-Sleep -Milliseconds 1000

        # Wait for prompt
        $response = ""
        $timeout = [datetime]::Now.AddSeconds(10)
        while ([datetime]::Now -lt $timeout -and $response -notmatch ">") {
            Start-Sleep -Milliseconds 200
            $response += $port.ReadExisting()
        }

        # Send encoded message + Ctrl+Z
        $port.Write($messageHEX)
        Start-Sleep -Milliseconds 300
        $port.Write([char]26)
    } else {
        $port.Write("AT+CMGS=`"$number`"$Syntax")
        Start-Sleep -Milliseconds 1000

        # Wait for prompt
        $response = ""
        $timeout = [datetime]::Now.AddSeconds(10)
        while ([datetime]::Now -lt $timeout -and $response -notmatch ">") {
            Start-Sleep -Milliseconds 200
            $response += $port.ReadExisting()
        }

        if ($response -notmatch ">") {
            throw "❌ ERROR: Modem did not respond with '>' prompt. Response: $response"
        }

        $port.Write($message)
        Start-Sleep -Milliseconds 300
        $port.Write([char]26)
    }

    Start-Sleep -Seconds 5
    $output = $port.ReadExisting()

    if ($output -match "ERROR") {
        throw "❌ Modem error: $output"
    } else {
        Write-Host "✅ SMS sent successfully:"
        Write-Host $output
    }
}
catch {
    Add-Content -Path $ErrLogFile -Value $("SMS [" + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "] " + $_.Exception.Message)
    throw "❌ ERROR: $_"
}
finally {
    $port.Close()
    Start-Sleep -Seconds 1
}
