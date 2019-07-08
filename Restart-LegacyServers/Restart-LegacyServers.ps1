#requires -Module Restart-LegacyServers

param(
    [Parameter(Mandatory=$True)]
    [ValidateSet("2kSvr","Dev2k3Svr","Test2k3Svr","TestGrp","ProdLegacy")]
    $ServerSet,

    [Parameter(Mandatory=$True)]
    [ValidateSet("LONVCS201", "CAMVCS201")]
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
$GroupSet = @("DEVAPP201",
"DEVHWF101",
"DEVPBC101",
"DEVSQL103",
"TSTAPP01",
"TSTAPP21",
"TST-BLA-103",
"TSTDOT102",
"TSTHWF102",
"TSTWEB101",
"TSTWEB21",
"TSTXML02")
} 
elseif($ServerSet -eq "Dev2k3Svr"){
$GroupSet = @("DEV-BLA-112",
"DEVCTX110",
"DEVGLB02",
"DEVHWF102",
"DEVMIP02",
"DEVPCX101",
"DEVPHM101",
"DEVPHM102",
"DEVSPS202",
"DEVSQL105"
"DEVSPS203",
"DEVSQL101")
} 
elseIf($ServerSet -eq "Test2k3Svr"){
$GroupSet = @("TST-BLA-112",
"TSTCTX110",
"TSTCTX111",
"TSTDOT104-v",
"TSTDOT301",
"TSTDOT302",
"TSTGLB02",
"TSTMAP101",
"TSTMIP02",
"TSTPCX102",
"TSTPDF101",
"TSTPDF202",
"TSTPHM101",
"TSTPHM102",
"TSTPHS101",
"TSTSPS101",
"TSTSQL105",
"TSTSSP101",
"TSTSUN102")
}
elseif ($ServerSet -eq "TestGrp"){
$GroupSet = @("DEVAPP201",
"DEVHWF101",
"TSTMAP101")
}
elseif ($ServerSet -eq "ProdLegacy"){
$GroupSet = @("CAMAMS102",
"CAMAPP01",
"CAMBAT102",
"CAMBAT301",
"CAM-BLA-112",
"CAM-BLA-203",
"CAM-BLA-205",
"CAMCMS101",
"CAMCTX213",
"CAMCTX214",
"CAMCTX215",
"CAMDOT101",
"CAMDOT104",
"CAMDTM102",
"CAMHWF102",
"CAMKMS101",
"CAMKPC101",
"CAMMIP01",
"CAMPAN101",
"CAMPDF101",
"CAMPKT201",
"CAMPROD103",
"CAMSAM102",
"CAMSI101",
"CAMSPF101",
"CAMTDR101",
"CAMTGSQ",
"CAMWEB01",
"CAMWSS101",
"CAMWUP102",
"COPSUN201",
"LDQ-DMZ",
"PPESCS101",
"STGCTX101",
"UK-CAMB-006",
"WASSAM102",
"CAMSQL208",
"LONGLB01")
}

Restart-LegacyServers -ImportedVM $GroupSet -viServer $viServer | Out-Null

If($ServerSet -eq "2kSvr"){
Send-MailMessage -To "SYSUKInfrastructureSupport@paconsulting.com" -From "LegacyReboot@paconsulting.com" -Subject "Server 2000/2003 Reboot Report (Dev/Test)" -SmtpServer "SMTPSERVER" -Attachments "C:\Temp\LogFile.csv"
Remove-Item "C:\Temp\LogFile.csv"
}
ElseIf($ServerSet -eq "ProdLegacy"){
Send-MailMessage -To "SYSUKInfrastructureSupport@paconsulting.com" -From "LegacyReboot@paconsulting.com" -Subject "Server 2000/2003 Reboot Report (Prod)" -SmtpServer "SMTPSERVER" -Attachments "C:\Temp\LogFile.csv"
Remove-Item "C:\Temp\LogFile.csv"
}