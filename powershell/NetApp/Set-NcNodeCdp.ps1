<#
 # Author: Andrew Sullivan
 # Reference: http://practical-admin.com/blog/netapp-powershell-toolkit-101-node-configuration/
 #
#>

function Set-NcNodeCdp {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [System.String]
        $Node,
 
        [Parameter(
            Mandatory=$true
        )]
        [Switch]$Enabled
 
    )
    process {
        if ($Node.GetType().FullName -ne "System.String") {
            $NodeName = $Node.Node
        } else {
            $NodeName = $Node
        }
 
        if ($Enabled) {
            $status = "on"
        } else {
            $status = "off"
        }
 
        $zapi  = "<system-cli><args>"
        $zapi +=   "<arg>node</arg>"
        $zapi +=   "<arg>run</arg>"
        $zapi +=   "<arg>-node $($NodeName)</arg>"
        $zapi +=   "<arg>options</arg>"
        $zapi +=   "<arg>cdpd.enable</arg>"
        $zapi +=   "<arg>$($status)</arg>"
        $zapi += "</args></system-cli>"
 
        $execute = Invoke-NcSystemApi -Request $zapi
 
        $result = "" | Select-Object Node,CDP
        $result.Node = $NodeName
 
        if ($execute.results.'cli-result-value' -eq "1") {
            $result.CDP = $status
        } else {
            Write-Warning $execute.results.'cli-output'
        }
 
        $result
 
    }
}