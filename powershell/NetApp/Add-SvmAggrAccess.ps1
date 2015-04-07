<#
 # Author: Andrew Sullivan
 # Reference: http://practical-admin.com/blog/netapp-powershell-toolkit-101-storage-virtual-machine-configuration/
 #
#>

function Add-SvmAggrAccess {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [System.String]$Vserver
        ,
 
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias('Name')]
        [System.String[]]$Aggregate
    )
    process {
        # get the current aggr list
        $aggrList = (Get-NcVserver -Name $svmName).AggrList
 
        # add the new aggr to the list
        $aggrlist += $Aggregate
 
        if ($PSCmdlet.ShouldProcess($Vserver, "Adding aggregate $($Aggregate) to approved list")) {
            # update the assigned aggregate list
            Set-NcVserver -Name $Vserver -Aggregates $aggrList
        }
    }
}
