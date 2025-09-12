$UpdateCollections = Import-Csv -Path "C:\Temp\CollectionWithQuery.csv"
$OutputFile = "C:\Temp\UpdatedQueryResults.csv"
$Results = @()
$ObjectResults = @()

foreach ($ProcessColelction in $UpdateCollections){

    $ObjectResults = [PSCustomObject]@{
        "CollectionName"  = $ProcessColelction.CollectionName
        "CollectionID"    = $ProcessColelction.CollectionID
        "RuleName"        = ""
        "QueryExpression" = ""
    }

    $ObjectResults.QueryExpression = (Get-CMDeviceCollectionQueryMembershipRule -CollectionId $ProcessColelction.CollectionID).QueryExpression

    $Results += $ObjectResults
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation