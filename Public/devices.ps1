function Add-FalconGroupingTag {
<#
.SYNOPSIS
Add FalconGroupingTags to Hosts
.DESCRIPTION
Requires 'Hosts: Write'.
.PARAMETER Tags
FalconGroupingTag value ['FalconGroupingTags/<string>']
.PARAMETER Id
Host identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Host-and-Host-Group-Management
#>
    [CmdletBinding(DefaultParameterSetName='/devices/entities/devices/tags/v1:patch')]
    param(
        [Parameter(ParameterSetName='/devices/entities/devices/tags/v1:patch',Mandatory,Position=1)]
        [ValidatePattern('^FalconGroupingTags/.+$')]
        [ValidateScript({
            @($_).foreach{
                if ((Test-RegexValue $_) -eq 'tag') { $true } else {
                    throw "Valid values include letters, numbers, hyphens, unscores and forward slashes. ['$_']"
                }
            }
        })]
        [string[]]$Tags,
        [Parameter(ParameterSetName='/devices/entities/devices/tags/v1:patch',Mandatory,ValueFromPipeline,
            ValueFromPipelineByPropertyName,Position=2)]
        [ValidatePattern('^\w{32}$')]
        [Alias('device_ids','device_id','Ids')]
        [string[]]$Id
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Body = @{ root = @('tags','device_ids','action') }}
        }
        $PSBoundParameters['action'] = 'add'
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
function Get-FalconHost {
<#
.SYNOPSIS
Search for hosts
.DESCRIPTION
Requires 'Hosts: Read'.
.PARAMETER Id
Host identifier
.PARAMETER Filter
Falcon Query Language expression to limit results
.PARAMETER Sort
Property and direction to sort results
.PARAMETER Limit
Maximum number of results per request
.PARAMETER Include
Include additional properties
.PARAMETER Offset
Position to begin retrieving results
.PARAMETER Hidden
Restrict search to 'hidden' hosts
.PARAMETER Login
Retrieve user login history
.PARAMETER Network
Retrieve network address history
.PARAMETER State
Retrieve online status
.PARAMETER Detailed
Retrieve detailed information
.PARAMETER All
Repeat requests until all available results are retrieved
.PARAMETER Total
Display total result count instead of results
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Host-and-Host-Group-Management
#>
    [CmdletBinding(DefaultParameterSetName='/devices/queries/devices-scroll/v1:get')]
    param(
        [Parameter(ParameterSetName='/devices/entities/devices/v1:get',Mandatory,ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='/devices/combined/devices/login-history/v1:post',Mandatory,ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='/devices/combined/devices/network-address-history/v1:post',Mandatory,
            ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='/devices/entities/online-state/v1:get',Mandatory,ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidatePattern('^\w{32}$')]
        [Alias('Ids','device_id','host_ids','aid')]
        [string[]]$Id,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get',Position=1)]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get',Position=1)]
        [ValidateScript({ Test-FqlStatement $_ })]
        [string]$Filter,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get',Position=2)]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get',Position=2)]
        [ValidateSet('device_id.asc','device_id.desc','agent_load_flags.asc','agent_load_flags.desc',
            'agent_version.asc','agent_version.desc','bios_manufacturer.asc','bios_manufacturer.desc',
            'bios_version.asc','bios_version.desc','config_id_base.asc','config_id_base.desc',
            'config_id_build.asc','config_id_build.desc','config_id_platform.asc','config_id_platform.desc',
            'cpu_signature.asc','cpu_signature.desc','external_ip.asc','external_ip.desc','first_seen.asc',
            'first_seen.desc','hostname.asc','hostname.desc','instance_id.asc','instance_id.desc',
            'last_login_timestamp.asc','last_login_timestamp.desc','last_seen.asc','last_seen.desc',
            'local_ip.asc','local_ip.desc','local_ip.raw.asc','local_ip.raw.desc','mac_address.asc',
            'mac_address.desc','machine_domain.asc','machine_domain.desc','major_version.asc',
            'major_version.desc','minor_version.asc','minor_version.desc','modified_timestamp.asc',
            'modified_timestamp.desc','os_version.asc','os_version.desc','ou.asc','ou.desc','platform_id.asc',
            'platform_id.desc','platform_name.asc','platform_name.desc','product_type_desc.asc',
            'product_type_desc.desc','reduced_functionality_mode.asc','reduced_functionality_mode.desc',
            'release_group.asc','release_group.desc','serial_number.asc','serial_number.desc','site_name.asc',
            'site_name.desc','status.asc','status.desc','system_manufacturer.asc','system_manufacturer.desc',
            'system_product_name.asc','system_product_name.desc',IgnoreCase=$false)]
        [string]$Sort,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get',Position=3)]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get',Position=3)]
        [ValidateRange(1,5000)]
        [int32]$Limit,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get',Position=4)]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get',Position=4)]
        [ValidateSet('group_names','login_history','network_history','online_state',
            'zero_trust_assessment',IgnoreCase=$false)]
        [string[]]$Include,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get')]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get')]
        [string]$Offset,
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get',Mandatory)]
        [switch]$Hidden,
        [Parameter(ParameterSetName='/devices/combined/devices/login-history/v1:post',Mandatory)]
        [switch]$Login,
        [Parameter(ParameterSetName='/devices/combined/devices/network-address-history/v1:post',Mandatory)]
        [switch]$Network,
        [Parameter(ParameterSetName='/devices/entities/online-state/v1:get',Mandatory)]
        [switch]$State,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get')]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get')]
        [switch]$Detailed,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get')]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get')]
        [switch]$All,
        [Parameter(ParameterSetName='/devices/queries/devices-scroll/v1:get')]
        [Parameter(ParameterSetName='/devices/queries/devices-hidden/v1:get')]
        [switch]$Total
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = if ($PSCmdlet.ParameterSetName -match 'post$') {
                @{ Body = @{ root = @('ids') }}
            } else {
                @{ Query = @('ids','filter','sort','limit','offset') }
            }
            Max = 500
        }
        [System.Collections.Generic.List[string]]$List = @()
    }
    process {
        if ($Id) {
            @($Id).foreach{ $List.Add($_) }
        } else {
            $Request = Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
    }
    end {
        if ($List) {
            $PSBoundParameters['Id'] = @($List | Select-Object -Unique)
            $Request = Invoke-Falcon @Param -Inputs $PSBoundParameters
        }
        if ($Request -and $Include) {
            if (!$Request.device_id) {
                $Request = if ($Include -contains 'group_names') {
                    & $MyInvocation.MyCommand.Name -Id $Request | Select-Object device_id,groups
                } else {
                    @($Request).foreach{ ,[PSCustomObject]@{ device_id = $_ }}
                }
            }
            if ($Include -contains 'group_names') {
                $Groups = Get-FalconHostGroup -Id $Request.groups -EA 0 | Select-Object id,name
                if ($Groups) {
                    foreach ($i in $Request) {
                        $i.groups = @($Groups | Where-Object { $i.groups -contains $_.id })
                    }
                }
            }
            if ($Include -contains 'login_history') {
                foreach ($i in (& $MyInvocation.MyCommand.Name -Id $Request.device_id -Login -EA 0)) {
                    $SetParam = @{
                        Object = $Request | Where-Object { $_.device_id -eq $i.device_id }
                        Name = 'login_history'
                        Value = $i.recent_logins
                    }
                    Set-Property @SetParam
                }
            }
            if ($Include -contains 'network_history') {
                foreach ($i in (& $MyInvocation.MyCommand.Name -Id $Request.device_id -Network -EA 0)) {
                    $SetParam = @{
                        Object = $Request | Where-Object { $_.device_id -eq $i.device_id }
                        Name = 'network_history'
                        Value = $i.history
                    }
                    Set-Property @SetParam
                }
            }
            if ($Include -contains 'online_state') {
                foreach ($i in (& $MyInvocation.MyCommand.Name -Id $Request.device_id -State -EA 0)) {
                    $SetParam = @{
                        Object = $Request | Where-Object { $_.device_id -eq $i.id }
                        Name = 'online_state'
                        Value = $i
                    }
                    Set-Property @SetParam
                }
            }
            if ($Include -contains 'zero_trust_assessment') {
                foreach ($i in (Get-FalconZta -Id $Request.device_id -EA 0)) {
                    $SetParam = @{
                        Object = $Request | Where-Object { $_.device_id -eq $i.aid }
                        Name = 'zero_trust_assessment'
                        Value = $i | Select-Object modified_time,sensor_file_status,assessment,assessment_items
                    }
                    Set-Property @SetParam
                }
            }
        }
        $Request
    }
}
function Invoke-FalconHostAction {
<#
.SYNOPSIS
Perform actions on hosts
.DESCRIPTION
Requires 'Hosts: Write'.
.PARAMETER Name
Action to perform
.PARAMETER Include
Include additional properties
.PARAMETER Id
Host identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Host-and-Host-Group-Management
#>
    [CmdletBinding(DefaultParameterSetName='/devices/entities/devices-actions/v2:post')]
    param(
        [Parameter(ParameterSetName='/devices/entities/devices-actions/v2:post',Mandatory,Position=1)]
        [ValidateSet('contain','lift_containment','hide_host','unhide_host','detection_suppress',
            'detection_unsuppress',IgnoreCase=$false)]
        [Alias('action_name')]
        [string]$Name,
        [Parameter(ParameterSetName='/devices/entities/devices-actions/v2:post',Position=2)]
        [ValidateSet('agent_version','cid','external_ip','first_seen','host_hidden_status','hostname',
            'last_seen','local_ip','mac_address','os_build','os_version','platform_name','product_type',
            'product_type_desc','reduced_functionality_mode','serial_number','system_manufacturer',
            'system_product_name','tags',IgnoreCase=$false)]
        [string[]]$Include,
        [Parameter(ParameterSetName='/devices/entities/devices-actions/v2:post',Mandatory,ValueFromPipeline,
            ValueFromPipelineByPropertyName,Position=3)]
        [ValidatePattern('^\w{32}$')]
        [Alias('Ids','device_id')]
        [string[]]$Id
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{
                Query = @('action_name')
                Body = @{ root = @('ids') }
            }
            Max = if ($PSBoundParameters.Name -match '_host$') { 100 } else { 500 }
        }
        [System.Collections.Generic.List[string]]$List = @()
    }
    process { if ($Id) { @($Id).foreach{ $List.Add($_) }}}
    end {
        if ($List) {
            $PSBoundParameters['Id'] = @($List | Select-Object -Unique)
            $Request = Invoke-Falcon @Param -Inputs $PSBoundParameters
            if ($Request -and $Include) {
                $Request = Add-Include $Request $PSBoundParameters -Command 'Get-FalconHost'
            }
            $Request
        }
    }
}
function Remove-FalconGroupingTag {
<#
.SYNOPSIS
Remove FalconGroupingTags from hosts
.DESCRIPTION
Requires 'Hosts: Write'.
.PARAMETER Tags
FalconGroupingTag value
.PARAMETER Id
Host identifier
.LINK
https://github.com/crowdstrike/psfalcon/wiki/Host-and-Host-Group-Management
#>
    [CmdletBinding(DefaultParameterSetName='/devices/entities/devices/tags/v1:patch')]
    param(
        [Parameter(ParameterSetName='/devices/entities/devices/tags/v1:patch',Mandatory,Position=1)]
        [ValidatePattern('^FalconGroupingTags/.+$')]
        [ValidateScript({
            @($_).foreach{
                if ((Test-RegexValue $_) -eq 'tag') {
                    $true
                } else {
                    throw "Valid values include letters, numbers, hyphens, unscores and forward slashes. ['$_']"
                }
            }
        })]
        [string[]]$Tags,
        [Parameter(ParameterSetName='/devices/entities/devices/tags/v1:patch',Mandatory,ValueFromPipeline,
            ValueFromPipelineByPropertyName,Position=2)]
        [ValidatePattern('^\w{32}$')]
        [Alias('device_ids','device_id','Ids')]
        [string[]]$Id
    )
    begin {
        $Param = @{
            Command = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Format = @{ Body = @{ root = @('tags','device_ids','action') }}
        }
        $PSBoundParameters['action'] = 'remove'
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