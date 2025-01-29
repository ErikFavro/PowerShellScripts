#Gather faulty scheduled tasks
$SchedTasks = Get-ScheduledTask | Where-Object { $_.TaskPath -like "*Microsoft*Windows*EnterpriseMgmt\*" } | Select-Object -ExpandProperty TaskPath -Unique | Where-Object { $_ -like "*-*-*" } | Split-Path -Leaf

#Remove Intune Enrollment scheduled tasks
foreach ($TaskToClean in $SchedTasks){
    Get-ScheduledTask | Where-Object {$_.TaskPath -match $TaskToClean} | Unregister-ScheduledTask -Confirm:$false
}

#Clean registry 
$RegistryKeys = Get-ChildItem HKLM:\Software\Microsoft\Enrollments\* | ForEach-Object { Get-ItemProperty $_.PSPath }| Where-Object { $_ -like "*fooUser*" } | Select PSPath

Foreach ($Key in $RegistryKeys){
    Remove-Item $RegistryKeys.PSPath -Recurse -Force
}

#Nuke enrollment cert for MDM
Get-ChildItem 'Cert:\LocalMachine\My\' | ? Issuer -EQ "CN=Microsoft Intune MDM Device CA" | % {
     Write-Host " - Removing Intune certificate $($_.DnsNameList.Unicode)"
     Remove-Item $_.PSPath
}

#Restart ConfigMgr
Restart-Service -Name "ccmexec" -Force -ErrorAction Stop