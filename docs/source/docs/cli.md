# CLI

### Call

```powershell
.\serialCall.ps1 -number 123456789
```

### Send SMS

```powershell
.\serialSMS.ps1 -number 0123456789 -message 'Hello from OGG!'
```
### Read SMS & Delete old

```powershell
.\serialReadSMS.ps1
```
___

## CLI add2queue

If running OGG as service, you can add actions to queue.

### add2queue Call

```powershell
.\add2queueCALL.ps1 -number 123456789
```

### add2queue SMS

```powershell
.\add2queueSMS.ps1 -number 0123456789 -message 'Hello from OGG!'
```