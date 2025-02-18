# API

## CALL

===  "PowerShell"

    ```powershell
    Invoke-WebRequest -Method GET -Uri 'http://IP:8080/call?number=XXXXXXXXXX'
    ```

=== "curl"

    ```bash

    curl -X GET 'http://IP:8080/call?number=XXXXXXXXXX' 
    ```
___

## Send SMS

===  "PowerShell"

    ```powershell
    Invoke-WebRequest -Method GET http://IP:8080/sms -Body @{number = "XXXXXXXXXX"; message = "Text message here!"}
    ```

=== "curl"

    ```bash

    curl -X GET http://IP:8080/sms -G --data-urlencode "number=XXXXXXXXXX" --data-urlencode "message=Text message here!"
    ```

{% include 'footer.md' %}
