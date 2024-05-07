$PnpDevice = $(Get-CimInstance Win32_PnPEntity | where {$_.Name -like 'USB Serial Port*' } | Select-Object -Property InstanceId)
echo $PnpDevice.InstanceId
FTDIBUS\VID_0403+PID_6001+6&3365FBAF&0&11\0000
Disable-PnpDevice -InstanceId $PnpDevice.InstanceId -Confirm:$false
Enable-PnpDevice -InstanceId $PnpDevice.InstanceId -Confirm:$false