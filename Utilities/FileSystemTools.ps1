#region File System Utilities

function Find-WinSAKLargeFiles {
    <#
    .SYNOPSIS
        Find the largest files in a directory
    .PARAMETER Path
        The path to search (defaults to current directory)
    .PARAMETER Top
        Number of largest files to return (default: 10)
    .EXAMPLE
        Find-WinSAKLargeFiles -Path "C:\Users" -Top 20
    #>
    [CmdletBinding()]
    param(
        [string]$Path = (Get-Location).Path,
        [int]$Top = 10
    )
    
    Write-Host "Scanning for large files in: $Path" -ForegroundColor Yellow
    
    $files = Get-ChildItem -Path $Path -File -Recurse -ErrorAction SilentlyContinue |
        Sort-Object Length -Descending |
        Select-Object -First $Top |
        Select-Object @{N='Size(MB)';E={[math]::Round($_.Length/1MB,2)}}, FullName, LastWriteTime
    
    return $files
}

function Get-WinSAKDiskSpace {
    <#
    .SYNOPSIS
        Get disk space information for all drives
    .EXAMPLE
        Get-WinSAKDiskSpace
    #>
    [CmdletBinding()]
    param()
    
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object {
        $percentFree = [math]::Round(($_.Free / ($_.Used + $_.Free)) * 100, 2)
        [PSCustomObject]@{
            Drive = $_.Name
            'Total(GB)' = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
            'Used(GB)' = [math]::Round($_.Used / 1GB, 2)
            'Free(GB)' = [math]::Round($_.Free / 1GB, 2)
            'Free(%)' = $percentFree
        }
    }
    
    return $drives
}

function Remove-WinSAKTempFiles {
    <#
    .SYNOPSIS
        Clean up temporary files from common locations
    .PARAMETER WhatIf
        Show what would be deleted without actually deleting
    .EXAMPLE
        Remove-WinSAKTempFiles -WhatIf
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()
    
    $tempPaths = @(
        $env:TEMP,
        "C:\Windows\Temp",
        "$env:LOCALAPPDATA\Temp"
    )
    
    $totalSize = 0
    $fileCount = 0
    
    foreach ($path in $tempPaths | Where-Object { Test-Path $_ }) {
        Write-Host "Cleaning: $path" -ForegroundColor Yellow
        
        try {
            $files = Get-ChildItem -Path $path -File -Recurse -ErrorAction SilentlyContinue
            $fileCount += $files.Count
            $totalSize += ($files | Measure-Object -Property Length -Sum).Sum
            
            if ($PSCmdlet.ShouldProcess($path, "Remove temporary files")) {
                Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        catch {
            Write-Warning "Error cleaning $path : $_"
        }
    }
    
    Write-Host "Cleaned: $fileCount files, $([math]::Round($totalSize/1MB,2)) MB" -ForegroundColor Green
}

function Get-WinSAKFolderSize {
    <#
    .SYNOPSIS
        Calculate the size of a folder including all subfolders
    .PARAMETER Path
        Path to the folder
    .EXAMPLE
        Get-WinSAKFolderSize -Path "C:\Users\Username\Documents"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    if (-not (Test-Path $Path)) {
        Write-Warning "Path not found: $Path"
        return
    }
    
    $size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
        Measure-Object -Property Length -Sum).Sum
    
    [PSCustomObject]@{
        Path = $Path
        'Size(MB)' = [math]::Round($size / 1MB, 2)
        'Size(GB)' = [math]::Round($size / 1GB, 2)
    }
}

#endregion

Export-ModuleMember -Function Find-WinSAKLargeFiles, Get-WinSAKDiskSpace, Remove-WinSAKTempFiles, Get-WinSAKFolderSize
