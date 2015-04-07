<#
 # Author: Andrew Sullivan
 # Reference: http://practical-admin.com/blog/netapp-powershell-toolkit-101-storage-virtual-machine-configuration/
 #
#>

function Remove-SvmAggrAccess {
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
        # remove the aggr from the list of current aggrs
        $aggrlist = (Get-NcVserver -Name $svmName).AggrList | ?{ $_ -notin $Aggregate }
 
        if ($PSCmdlet.ShouldProcess(
                $Vserver, 
                "Removing aggregate $($Aggregate) from approved list"
        )) {
            # update the assigned aggregate list
            Set-NcVserver -Name $Vserver -Aggregates $aggrList
        }
    }
}