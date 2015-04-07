<#
 # Author: Andrew Sullivan
 # Reference: http://practical-admin.com/blog/netapp-powershell-toolkit-101-managing-volumes/
 #
#>

function Get-NcVolQosPolicyGroup {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [String]$Name
        ,
 
        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias("Vserver")]
        [String]$VserverContext
    )
    process {
        Get-NcVol -Name $Name -VserverContext $VserverContext | Select-Object `
          Name,@{N="Policy Group Name"; E={ $_.VolumeQosAttributes.PolicyGroupName }}
 
    }
}