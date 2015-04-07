<#
 # Author: Andrew Sullivan
 # Reference: http://practical-admin.com/blog/powershell-recursively-show-group-membership-for-an-active-directory-object/
 #
#>

function Get-GroupsForObject {
    [cmdletbinding()]
    param(
        [string]$Object = "", 
        [int]$Level = 0
    )
 
    $indent = "-" * $Level
 
    $d = Get-ADObject -Identity $Object -Properties SamAccountName
 
    if ($Level -eq 0) {
        Write-Host "$indent# $($d.SamAccountName)"
    }
 
    if ($d.ObjectClass -eq "user" -and $Level -eq 0) {
        $e = Get-ADUser -Identity $d.DistinguishedName -Properties MemberOf
 
    } elseif ($d.ObjectClass -eq "group") {
        if ($Level -gt 0) {
            Write-Host "$indent-> $($d.SamAccountName)"
        }
 
        $e = Get-ADGroup -Identity $d.DistinguishedName -Properties MemberOf
 
    }
 
    $e.MemberOf | Sort-Object | %{
        # prevent a loop if the group is a member of itself
        if ( $_ -ne $e.DistinguishedName ) {
            Get-GroupsForObject -Object $_  -Level($Level + 1)
        }
    }
}