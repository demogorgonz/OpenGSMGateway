# Installation

## Dependencies
Install pode module to run server.
===  "Chocolatey"

    ```powershell

    choco install pode
    ```

=== "PowerShell Gallery"

    ```powershell
    Install-Module -Name Pode
    ```


___


## Obtaining code

===  "GIT"

    ```powershell

    git clone https://github.com/demogorgonz/OpenGSMGateway.git
    ```

=== "ZIP"

    ```powershell
    Invoke-WebRequest https://codeload.github.com/demogorgonz/OpenGSMGateway/zip/refs/heads/main -OutFile OpenGSMGateway.zip
    Expand-Archive .\OpenGSMGateway.zip

    ```
___


## Troubleshooting

Make sure to check Troubleshooting section for configuration of [USB power management](troubleshoot.md)

{% include 'footer.md' %}