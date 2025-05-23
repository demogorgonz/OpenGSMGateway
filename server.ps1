# Enter PSScriptRoot
cd $PSScriptRoot

Start-PodeServer -Threads 4 -RootPath "$PWD" {

    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http 
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging -Levels @("Error", "Warning")
    
    Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
        Write-PodeViewResponse -Path 'index'
    }
    
    Add-PodeRoute -Method Get -Path '/call' -ScriptBlock {
        & "$PSScriptRoot\add2queueCALL.ps1" -number $WebEvent.Query['number']
    }
 
    Add-PodeRoute -Method Get -Path '/sms' -ScriptBlock {
        $parameters = $WebEvent.Query
        Write-Output $parameters
        $result = (& "$PSScriptRoot\add2queueSMS.ps1" @parameters)
    }

    Add-PodeSchedule -Name 'startup-remove-lock' -Cron '*/1 * * * *' -Limit 1 -ScriptBlock {
        pwsh -Command "Remove-Item `"$using:PWD\Instance.Lock`" -Force"
    }

    Add-PodeSchedule -Name 'mail-check' -Cron '*/1 * * * *' -ScriptBlock {
        pwsh -File "$using:PWD/mail-check.ps1"
    }

    Add-PodeSchedule -Name 'task' -Cron '*/1 * * * *' -ScriptBlock {
        pwsh -File "$using:PWD/task.ps1"
    }

}
