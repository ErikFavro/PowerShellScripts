$GatheredCollections = Import-Csv -Path "C:\Temp\CollectionGather.csv"
$OutputFile = "C:\Temp\CollectionWithQuery.csv"
$Results = @()
$ObjectResults = @()

foreach ($ProcessCollection in $GatheredCollections){

    $CurrentValue = @()
    $CurrentValue = Get-CMDeviceCollectionQueryMembershipRule -CollectionId $ProcessCollection.CollectionID

    foreach ($CurrentQuery in $CurrentValue){
        
        $ObjectResults = [PSCustomObject]@{
            "CollectionName"  = $ProcessCollection.CollectionName
            "CollectionID"    = $ProcessCollection.CollectionID
            "RuleName"        = ""
            "QueryExpression" = ""
            "QueryID"          = ""
        }
        
        If ($CurrentQuery.QueryExpression -like "*UNIV.DIR.WWU.EDU/MANAGED*"){
            $ObjectResults.QueryExpression = $CurrentQuery.QueryExpression
            $ObjectResults.RuleName = $CurrentQuery.RuleName
            $ObjectResults.QueryID = $CurrentQuery.QueryID
            $Results += $ObjectResults
        }
    }
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation