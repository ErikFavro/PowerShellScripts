#Gather computer name
$ComputerToAudit = Read-Host -Prompt "Please enter a computer name"

#Gather profiles to audit
$ExcludeUsers = @("Public", "*Default*", "All Users", "*Administrator*", "Guest", "ADMINI~1", "*WWU*")
$UserList = @(Get-ChildItem "\\$ComputerToAudit\C$\Users" | Select Name)
$localUserList = @(Invoke-Command -ComputerName "$ComputerToAudit" -ScriptBlock {Get-LocalUser} | Select Name)

ForEach ($CheckExclude in $ExcludeUsers){
    foreach ($CurrentUser in $UserList.Name){
        If ($CurrentUser -like $CheckExclude){
            $UserList = $UserList -notmatch $CurrentUser
        }
    }
}

ForEach ($CurrentUserAudit in $localUserList){
    $UserList = $UserList -notmatch $CurrentUserAudit
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