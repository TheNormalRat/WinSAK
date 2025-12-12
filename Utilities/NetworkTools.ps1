#region Network Utilities

function Get-WinSAKPublicIP {
    <#
    .SYNOPSIS
        Get your public IP address
    .EXAMPLE
        Get-WinSAKPublicIP
    #>
    [CmdletBinding()]
    param()
    
    try {
        $ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -TimeoutSec 5).ip
        Write-Host "Public IP: $ip" -ForegroundColor Green
        return $ip
    }
    catch {
        Write-Warning "Failed to retrieve public IP: $_"
        return $null
    }
}

function Get-WinSAKNetworkSpeed {
    <#
    .SYNOPSIS
        Test network speed to common endpoints
    .EXAMPLE
        Get-WinSAKNetworkSpeed
    #>
    [CmdletBinding()]
    param(
        [string[]]$Targets = @("8.8.8.8", "1.1.1.1", "google.com")
    )
    
    $results = foreach ($target in $Targets) {
        $ping = Test-Connection -ComputerName $target -Count 4 -ErrorAction SilentlyContinue
        if ($ping) {
            [PSCustomObject]@{
                Target = $target
                AvgResponseTime = "{0:N2} ms" -f ($ping.ResponseTime | Measure-Object -Average).Average
                MinResponseTime = "{0:N2} ms" -f ($ping.ResponseTime | Measure-Object -Minimum).Minimum
                MaxResponseTime = "{0:N2} ms" -f ($ping.ResponseTime | Measure-Object -Maximum).Maximum
                PacketLoss = "0%"
            }
        }
        else {
            [PSCustomObject]@{
                Target = $target
                AvgResponseTime = "N/A"
                MinResponseTime = "N/A"
                MaxResponseTime = "N/A"
                PacketLoss = "100%"
            }
        }
    }
    
    return $results
}

function Clear-WinSAKDNSCache {
    <#
    .SYNOPSIS
        Clear DNS cache and display confirmation
    .EXAMPLE
        Clear-WinSAKDNSCache
    #>
    [CmdletBinding()]
    param()
    
    try {
        Clear-DnsClientCache
        Write-Host "DNS cache cleared successfully!" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to clear DNS cache: $_"
    }
}

function Get-WinSAKOpenPorts {
    <#
    .SYNOPSIS
        List all open ports and associated processes
    .EXAMPLE
        Get-WinSAKOpenPorts
    #>
    [CmdletBinding()]
    param()
    
    $connections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Listen' } | Select-Object LocalAddress, LocalPort, @{N='Process';E={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Name}}, State | Sort-Object LocalPort
    
    return $connections
}

#endregion

Export-ModuleMember -Function Get-WinSAKPublicIP, Get-WinSAKNetworkSpeed, Clear-WinSAKDNSCache, Get-WinSAKOpenPorts
