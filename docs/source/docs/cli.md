# CLI

Call and SMS from CLI.

## Call

```powershell
.\serialCall.ps1 -number 123456789
```

## SMS

```powershell
.\serialSMS.ps1 -number 0123456789 -message 'Hello from OGG!'
```

___

# CLI add2queue

If you are running OGG as service, you can add actions to queue.

## add2queue Call

```powershell
.\add2queueCALL.ps1 -number 123456789
```

## add2queue SMS

```powershell
.\add2queueSMS.ps1 -number 0123456789 -message 'Hello from OGG!'
```