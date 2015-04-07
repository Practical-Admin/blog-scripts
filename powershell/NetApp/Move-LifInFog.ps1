<#
 # Author: Andrew Sullivan
 # Reference: http://practical-admin.com/blog/netapp-powershell-toolkit-101-cluster-configuration/
 #
#>

function Move-LifInFog {
    [cmdletbinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        [DataONTAP.C.Types.Net.NetInterfaceInfo]
        $LIF
    )
    process {
        # determine the new destination port
        $newPort = Get-NcNetFailoverGroup | ?{ 
                $_.FailoverGroup -eq $LIF.FailoverGroup `
                    -and $_.Node -ne $LIF.CurrentNode
            } | Get-Random
 
        $message = "Moving LIF to $($newPort.Node):$($newPort.Port)"
 
        if ($PSCmdlet.ShouldProcess($LIF, $message)) {
            $LIF | Move-NcNetInterface -DestinationNode $newPort.Node -DestinationPort $newPort.Port
        }
    }
}