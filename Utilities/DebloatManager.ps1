#region Debloat Manager Utilities

function Invoke-WinSAKDebloatManager {
    <#
    .SYNOPSIS
        Manage Win11Debloat installation and execution
    .DESCRIPTION
        Downloads, runs, updates, or uninstalls the Win11Debloat tool by Raphire
    .EXAMPLE
        Invoke-WinSAKDebloatManager
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Win11Debloat Manager - by Raphire" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    # Check if Win11Debloat is already downloaded
    $debloatPath = "$env:TEMP\Win11Debloat"
    $debloatScript = "$debloatPath\Win11Debloat.ps1"
    
    if (Test-Path $debloatScript) {
        Show-DebloatInstalledMenu -DebloatPath $debloatPath -DebloatScript $debloatScript
    }
    else {
        Show-DebloatNotInstalledMenu
    }
}

function Show-DebloatInstalledMenu {
    <#
    .SYNOPSIS
        Show menu when Win11Debloat is already installed
    #>
    [CmdletBinding()]
    param(
        [string]$DebloatPath,
        [string]$DebloatScript
    )
    
    Write-Host "Win11Debloat is already downloaded." -ForegroundColor Green
    Write-Host "Location: $DebloatPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "What would you like to do?" -ForegroundColor Yellow
    Write-Host "  [1] Run Win11Debloat" -ForegroundColor White
    Write-Host "  [2] Update Win11Debloat (download latest version)" -ForegroundColor White
    Write-Host "  [3] Uninstall Win11Debloat (remove downloaded files)" -ForegroundColor White
    Write-Host "  [0] Cancel" -ForegroundColor Red
    Write-Host ""
    
    $debloatChoice = Read-Host "Enter your choice"
    
    switch ($debloatChoice) {
        "1" {
            Start-DebloatTool -DebloatScript $DebloatScript
        }
        "2" {
            Update-DebloatTool -DebloatPath $DebloatPath
        }
        "3" {
            Uninstall-DebloatTool -DebloatPath $DebloatPath
        }
    }
}

function Show-DebloatNotInstalledMenu {
    <#
    .SYNOPSIS
        Show menu when Win11Debloat is not installed
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "Win11Debloat is not currently downloaded." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Win11Debloat is github project by Raphire, it is a powerful tool that can:" -ForegroundColor Gray
    Write-Host "  - Remove bloatware and pre-installed apps" -ForegroundColor Gray
    Write-Host "  - Disable telemetry and tracking" -ForegroundColor Gray
    Write-Host "  - Customize Windows interface" -ForegroundColor Gray
    Write-Host "  - Apply privacy and performance tweaks" -ForegroundColor Gray
    Write-Host ""
    
    $installChoice = Read-Host "Would you like to download and run Win11Debloat? (y/n)"
    
    if ($installChoice -eq 'y') {
        Install-DebloatTool
    }
    else {
        Write-Host "`nDownload cancelled." -ForegroundColor Gray
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Start-DebloatTool {
    <#
    .SYNOPSIS
        Run the Win11Debloat tool
    #>
    [CmdletBinding()]
    param(
        [string]$DebloatScript
    )
    
    Write-Host "`nLaunching Win11Debloat...`n" -ForegroundColor Green
    
    try {
        & "$DebloatScript"
    }
    catch {
        Write-Host "`nError running Win11Debloat: $_" -ForegroundColor Red
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Install-DebloatTool {
    <#
    .SYNOPSIS
        Download and install Win11Debloat
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`nDownloading Win11Debloat by Raphire..." -ForegroundColor Green
    Write-Host "Source: https://github.com/Raphire/Win11Debloat`n" -ForegroundColor Gray
    
    try {
        Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Raphire/Win11Debloat/master/Get.ps1")
    }
    catch {
        Write-Host "`nError downloading Win11Debloat: $_" -ForegroundColor Red
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Update-DebloatTool {
    <#
    .SYNOPSIS
        Update Win11Debloat to the latest version
    #>
    [CmdletBinding()]
    param(
        [string]$DebloatPath
    )
    
    Write-Host "`nUpdating Win11Debloat..." -ForegroundColor Yellow
    Write-Host "Removing old version..." -ForegroundColor Gray
    
    # Keep CustomAppsList and SavedSettings
    $customApps = "$DebloatPath\CustomAppsList"
    $savedSettings = "$DebloatPath\SavedSettings"
    $tempCustomApps = "$env:TEMP\CustomAppsList.bak"
    $tempSavedSettings = "$env:TEMP\SavedSettings.bak"
    
    if (Test-Path $customApps) {
        Copy-Item $customApps $tempCustomApps -Force
    }
    if (Test-Path $savedSettings) {
        Copy-Item $savedSettings $tempSavedSettings -Force
    }
    
    Remove-Item -Path $DebloatPath -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "Downloading latest version...`n" -ForegroundColor Gray
    
    try {
        Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Raphire/Win11Debloat/master/Get.ps1")
        
        # Restore backed up files
        if (Test-Path $tempCustomApps) {
            Copy-Item $tempCustomApps "$DebloatPath\CustomAppsList" -Force
            Remove-Item $tempCustomApps -Force
        }
        if (Test-Path $tempSavedSettings) {
            Copy-Item $tempSavedSettings "$DebloatPath\SavedSettings" -Force
            Remove-Item $tempSavedSettings -Force
        }
        
        Write-Host "`nWin11Debloat updated successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "`nError updating Win11Debloat: $_" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Uninstall-DebloatTool {
    <#
    .SYNOPSIS
        Uninstall Win11Debloat
    #>
    [CmdletBinding()]
    param(
        [string]$DebloatPath
    )
    
    Write-Host "`nAre you sure you want to uninstall Win11Debloat?" -ForegroundColor Yellow
    Write-Host "This will remove all downloaded files including saved settings." -ForegroundColor Gray
    $confirm = Read-Host "Type 'yes' to confirm"
    
    if ($confirm -eq 'yes') {
        Write-Host "`nRemoving Win11Debloat..." -ForegroundColor Yellow
        Remove-Item -Path $DebloatPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Win11Debloat has been removed." -ForegroundColor Green
    }
    else {
        Write-Host "`nUninstall cancelled." -ForegroundColor Gray
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

#endregion

Export-ModuleMember -Function Invoke-WinSAKDebloatManager
