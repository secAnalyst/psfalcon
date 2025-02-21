function Edit-FalconContainerAwsAccount {
<#
.SYNOPSIS
Modify Falcon Container Security AWS accounts
.DESCRIPTION
Requires 'Kubernetes Protection: Write'.
.PARAMETER Region
AWS cloud region
.PARAMETER Id
AWS account identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:patch')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:patch',Position=1)]
        [string]$Region,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:patch',Mandatory,
            ValueFromPipeline,ValueFromPipelineByPropertyName,Position=2)]
        [ValidatePattern('^\d{12}$')]
        [Alias('Ids')]
        [string[]]$Id
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('ids','region') }
        }
        [System.Collections.Generic.List[string]]$List = @()
    }
    process { if ($Id) { @($Id).foreach{ $List.Add($_) }}}
    end {
        if ($List) {
            $PSBoundParameters['Id'] = @($List | Select-Object -Unique)
            Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
    }
}
function Get-FalconContainerAwsAccount {
<#
.SYNOPSIS
Search for Falcon Container Security AWS accounts
.DESCRIPTION
Requires 'Kubernetes Protection: Read'.
.PARAMETER Id
AWS account identifier
.PARAMETER Status
Filter by account status
.PARAMETER Limit
Maximum number of results per request
.PARAMETER Offset
Position to begin retrieving results
.PARAMETER All
Repeat requests until all available results are retrieved
.PARAMETER Total
Display total result count instead of results
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:get')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:get',ValueFromPipeline,
            ValueFromPipelineByPropertyName,Position=1)]
        [ValidatePattern('^\d{12}$')]
        [Alias('Ids')]
        [string[]]$Id,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:get',Position=2)]
        [ValidateSet('provisioned','operational',IgnoreCase=$false)]
        [string]$Status,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:get',Position=3)]
        [int32]$Limit,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:get')]
        [int32]$Offset,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:get')]
        [switch]$All,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:get')]
        [switch]$Total
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('ids','offset','limit','status') }
        }
        [System.Collections.Generic.List[string]]$List = @()
    }
    process {
        if ($Id) {
            @($Id).foreach{ $List.Add($_) }
        } else {
            Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
    }
    end {
        if ($List) {
            $PSBoundParameters['Id'] = @($List | Select-Object -Unique)
            Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
    }
}
function Get-FalconContainerCloud {
<#
.SYNOPSIS
Return Falcon Container Security cloud provider locations
.DESCRIPTION
Requires 'Kubernetes Protection: Read'.
.PARAMETER Cloud
Cloud provider
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/cloud-locations/v1:get')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/cloud-locations/v1:get',ValueFromPipeline,
            ValueFromPipelineByPropertyName,Position=1)]
        [ValidateSet('aws','azure','gcp',IgnoreCase=$false)]
        [Alias('clouds')]
        [string[]]$Cloud
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('clouds') }
        }
        [System.Collections.Generic.List[string]]$List = @()
    }
    process {
        if ($Cloud) { @($Cloud).foreach{ $List.Add($_) }}
    }
    end {
        if ($List) {
            $PSBoundParameters['Cloud'] = @($List | Select-Object -Unique)
            Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
    }
}
function Get-FalconContainerCluster {
<#
.SYNOPSIS
Search for Falcon Container Security clusters
.DESCRIPTION
Requires 'Kubernetes Protection: Read'.
.PARAMETER Id
Cluster account identifier
.PARAMETER Location
Cloud provider location
.PARAMETER ClusterName
Cluster name
.PARAMETER ClusterService
Cluster service
.PARAMETER Limit
Maximum number of results per request
.PARAMETER Offset
Position to begin retrieving results
.PARAMETER All
Repeat requests until all available results are retrieved
.PARAMETER Total
Display total result count instead of results
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get',
            ValueFromPipeline,ValueFromPipelineByPropertyName,Position=1)]
        [Alias('account_ids','Ids')]
        [string[]]$Id,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get',Position=2)]
        [Alias('Locations')]
        [string[]]$Location,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get',Position=3)]
        [Alias('cluster_names','ClusterNames')]
        [string[]]$ClusterName,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get',Position=4)]
        [ValidateSet('eks',IgnoreCase=$false)]
        [Alias('cluster_service')]
        [string]$ClusterService,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get',Position=5)]
        [int32]$Limit,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get')]
        [int32]$Offset,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get')]
        [switch]$All,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/kubernetes/clusters/v1:get')]
        [switch]$Total
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{
                Query = @('limit','cluster_names','account_ids','offset','cluster_service','locations')
            }
        }
        [System.Collections.Generic.List[string]]$List = @()
    }
    process { if ($Id) { @($Id).foreach{ $List.Add($_) }}}
    end {
        if ($List) {
            $PSBoundParameters['Id'] = @($List | Select-Object -Unique)
            Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
    }
}
function Invoke-FalconContainerScan {
<#
.SYNOPSIS
Initiate a Falcon Container Security scan
.DESCRIPTION
Requires 'Kubernetes Protection: Write'.
.PARAMETER ScanType
Scan type
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/scan/trigger/v1:post')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/scan/trigger/v1:post',Mandatory,
           Position=1)]
        [ValidateSet('dry-run','full','cluster-refresh',IgnoreCase=$false)]
        [Alias('scan-type')]
        [string]$ScanType
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('scan_type') }
        }
    }
    process { Invoke-Falcon @Param -Inputs $PSBoundParameters }
}
function New-FalconContainerAwsAccount {
<#
.SYNOPSIS
Provision Falcon Container Security accounts
.DESCRIPTION
Requires 'Kubernetes Protection: Write'.
.PARAMETER Region
AWS cloud region
.PARAMETER Id
AWS account identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:post')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:post',Mandatory,
           Position=1)]
        [string]$Region,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:post',Mandatory,
            ValueFromPipeline,ValueFromPipelineByPropertyName,Position=2)]
        [ValidatePattern('^\d{12}$')]
        [Alias('account_id')]
        [string]$Id
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Body = @{ resources = @('account_id','region') }}
        }
    }
    process { Invoke-Falcon @Param -Inputs $PSBoundParameters }
}
function New-FalconContainerKey {
<#
.SYNOPSIS
Regenerate the API key for Falcon Container Security Docker registry integrations
.DESCRIPTION
Requires 'Kubernetes Protection: Write'.
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/integration/api-key/v1:post')]
    param()
    process { Invoke-Falcon -Endpoint $PSCmdlet.ParameterSetName }
}
function Receive-FalconContainerYaml {
<#
.SYNOPSIS
Download a sample Helm values.yaml file
.DESCRIPTION
Requires 'Kubernetes Protection: Read'.
.PARAMETER Path
Destination path
.PARAMETER ClusterName
Cluster name
.PARAMETER Force
Overwrite an existing file when present
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/integration/agent/v1:get')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/integration/agent/v1:get',Mandatory,
           Position=1)]
        [string]$Path,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/integration/agent/v1:get',Mandatory,
            ValueFromPipeline,ValueFromPipelineByPropertyName,Position=2)]
        [Alias('cluster_name')]
        [string]$ClusterName,
        [Parameter(ParameterSetName='/kubernetes-protection/entities/integration/agent/v1:get')]
        [switch]$Force
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Headers = @{ Accept = 'application/yaml' }
            Format = @{
                Query = @('cluster_name')
                Outfile = 'path'
            }
        }
    }
    process {
        $PSBoundParameters.Path = Assert-Extension $PSBoundParameters.Path 'yaml'
        $OutPath = Test-OutFile $PSBoundParameters.Path
        if ($OutPath.Category -eq 'ObjectNotFound') {
            Write-Error @OutPath
        } elseif ($PSBoundParameters.Path) {
            if ($OutPath.Category -eq 'WriteError' -and !$Force) {
                Write-Error @OutPath
            } else {
                Invoke-Falcon @Param -Inputs $PSBoundParameters
            }
        }}
}
function Remove-FalconContainerAwsAccount {
<#
.SYNOPSIS
Remove Falcon Container Security AWS accounts
.DESCRIPTION
Requires 'Kubernetes Protection: Write'.
.PARAMETER Id
AWS account identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Kubernetes-Protection
#>
    [CmdletBinding(DefaultParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:delete')]
    param(
        [Parameter(ParameterSetName='/kubernetes-protection/entities/accounts/aws/v1:delete',Mandatory,
            ValueFromPipeline,ValueFromPipelineByPropertyName,Position=1)]
        [ValidatePattern('^\d{12}$')]
        [Alias('Ids')]
        [string[]]$Id
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('ids') }
        }
        [System.Collections.Generic.List[string]]$List = @()
    }
    process { if ($Id) { @($Id).foreach{ $List.Add($_) }}}
    end {
        if ($List) {
            $PSBoundParameters['Id'] = @($List | Select-Object -Unique)
            Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
    }
}