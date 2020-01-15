###To-do: 
#Get an SMTP mail address
#==> Change seconds for final script
#Create scheduled task on server

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information'
    )

    [pscustomobject]@{
        Time = (Get-Date -f g)
        Message = $Message
        Severity = $Severity
    } | Export-Csv -Path "C:\Temp\LogFile.csv" -Append -NoTypeInformation
}

Function Restart-LegacyServers{
    [CMDletBinding()]
    param(
        [Parameter()]
        [system.array]$ImportedVM,

        [Parameter()]
        [System.String]$viServer
    )

    #Creating encrypted credentials for connection
    $User = "legacyreboot"
    $Password = Get-Content "C:\\Restart-LegacyServers\creds.txt" | ConvertTo-SecureString
    $Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $User, $Password

    Try{
    #Connect to VCS server
    Connect-VIServer -Server $viServer -Credential $Creds -ErrorAction Stop
    Write-Log -Message "Connected to $viServer" -Severity Information
    }
    Catch{
            $ErrorMsg = $_.Exception.Message
            Write-Log "Error Connecting to $viServer : $ErrorMsg"
    }

    $VMs = $ImportedVM

    $VMs | ForEach-Object{
        try{
            $CurrentVM = $_
            Restart-VMGuest -VM $CurrentVM -EA "Stop" | Out-Null
            Write-Log "The VM $_ was restarted successfully" -Severity "Information" 
            Start-Sleep -Seconds 10
        }
        catch{
            $ErrorMsg = $_.Exception.Message
            Write-Log "Error Rebooting VM $CurrentVM : $ErrorMsg"
        }
    }
   Disconnect-VIServer -Confirm:$False
}