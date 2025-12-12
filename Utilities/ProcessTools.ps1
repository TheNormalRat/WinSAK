#region Process & Performance Utilities

function Get-WinSAKTopProcesses {
    <#
    .SYNOPSIS
        Get top processes by CPU or Memory usage
    .PARAMETER SortBy
        Sort by CPU or Memory (default: CPU)
    .PARAMETER Top
        Number of processes to return (default: 10)
    .EXAMPLE
        Get-WinSAKTopProcesses -SortBy Memory -Top 15
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('CPU', 'Memory')]
        [string]$SortBy = 'CPU',
        [int]$Top = 10
    )
    
    if ($SortBy -eq 'CPU') {
        $processes = Get-Process | Sort-Object CPU -Descending | Select-Object -First $Top |
            Select-Object Name, Id, @{N='CPU(s)';E={[math]::Round($_.CPU,2)}}, @{N='Memory(MB)';E={[math]::Round($_.WorkingSet64/1MB,2)}}
    }
    else {
        $processes = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First $Top |
            Select-Object Name, Id, @{N='CPU(s)';E={[math]::Round($_.CPU,2)}}, @{N='Memory(MB)';E={[math]::Round($_.WorkingSet64/1MB,2)}}
    }
    
    return $processes
}

function Stop-WinSAKProcess {
    <#
    .SYNOPSIS
        Stop a process by name or ID with confirmation
    .PARAMETER Name
        Process name to stop
    .PARAMETER Id
        Process ID to stop
    .PARAMETER Force
        Force stop without confirmation
    .EXAMPLE
        Stop-WinSAKProcess -Name "chrome" -Force
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ParameterSetName='ByName')]
        [string]$Name,
        
        [Parameter(ParameterSetName='ById')]
        [int]$Id,
        
        [switch]$Force
    )
    
    if ($Name) {
        $processes = Get-Process -Name $Name -ErrorAction SilentlyContinue
    }
    else {
        $processes = Get-Process -Id $Id -ErrorAction SilentlyContinue
    }
    
    if (-not $processes) {
        Write-Warning "No processes found"
        return
    }
    
    foreach ($proc in $processes) {
        if ($Force -or $PSCmdlet.ShouldProcess($proc.Name, "Stop process")) {
            try {
                Stop-Process -Id $proc.Id -Force
                Write-Host "Stopped: $($proc.Name) (ID: $($proc.Id))" -ForegroundColor Green
            }
            catch {
                Write-Warning "Failed to stop $($proc.Name): $_"
            }
        }
    }
}

function Get-WinSAKServiceStatus {
    <#
    .SYNOPSIS
        Get status of Windows services with filtering options
    .PARAMETER Name
        Filter by service name (supports wildcards)
    .PARAMETER Status
        Filter by status (Running, Stopped, etc.)
    .EXAMPLE
        Get-WinSAKServiceStatus -Status Running
    #>
    [CmdletBinding()]
    param(
        [string]$Name = "*",
        [ValidateSet('All', 'Running', 'Stopped')]
        [string]$Status = 'All'
    )
    
    $services = Get-Service -Name $Name
    
    if ($Status -ne 'All') {
        $services = $services | Where-Object { $_.Status -eq $Status }
    }
    
    return $services | Select-Object Name, DisplayName, Status, StartType | Sort-Object DisplayName
}

#endregion

Export-ModuleMember -Function Get-WinSAKTopProcesses, Stop-WinSAKProcess, Get-WinSAKServiceStatus
