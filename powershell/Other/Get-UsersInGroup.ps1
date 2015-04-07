<#
 # Author: Andrew Sullivan
 # Reference: http://practical-admin.com/blog/powershell-recursively-show-user-membership-in-an-active-directory-group/
 #
#>

function Get-UsersInGroup {
    [cmdletbinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$Object,
        
        [parameter(Mandatory=$false)]
        [int]$Level = 0
    )
    
    $indent = "-" * $Level
 
    $x = Get-ADObject -Identity $Object -Properties SamAccountName
 
    if ($x.ObjectClass -eq "group") {
        Write-Output "$indent# $($x.SamAccountName)"
 
        $y = Get-ADGroup -Identity $Object -Properties Members
 
        $y.Members | %{
            $o = Get-ADObject -Identity $_ -Properties SamAccountName
 
            if ($o.ObjectClass -eq "user") {
                Write-Output "$indent-> $($o.SamAccountName)"
            } elseif ($o.ObjectClass -eq "group") {
                Get-UsersInGroup -Object $o.DistinguishedName -Level ($Level + 1)
            }
        }
    } else {
        Write-Warning "$($Object) is not a group, it is a $($x.ObjectClass)"
    }
}