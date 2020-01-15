#requires -Module Restart-LegacyServers

param(
    [Parameter(Mandatory=$True)]
    [ValidateSet("2kSvr","Dev2k3Svr","Test2k3Svr","TestGrp","ProdLegacy")]
    $ServerSet,

    [Parameter(Mandatory=$True)]
    [ValidateSet("VCSSRV101", "VCSSRV102")]
    [System.String]$viServer
)

#Controller script for Restart-LegacyServers.psm1
Try{
Import-Module "C:\Program Files\WindowsPowerShell\Modules\Restart-LegacyServers" -ErrorAction "Stop"
}
Catch{
    $ErrorMsg = $_.Exception.Message
    Write-Verbose "Failed to load module`n$ErrorMsg"
}

If ($ServerSet -eq "2kSvr"){
$GroupSet = @("TSTSRV101",
"TSTSRV102",
"TSTSRV103",
"DEVSRV104",
"DEVSRV105")
} 
elseif($ServerSet -eq "Dev2k3Svr"){
$GroupSet = @("DEVSRV201",
"DEVSRV202",
"DEVSRV203",
"DEVSRV204",
"DEVSRV205")
} 
elseIf($ServerSet -eq "Test2k3Svr"){
$GroupSet = @("TSTSRV201",
"TSTSRV202",
"TSTSRV203",
"TSTSRV204",
"TSTSRV205")
}

elseif ($ServerSet -eq "ProdLegacy"){
$GroupSet = @("PRDSRV101",
"PRDSRV102",
"PRDSRV103",
"PRDSRV104",
"PRDSRV105",
"PRDSRV201",
"PRDSRV202",
"PRDSRV203",
"PRDSRV204",
"PRDSRV205")
}

Restart-LegacyServers -ImportedVM $GroupSet -viServer $viServer | Out-Null

If($ServerSet -eq "2kSvr"){
Send-MailMessage -To "SysAdmin@company.comm" -From "LegacyReboot@paconsulting.com" -Subject "Server 2000/2003 Reboot Report (Dev/Test)" -SmtpServer "SMTPSERVER" -Attachments "C:\Temp\LogFile.csv"
Remove-Item "C:\Temp\LogFile.csv"
}
ElseIf($ServerSet -eq "ProdLegacy"){
Send-MailMessage -To "SysAdmin@company.com" -From "LegacyReboot@company.com" -Subject "Server 2000/2003 Reboot Report (Prod)" -SmtpServer "SMTPSERVER" -Attachments "C:\Temp\LogFile.csv"
Remove-Item "C:\Temp\LogFile.csv"
}