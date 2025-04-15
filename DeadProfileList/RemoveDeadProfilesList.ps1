#omit not domained users, anything with default in it?
$ExcludeUsers = ("Public", "Default", "All Users", "Default User", "Administrator")
$UserList = @(Get-ChildItem "\\ATH-8t5J6y1\C$\Users" | Select Name)

ForEach ($CheckExclude in $ExcludeUsers){
    foreach ($CurrentUser in $UserList.Name){
        If ($checkExclude -eq $CurrentUser){
            $UserList = $UserList -notmatch $CurrentUser
        }
    }
}

ForEach ($User in $UserList){
    try {
        $TestUser = $null
        $TestUser = Get-ADUser -Identity $User.Name
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
        Write-Host $user.name "does not exist in domain."
        $UserExists = $false
    }
}