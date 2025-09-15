$UpdateCollections = Import-Csv -Path "C:\Temp\CollectionWithQuery.csv"
$OutputFile = "C:\Temp\UpdatedQueryResults.csv"
$Results = @()
$ObjectResults = @()

foreach ($ProcessCollection in $UpdateCollections){

    Remove-CMDeviceCollectionQueryMembershipRule -CollectionId $ProcessCollection.CollectionID -RuleName $ProcessCollection.RuleName -Force -Confirm:$false
    Add-CMDeviceCollectionQueryMembershipRule -CollectionId $ProcessCollection.CollectionID -RuleName $ProcessCollection.RuleName -QueryExpression $ProcessCollection.QueryExpression

}

