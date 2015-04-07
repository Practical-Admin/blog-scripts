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