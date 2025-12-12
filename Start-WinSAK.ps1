<#
.SYNOPSIS
    Windows Swiss Army Knife - Interactive Menu System
.DESCRIPTION
    A comprehensive Windows utility toolkit with an easy-to-use menu interface
.NOTES
    Author: BarnumK
    Version: 1.0.0
#>

# Set script location
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

function Show-MainMenu {
    Clear-Host
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "          WINDOWS SWISS ARMY KNIFE - MAIN MENU                 " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "  [1] " -ForegroundColor Yellow -NoNewline
    Write-Host "System Information & Diagnostics"
    
    Write-Host "  [2] " -ForegroundColor Yellow -NoNewline
    Write-Host "Windows Activation Tools"
    
    Write-Host "  [3] " -ForegroundColor Yellow -NoNewline
    Write-Host "Windows Debloat Manager"
    
    Write-Host "  [4] " -ForegroundColor Yellow -NoNewline
    Write-Host "Install Applications"
    
    Write-Host "  [0] " -ForegroundColor Red -NoNewline
    Write-Host "Exit"
    
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-SystemInfoMenu {
    Clear-Host
    Write-Host ""
    Write-Host "==================== SYSTEM INFORMATION =======================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "  [1] " -ForegroundColor Yellow -NoNewline
    Write-Host "View System Information"
    
    Write-Host "  [2] " -ForegroundColor Yellow -NoNewline
    Write-Host "View Installed Software"
    
    Write-Host "  [3] " -ForegroundColor Yellow -NoNewline
    Write-Host "Check Disk Space"
    
    Write-Host "  [4] " -ForegroundColor Yellow -NoNewline
    Write-Host "View Top Processes (CPU)"
    
    Write-Host "  [5] " -ForegroundColor Yellow -NoNewline
    Write-Host "View Top Processes (Memory)"
    
    Write-Host "  [0] " -ForegroundColor Red -NoNewline
    Write-Host "Back to Main Menu"
    
    Write-Host ""
    Write-Host "===============================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Import the module
$ModulePath = Join-Path $ScriptPath "WindowsSwissArmyKnife.psm1"
if (Test-Path $ModulePath) {
    Import-Module $ModulePath -Force -Verbose:$false -ErrorAction SilentlyContinue
}

# Main program loop
do {
    Show-MainMenu
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        "1" {
            do {
                Show-SystemInfoMenu
                $subChoice = Read-Host "Enter your choice"
                
                switch ($subChoice) {
                    "1" {
                        Write-Host "`nFetching system information...`n" -ForegroundColor Green
                        Get-WinSAKSystemInfo -Detailed | Format-List
                        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
                        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    }
                    "2" {
                        Write-Host "`nFetching installed software...`n" -ForegroundColor Green
                        Get-WinSAKInstalledSoftware | Format-Table -AutoSize
                        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
                        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    }
                    "3" {
                        Write-Host "`nChecking disk space...`n" -ForegroundColor Green
                        Get-WinSAKDiskSpace | Format-Table -AutoSize
                        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
                        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    }
                    "4" {
                        Write-Host "`nTop CPU processes...`n" -ForegroundColor Green
                        Get-WinSAKTopProcesses -SortBy CPU -Top 15 | Format-Table -AutoSize
                        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
                        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    }
                    "5" {
                        Write-Host "`nTop Memory processes...`n" -ForegroundColor Green
                        Get-WinSAKTopProcesses -SortBy Memory -Top 15 | Format-Table -AutoSize
                        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
                        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    }
                }
            } while ($subChoice -ne "0")
        }
        "2" {
            Invoke-WinSAKActivationManager
        }
        "3" {
            Invoke-WinSAKDebloatManager
        }
        "4" {
            Invoke-WinSAKAppInstaller
        }
    }
    
} while ($choice -ne "0")

Write-Host "`nThank you for using Windows Swiss Army Knife!`n" -ForegroundColor Cyan
