function Remove-NcVolQosPolicyGroup {
    [CmdletBinding(SupportsShouldProcess=$true)]
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
        # verify the volume
        $volume = Get-NcVol -Name $Name -VserverContext $VserverContext
 
        if (!$volume) {
            throw "Unable to find volume with name $($Name)"
        }
 
        # a query for the update action
        $query = Get-NcVol -Template
 
        # initialize the search for the volume we want
        Initialize-NcObjectProperty -Object $query -Name VolumeIdAttributes
 
        # specify we want to operate on the provided volume
        $query.VolumeIdAttributes.Name = $volume.Name
 
        # initialize the update template
        $attributes = Get-NcVol -Template
 
        # initialize the QoS attr property
        Initialize-NcObjectProperty -Object $attributes -Name VolumeQosAttributes
 
        $attributes.VolumeQosAttributes.PolicyGroupName = "none"
 
        # update the volume
        if ($PSCmdlet.ShouldProcess(
            $volume, 
            "Remove policy group.")
        ) {
            Update-NcVol -Query $query -Attributes $attributes | Out-Null
        }
 
        $volume | Get-NcVolQosPolicyGroup
    }
}