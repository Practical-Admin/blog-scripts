function Set-NcVolQosPolicyGroup {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [String]$Name
        ,
 
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [String]$PolicyGroup
        ,
 
        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias("Vserver")]
        [String]$VserverContext = $null
 
    )
    process {
        # verify the volume
        $volume = Get-NcVol -Name $Name -VserverContext $VserverContext
 
        if (!$volume) {
            throw "Unable to find volume with name $($Name)"
        }
 
        # verify the QoS Policy Group
        $policy = Get-NcQosPolicyGroup -Name $PolicyGroup
 
        if (!$policy) {
            throw "Unable to find policy group with name $($PolicyGroup)"
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
 
        $attributes.VolumeQosAttributes.PolicyGroupName = $PolicyGroup
 
        # update the volume
        if ($PSCmdlet.ShouldProcess(
            $volume, 
            "Attach policy group $($policy.PolicyGroup).")
        ) {
            Update-NcVol -Query $query -Attributes $attributes | Out-Null
        }
 
        $volume | Get-NcVolQosPolicyGroup
    }
}