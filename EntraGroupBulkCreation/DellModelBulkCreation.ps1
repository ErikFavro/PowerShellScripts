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