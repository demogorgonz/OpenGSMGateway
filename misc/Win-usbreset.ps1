$PnpDevice = $(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } | Select-Object -Property InstanceId)
echo $PnpDevice.InstanceId
Disable-PnpDevice -InstanceId $PnpDevice.InstanceId -Confirm:$false
Enable-PnpDevice -InstanceId $PnpDevice.InstanceId -Confirm:$false