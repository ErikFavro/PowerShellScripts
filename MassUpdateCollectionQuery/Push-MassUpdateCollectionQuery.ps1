$GatheredCollections = Import-Csv -Path "C:\Temp\CollectionGather.csv"
$OutputFile = "C:\Temp\CollectionWithQuery.csv"
$Results = @()
$ObjectResults = @()

foreach ($ProcessColelction in $GatheredCollections){

    $ObjectResults = [PSCustomObject]@{
        "CollectionName"  = $ProcessColelction.CollectionName
        "CollectionID"    = $ProcessColelction.CollectionID
        "QueryExpression" = ""
    }

    $ObjectResults.QueryExpression = (Get-CMDeviceCollectionQueryMembershipRule -CollectionId $ProcessColelction.CollectionID).QueryExpression

    $Results += $ObjectResults
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation