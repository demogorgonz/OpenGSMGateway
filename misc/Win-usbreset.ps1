$PnpDevice = $(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } | Select-Object -Property DeviceID)
echo $PnpDevice.DeviceID
Disable-PnpDevice -InstanceId $PnpDevice.DeviceID -Confirm:$false
Enable-PnpDevice -InstanceId $PnpDevice.DeviceID -Confirm:$false