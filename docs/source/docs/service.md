# Running OGG as service

## Windows

!!! info "Make sure to run following code block as Administrator and from root directory of project."

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

___

## Linux

!!! info "Make sure to run following code block from root directory of project."

```bash
echo "[Unit]
Description=OGG Server
After=network.target

[Service]
ExecStart=/usr/bin/pwsh -c "$PWD/server.ps1" -nop -ep Bypass
Restart=always
User=root
Group=root
WorkingDirectory="$PWD"

[Install]
WantedBy=multi-user.target
Alias=ogg-server.service" >> /etc/systemd/system/ogg-server.service
# Reload daemon, start service, enable startup
systemctl daemon-reload
systemctl start ogg-server
systemctl enable ogg-server
```

___

{% include 'footer.md' %}