﻿$ComputerToAudit = Read-Host -Prompt "Please enter a computer name"

#omit not domained users, anything with default in it?
$ExcludeUsers = @("Public", "Default", "All Users", "Default User", "Administrator", "Default.migrated", "DefaultAccount", "Guest", "ADMINI~1")
$UserList = @(Get-ChildItem "\\$ComputerToAudit\C$\Users" | Select Name)
$localUserList = @(Invoke-Command -ComputerName "$ComputerToAudit" -ScriptBlock {Get-LocalUser} | Select Name)

ForEach ($CheckExclude in $ExcludeUsers){
    foreach ($CurrentUser in $UserList.Name){
        If ($checkExclude -like $CurrentUser){
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