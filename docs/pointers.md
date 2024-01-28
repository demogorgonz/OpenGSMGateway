# Linux

```bash
sudo chmod -R 755 ~/powershell
chmod +x ~/powershell/pwsh

sudo usermod -a -G tty YourUsername
sudo usermod -a -G dialout YourUsername
```

# Windows

```powershell
choco install nssm -y
$exe = (Get-Command pwsh.exe).Source
$name = 'OGG Server'
$file = "$PWD\server.ps1"
$arg = "-ExecutionPolicy Bypass -NoProfile -Command `"$($file)`""
nssm install $name $exe $arg
nssm set $name AppDirectory $PWD
nssm start $name
```
