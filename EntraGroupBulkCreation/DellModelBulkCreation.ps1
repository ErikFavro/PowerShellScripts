#Create 4 columns in CSV DisplayName	Description	MailNickname	MemberShipRule
#DisplayName: Model of computer in lowercase and no spaces: latitude3420
#Description: Used in group naming, keep capital with spaces: Latitude 3420
#MailNickname: Same as display name, lowercase with no spaces: latitude3420
#MemberShipRule: Same as description: Latitude 3420

Install-Module AzureADPreview -AllowClobber -Confirm:$false
Import-Module AzureADPreview
Connect-AzureAD

$Manufacturer = "Dell"
$ModelGroup = "device.dell."
$GroupType = ".dynamic"
$DescriptionType = "dynamic group"

$DellModelList = Import-Csv "C:\Temp\DellModelFullList.csv"

foreach ($CurrentModel in $DellModelList){ 
    $DisplayName = $ModelGroup + ($CurrentModel).DisplayName + $GroupType
    $MembershipRule = '(device.deviceModel -eq ' + '"' + ($CurrentModel).MembershipRule + "`")"
    $Description = $Manufacturer + ' ' + $CurrentModel.Description + ' ' + $DescriptionType
    New-AzureADMSGroup -DisplayName $DisplayName -Description $Description -MailEnabled $false -SecurityEnabled $true -MailNickname $CurrentModel.MailNickname -GroupTypes "DynamicMembership" -MembershipRule $MembershipRule -MembershipRuleProcessingState "On" -Verbose
}