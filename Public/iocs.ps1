function Get-FalconIocHost {
<#
.SYNOPSIS
Search for hosts that have observed a custom indicator
.DESCRIPTION
Requires 'IOCs: Read'.
.PARAMETER Type
Indicator type
.PARAMETER Value
Indicator value
.PARAMETER Offset
Position to begin retrieving results
.PARAMETER Limit
Maximum number of results per request
.PARAMETER All
Repeat requests until all available results are retrieved
.PARAMETER Total
Display the total result count instead of results
.LINK
https://github.com/CrowdStrike/psfalcon/wiki/Detection-and-Prevention-Policies
#>
    [CmdletBinding(DefaultParameterSetName='/indicators/queries/devices/v1:get')]
    param(
        [Parameter(ParameterSetName='/indicators/queries/devices/v1:get',Mandatory,
            ValueFromPipelineByPropertyName,Position=1)]
        [Parameter(ParameterSetName='/indicators/aggregates/devices-count/v1:get',Mandatory,
            ValueFromPipelineByPropertyName,Position=1)]
        [ValidateSet('domain','ipv4','ipv6','md5','sha256',IgnoreCase=$false)]
        [string]$Type,
        [Parameter(ParameterSetName='/indicators/queries/devices/v1:get',Mandatory,
            ValueFromPipelineByPropertyName,Position=2)]
        [Parameter(ParameterSetName='/indicators/aggregates/devices-count/v1:get',Mandatory,
            ValueFromPipelineByPropertyName,Position=2)]
        [string]$Value,
        [Parameter(ParameterSetName='/indicators/queries/devices/v1:get',Position=3)]
        [ValidateRange(1,100)]
        [string]$Limit,
        [Parameter(ParameterSetName='/indicators/queries/devices/v1:get')]
        [int32]$Offset,
        [Parameter(ParameterSetName='/indicators/queries/devices/v1:get')]
        [switch]$All,
        [Parameter(ParameterSetName='/indicators/aggregates/devices-count/v1:get',Mandatory)]
        [switch]$Total
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('type','offset','limit','value') }
        }
    }
    process { Invoke-Falcon @Param -Inputs $PSBoundParameters }
}
function Get-FalconIocProcess {
<#
.SYNOPSIS
Search for processes involving a custom indicator on a specific host
.DESCRIPTION
Requires 'IOCs: Read'.
.PARAMETER Id
Process identifier
.PARAMETER Type
Indicator type
.PARAMETER Value
Indicator value
.PARAMETER HostId
Host identifier
.PARAMETER Limit
Maximum number of results per request
.PARAMETER Offset
Position to begin retrieving results
.PARAMETER Detailed
Retrieve detailed information
.PARAMETER All
Repeat requests until all available results are retrieved
.LINK
https://github.com/CrowdStrike/psfalcon/wiki/Detection-and-Prevention-Policies
#>
    [CmdletBinding(DefaultParameterSetName='/indicators/queries/processes/v1:get')]
    param(
        [Parameter(ParameterSetName='/processes/entities/processes/v1:get',ValueFromPipeline,Mandatory)]
        [ValidatePattern('^pid:\w{32}:\d+$')]
        [Alias('Ids')]
        [string[]]$Id,
        [Parameter(ParameterSetName='/indicators/queries/processes/v1:get',Mandatory,Position=1)]
        [ValidateSet('domain','ipv4','ipv6','md5','sha256',IgnoreCase=$false)]
        [string]$Type,
        [Parameter(ParameterSetName='/indicators/queries/processes/v1:get',Mandatory,Position=2)]
        [string]$Value,
        [Parameter(ParameterSetName='/indicators/queries/processes/v1:get',Mandatory,ValueFromPipeline,
           Position=3)]
        [ValidatePattern('^\w{32}$')]
        [Alias('device_id')]
        [string]$HostId,
        [Parameter(ParameterSetName='/indicators/queries/processes/v1:get',Position=4)]
        [ValidateRange(1,100)]
        [string]$Limit,
        [Parameter(ParameterSetName='/indicators/queries/processes/v1:get')]
        [int32]$Offset,
        [Parameter(ParameterSetName='/indicators/queries/processes/v1:get')]
        [switch]$Detailed,
        [Parameter(ParameterSetName='/indicators/queries/processes/v1:get')]
        [switch]$All
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('ids','device_id','offset','type','value','limit') }
        }
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