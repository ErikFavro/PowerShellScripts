$GatheredCollections = Import-Csv -Path "C:\Temp\CollectionGather.csv"
$OutputFile = "C:\Temp\CollectionWithQuery.csv"
$Results = @()
$ObjectResults = @()

foreach ($ProcessColelction in $GatheredCollections){

    $ObjectResults = [PSCustomObject]@{
        "CollectionName"  = $ProcessColelction.CollectionName
        "CollectionID"    = $ProcessColelction.CollectionID
        "RuleName"        = ""
        "QueryExpression" = ""
    }

    $CurrentValue = @()
    $CurrentValue = Get-CMDeviceCollectionQueryMembershipRule -CollectionId $ProcessColelction.CollectionID | Select QueryExpression, RuleName
    $ObjectResults.QueryExpression = $CurrentValue.QueryExpression
    $ObjectResults.RuleName = $CurrentValue.RuleName

    $Results += $ObjectResults
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation