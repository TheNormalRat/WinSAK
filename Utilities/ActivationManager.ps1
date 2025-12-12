#region Activation Manager Utilities

function Invoke-WinSAKActivationManager {
    <#
    .SYNOPSIS
        Manage Windows and Office activation using Microsoft Activation Scripts
    .DESCRIPTION
        Runs the Microsoft Activation Scripts (MAS) by massgravel for activating Windows and Office
    .EXAMPLE
        Invoke-WinSAKActivationManager
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Windows Activation Manager" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "Microsoft Activation Scripts (MAS)" -ForegroundColor Yellow
    Write-Host "Source: https://github.com/massgravel/Microsoft-Activation-Scripts" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "What would you like to do?" -ForegroundColor Yellow
    Write-Host "  [1] Check Windows Activation Status" -ForegroundColor White
    Write-Host "  [2] Launch MAS Tool (Activate Windows/Office)" -ForegroundColor White
    Write-Host "  [0] Back to Main Menu" -ForegroundColor Red
    Write-Host ""
    
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        "1" {
            Show-ActivationStatus
        }
        "2" {
            Invoke-MASFullTool
        }
    }
}

function Show-ActivationStatus {
    <#
    .SYNOPSIS
        Display Windows activation status
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Windows Activation Status" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    try {
        # Get Windows license status
        $licenseStatus = Get-CimInstance -ClassName SoftwareLicensingProduct | 
            Where-Object { $_.PartialProductKey -and $_.Name -like "Windows*" } |
            Select-Object -First 1
        
        if ($licenseStatus) {
            Write-Host "Product: " -ForegroundColor Yellow -NoNewline
            Write-Host $licenseStatus.Name
            
            Write-Host "License Status: " -ForegroundColor Yellow -NoNewline
            switch ($licenseStatus.LicenseStatus) {
                0 { Write-Host "Unlicensed" -ForegroundColor Red }
                1 { Write-Host "Licensed (Activated)" -ForegroundColor Green }
                2 { Write-Host "OOB Grace" -ForegroundColor Yellow }
                3 { Write-Host "OOT Grace" -ForegroundColor Yellow }
                4 { Write-Host "Non-Genuine Grace" -ForegroundColor Red }
                5 { Write-Host "Notification" -ForegroundColor Yellow }
                6 { Write-Host "Extended Grace" -ForegroundColor Yellow }
                default { Write-Host "Unknown" -ForegroundColor Gray }
            }
            
            if ($licenseStatus.PartialProductKey) {
                Write-Host "Product Key (Last 5): " -ForegroundColor Yellow -NoNewline
                Write-Host $licenseStatus.PartialProductKey
            }
        }
        
        Write-Host ""
        Write-Host "Running detailed check..." -ForegroundColor Gray
        Start-Process "slmgr.vbs" -ArgumentList "/xpr" -Wait
    }
    catch {
        Write-Host "Error checking activation status: $_" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Invoke-WindowsActivation {
    <#
    .SYNOPSIS
        Activate Windows using Microsoft Activation Scripts
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Activate Windows" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "This will launch Microsoft Activation Scripts (MAS)" -ForegroundColor Yellow
    Write-Host "to activate your Windows installation.`n" -ForegroundColor Gray
    
    $confirm = Read-Host "Continue? (y/n)"
    
    if ($confirm -eq 'y') {
        Write-Host "`nLaunching MAS for Windows activation...`n" -ForegroundColor Green
        
        try {
            irm https://get.activated.win | iex
        }
        catch {
            Write-Host "`nError launching activation script: $_" -ForegroundColor Red
            Write-Host "`nPress any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
    else {
        Write-Host "`nActivation cancelled." -ForegroundColor Gray
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Invoke-OfficeActivation {
    <#
    .SYNOPSIS
        Activate Office using Microsoft Activation Scripts
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Activate Office" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "This will launch Microsoft Activation Scripts (MAS)" -ForegroundColor Yellow
    Write-Host "to activate your Microsoft Office installation.`n" -ForegroundColor Gray
    
    $confirm = Read-Host "Continue? (y/n)"
    
    if ($confirm -eq 'y') {
        Write-Host "`nLaunching MAS for Office activation...`n" -ForegroundColor Green
        
        try {
            irm https://get.activated.win | iex
        }
        catch {
            Write-Host "`nError launching activation script: $_" -ForegroundColor Red
            Write-Host "`nPress any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
    else {
        Write-Host "`nActivation cancelled." -ForegroundColor Gray
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Invoke-MASFullTool {
    <#
    .SYNOPSIS
        Launch the full Microsoft Activation Scripts tool with all options
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Microsoft Activation Scripts - Full Tool" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "This will launch the complete MAS interface with all" -ForegroundColor Yellow
    Write-Host "activation methods and options available.`n" -ForegroundColor Gray
    
    Write-Host "Available methods:" -ForegroundColor Gray
    Write-Host "  - HWID (Digital License) Activation" -ForegroundColor Gray
    Write-Host "  - KMS38 Activation" -ForegroundColor Gray
    Write-Host "  - Online KMS Activation" -ForegroundColor Gray
    Write-Host "  - Office Activation" -ForegroundColor Gray
    Write-Host "  - Troubleshooting Tools`n" -ForegroundColor Gray
    
    $confirm = Read-Host "Launch MAS? (y/n)"
    
    if ($confirm -eq 'y') {
        Write-Host "`nLaunching Microsoft Activation Scripts...`n" -ForegroundColor Green
        
        try {
            irm https://get.activated.win | iex
        }
        catch {
            Write-Host "`nError launching MAS: $_" -ForegroundColor Red
            Write-Host "`nPress any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
    else {
        Write-Host "`nLaunch cancelled." -ForegroundColor Gray
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

#endregion

Export-ModuleMember -Function Invoke-WinSAKActivationManager
