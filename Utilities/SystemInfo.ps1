#region System Information Utilities

function Get-WinSAKSystemInfo {
    <#
    .SYNOPSIS
        Get comprehensive system information
    .DESCRIPTION
        Displays detailed information about the Windows system including hardware, OS, and network details
    .EXAMPLE
        Get-WinSAKSystemInfo
    #>
    [CmdletBinding()]
    param(
        [switch]$Detailed
    )
    
    $info = [PSCustomObject]@{
        ComputerName = $env:COMPUTERNAME
        OSVersion = (Get-CimInstance Win32_OperatingSystem).Caption
        OSBuild = [System.Environment]::OSVersion.Version.Build
        Architecture = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
        Manufacturer = (Get-CimInstance Win32_ComputerSystem).Manufacturer
        Model = (Get-CimInstance Win32_ComputerSystem).Model
        Processor = (Get-CimInstance Win32_Processor).Name
        TotalRAM = "{0:N2} GB" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
        FreeRAM = "{0:N2} GB" -f ((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB / 1024)
        Uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    }
    
    if ($Detailed) {
        $info | Add-Member -NotePropertyName 'DiskInfo' -NotePropertyValue (Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | Select-Object Name, @{N='Size(GB)';E={[math]::Round($_.Used/1GB + $_.Free/1GB,2)}}, @{N='Free(GB)';E={[math]::Round($_.Free/1GB,2)}})
        $info | Add-Member -NotePropertyName 'NetworkAdapters' -NotePropertyValue (Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object Name, InterfaceDescription, Status)
    }
    
    return $info
}

function Get-WinSAKInstalledSoftware {
    <#
    .SYNOPSIS
        List all installed software on the system
    .EXAMPLE
        Get-WinSAKInstalledSoftware | Where-Object Name -like "*Chrome*"
    #>
    [CmdletBinding()]
    param(
        [string]$Name = "*"
    )
    
    $paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    
    $software = $paths | ForEach-Object {
        Get-ItemProperty $_ -ErrorAction SilentlyContinue
    } | Where-Object { $_.DisplayName -like $Name } | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object DisplayName
    
    return $software
}

#endregion

Export-ModuleMember -Function Get-WinSAKSystemInfo, Get-WinSAKInstalledSoftware
