#region Application Installer Utilities

function Invoke-WinSAKAppInstaller {
    <#
    .SYNOPSIS
        Install applications and bundles using winget
    .DESCRIPTION
        Provides curated application bundles and individual app installation
    .EXAMPLE
        Invoke-WinSAKAppInstaller
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Application Installer" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    # Check if winget is available
    if (-not (Test-WingetInstalled)) {
        Write-Host "Winget is not installed or not found." -ForegroundColor Red
        Write-Host "`nWinget is required for application installation." -ForegroundColor Yellow
        Write-Host "Would you like to install it now? (Requires Windows 10/11)`n" -ForegroundColor Yellow
        
        $install = Read-Host "Install winget? (y/n)"
        if ($install -eq 'y') {
            Install-Winget
        }
        else {
            Write-Host "`nReturning to main menu..." -ForegroundColor Gray
            Start-Sleep -Seconds 2
            return
        }
    }
    
    Write-Host "Install Apps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] Steam" -ForegroundColor White
    Write-Host "  [2] Discord" -ForegroundColor White
    Write-Host "  [3] NVIDIA GeForce Experience" -ForegroundColor White
    Write-Host "  [4] 7-Zip" -ForegroundColor White
    Write-Host "  [5] Mozilla Firefox" -ForegroundColor White
    Write-Host "  [6] Google Chrome" -ForegroundColor White
    Write-Host "  [7] SteelSeries GG" -ForegroundColor White
    Write-Host ""
    Write-Host "  [8] Search and Install App" -ForegroundColor Cyan
    Write-Host "  [9] List All Installed Apps" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [0] Back to Main Menu" -ForegroundColor Red
    Write-Host ""
    
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        "1" {
            Install-SingleApp -Name "Steam" -Id "Valve.Steam"
        }
        "2" {
            Install-SingleApp -Name "Discord" -Id "Discord.Discord"
        }
        "3" {
            Install-SingleApp -Name "NVIDIA GeForce Experience" -Id "Nvidia.GeForceExperience"
        }
        "4" {
            Install-SingleApp -Name "7-Zip" -Id "7zip.7zip"
        }
        "5" {
            Install-SingleApp -Name "Mozilla Firefox" -Id "Mozilla.Firefox"
        }
        "6" {
            Install-SingleApp -Name "Google Chrome" -Id "Google.Chrome"
        }
        "7" {
            Install-SingleApp -Name "SteelSeries GG" -Id "SteelSeries.GG"
        }
        "8" {
            Install-CustomApp
        }
        "9" {
            Show-InstalledApps
        }
    }
}

function Test-WingetInstalled {
    <#
    .SYNOPSIS
        Check if winget is installed and available
    #>
    [CmdletBinding()]
    param()
    
    try {
        $null = winget --version
        return $true
    }
    catch {
        return $false
    }
}

function Install-Winget {
    <#
    .SYNOPSIS
        Install winget (Windows Package Manager)
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`nInstalling winget..." -ForegroundColor Yellow
    Write-Host "This will download and install the App Installer package.`n" -ForegroundColor Gray
    
    try {
        # Download and install App Installer from Microsoft Store
        Write-Host "Opening Microsoft Store to install App Installer..." -ForegroundColor Green
        Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
        
        Write-Host "`nPlease install 'App Installer' from the Microsoft Store." -ForegroundColor Yellow
        Write-Host "After installation, restart this tool.`n" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Install-SingleApp {
    <#
    .SYNOPSIS
        Install a single application
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        
        [Parameter(Mandatory)]
        [string]$Id
    )
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Installing $Name" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "Installing $Name..." -ForegroundColor Yellow
    
    try {
        $result = winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nSuccess: $Name installed successfully" -ForegroundColor Green
        }
        else {
            Write-Host "`nFailed to install $Name" -ForegroundColor Red
            Write-Host "You may need to install it manually or try again." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "`nError installing $Name : $_" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Install-CustomApp {
    <#
    .SYNOPSIS
        Search for and install a custom application
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Search and Install Application" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    $searchTerm = Read-Host "Enter app name to search"
    
    if ([string]::IsNullOrWhiteSpace($searchTerm)) {
        Write-Host "`nNo search term provided." -ForegroundColor Gray
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        return
    }
    
    Write-Host "`nSearching for '$searchTerm'...`n" -ForegroundColor Yellow
    
    try {
        winget search $searchTerm
        
        Write-Host ""
        $appId = Read-Host "Enter the exact App ID to install (or press Enter to cancel)"
        
        if (-not [string]::IsNullOrWhiteSpace($appId)) {
            Write-Host "`nInstalling $appId..." -ForegroundColor Yellow
            winget install --id $appId --exact --accept-package-agreements --accept-source-agreements
        }
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-InstalledApps {
    <#
    .SYNOPSIS
        List all installed applications via winget
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Installed Applications" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "Fetching installed applications...`n" -ForegroundColor Yellow
    
    try {
        winget list
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

#endregion

Export-ModuleMember -Function Invoke-WinSAKAppInstaller
