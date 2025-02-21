function Edit-FalconInstallToken {
<#
.SYNOPSIS
Modify installation tokens
.DESCRIPTION
Requires 'Installation Tokens: Write'.
.PARAMETER Label
Installation token label
.PARAMETER ExpiresTimestamp
Installation token expiration time (RFC3339),or 'null'
.PARAMETER Revoked
Set revocation status
.PARAMETER Id
Installation token identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Installation-Tokens
#>
    [CmdletBinding(DefaultParameterSetName='/installation-tokens/entities/tokens/v1:patch')]
    param(
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:patch',
            ValueFromPipelineByPropertyName,Position=1)]
        [string]$Label,
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:patch',
            ValueFromPipelineByPropertyName,Position=2)]
        [ValidatePattern('^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z|null)$')]
        [Alias('expires_timestamp')]
        [string]$ExpiresTimestamp,
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:patch',
            ValueFromPipelineByPropertyName,Position=3)]
        [boolean]$Revoked,
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:patch',Mandatory,
            ValueFromPipelineByPropertyName,Position=4)]
        [ValidatePattern('^\w{32}$')]
        [Alias('Ids')]
        [string[]]$Id
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{
                Query = @('ids')
                Body = @{ root = @('label','revoked','expires_timestamp') }
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
function Get-FalconInstallToken {
<#
.SYNOPSIS
Search for installation tokens
.DESCRIPTION
Requires 'Installation Tokens: Read'.
.PARAMETER Id
Installation token identifier
.PARAMETER Filter
Falcon Query Language expression to limit results
.PARAMETER Sort
Property and direction to sort results
.PARAMETER Limit
Maximum number of results per request
.PARAMETER Offset
Position to begin retrieving results
.PARAMETER Detailed
Retrieve detailed information
.PARAMETER All
Repeat requests until all available results are retrieved
.PARAMETER Total
Display total result count instead of results
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Installation-Tokens
#>
    [CmdletBinding(DefaultParameterSetName='/installation-tokens/queries/tokens/v1:get')]
    param(
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:get',Mandatory,ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidatePattern('^\w{32}$')]
        [Alias('Ids')]
        [string[]]$Id,
        [Parameter(ParameterSetName='/installation-tokens/queries/tokens/v1:get',Position=1)]
        [ValidateScript({ Test-FqlStatement $_ })]
        [string]$Filter,
        [Parameter(ParameterSetName='/installation-tokens/queries/tokens/v1:get',Position=2)]
        [string]$Sort,
        [Parameter(ParameterSetName='/installation-tokens/queries/tokens/v1:get',Position=3)]
        [ValidateRange(1,1000)]
        [int32]$Limit,
        [Parameter(ParameterSetName='/installation-tokens/queries/tokens/v1:get')]
        [int32]$Offset,
        [Parameter(ParameterSetName='/installation-tokens/queries/tokens/v1:get')]
        [switch]$Detailed,
        [Parameter(ParameterSetName='/installation-tokens/queries/tokens/v1:get')]
        [switch]$All,
        [Parameter(ParameterSetName='/installation-tokens/queries/tokens/v1:get')]
        [switch]$Total
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('sort','ids','offset','limit','filter') }
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
function Get-FalconInstallTokenEvent {
<#
.SYNOPSIS
Search for installation token audit events
.DESCRIPTION
Requires 'Installation Tokens: Read'.
.PARAMETER Id
Installation token audit event identifier
.PARAMETER Filter
Falcon Query Language expression to limit results
.PARAMETER Sort
Property and direction to sort results
.PARAMETER Limit
Maximum number of results per request
.PARAMETER Offset
Position to begin retrieving results
.PARAMETER Detailed
Retrieve detailed information
.PARAMETER All
Repeat requests until all available results are retrieved
.PARAMETER Total
Display total result count instead of results
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Installation-Tokens
#>
    [CmdletBinding(DefaultParameterSetName='/installation-tokens/queries/audit-events/v1:get')]
    param(
        [Parameter(ParameterSetName='/installation-tokens/entities/audit-events/v1:get',Mandatory,
            ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidatePattern('^\w{32}$')]
        [Alias('Ids')]
        [string[]]$Id,
        [Parameter(ParameterSetName='/installation-tokens/queries/audit-events/v1:get',Position=1)]
        [ValidateScript({ Test-FqlStatement $_ })]
        [string]$Filter,
        [Parameter(ParameterSetName='/installation-tokens/queries/audit-events/v1:get',Position=2)]
        [string]$Sort,
        [Parameter(ParameterSetName='/installation-tokens/queries/audit-events/v1:get',Position=3)]
        [int32]$Limit,
        [Parameter(ParameterSetName='/installation-tokens/queries/audit-events/v1:get')]
        [int32]$Offset,
        [Parameter(ParameterSetName='/installation-tokens/queries/audit-events/v1:get')]
        [switch]$Detailed,
        [Parameter(ParameterSetName='/installation-tokens/queries/audit-events/v1:get')]
        [switch]$All,
        [Parameter(ParameterSetName='/installation-tokens/queries/audit-events/v1:get')]
        [switch]$Total
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Query = @('sort','ids','offset','limit','filter') }
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
function Get-FalconInstallTokenSetting {
<#
.SYNOPSIS
Retrieve installation token settings
.DESCRIPTION
Requires 'Installation Tokens: Read'.

Returns the maximum number of allowed installation tokens,and whether or not they are required for
installation of the Falcon sensor.
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Installation-Tokens
#>
    [CmdletBinding(DefaultParameterSetName='/installation-tokens/entities/customer-settings/v1:get')]
    param()
    process { Invoke-Falcon -Endpoint $PSCmdlet.ParameterSetName }
}
function New-FalconInstallToken {
<#
.SYNOPSIS
Create an installation token
.DESCRIPTION
Requires 'Installation Tokens: Write'.
.PARAMETER Label
Installation token label
.PARAMETER ExpiresTimestamp
Installation token expiration time (RFC3339),or 'null'
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Installation-Tokens
#>
    [CmdletBinding(DefaultParameterSetName='/installation-tokens/entities/tokens/v1:post')]
    param(
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:post',Mandatory,Position=1)]
        [string]$Label,
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:post',Mandatory,Position=2)]
        [ValidatePattern('^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z|null)$')]
        [Alias('expires_timestamp')]
        [string]$ExpiresTimestamp
    )
    process {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Body = @{ root = @('label','expires_timestamp') }}
        }
        Invoke-Falcon @Param -Inputs $PSBoundParameters
    }
}
function Remove-FalconInstallToken {
<#
.SYNOPSIS
Remove installation tokens
.DESCRIPTION
Requires 'Installation Tokens: Write'.
.PARAMETER Id
Installation token identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Installation-Tokens
#>
    [CmdletBinding(DefaultParameterSetName='/installation-tokens/entities/tokens/v1:delete')]
    param(
        [Parameter(ParameterSetName='/installation-tokens/entities/tokens/v1:delete',Mandatory,
            ValueFromPipeline,ValueFromPipelineByPropertyName,Position=1)]
        [ValidatePattern('^\w{32}$')]
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