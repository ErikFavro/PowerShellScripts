# CollectionGather.csv should have 2 headers, CollectionName and CollectionID
# The name is required but not used, more cosmetic so we can see what we're altering
# Example
# CollectionName	            CollectionID
# AASAC Workstations	        WWU00403
# AASAC Workstations - Kiosk	WWU00C12
# AASAC Workstations - Tech	    WWU00AB9


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