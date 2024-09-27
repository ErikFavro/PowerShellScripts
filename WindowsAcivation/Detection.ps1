$LicensedStatusofOS = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select LicenseStatus
$OSProductDescription = Get-CimInstance SoftwareLicensingService | Select OA3xOriginalProductKeyDescription


If (($LicensedStatusofOS -ne '1') -and (($OSProductDescription -eq '[4.0] Core OEM:DM') -or ($OSProductDescription -eq $null))){
    
    Exit 1
}
else
{
    Exit 0
}
