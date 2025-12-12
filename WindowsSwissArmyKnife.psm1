#Requires -Version 5.1

<#
.SYNOPSIS
    Windows Swiss Army Knife - A comprehensive PowerShell utility toolkit
.DESCRIPTION
    A collection of useful Windows utilities, scripts, and tools compiled into one modular PowerShell module.
    Designed to be extensible and easy to maintain.
.NOTES
    Author: TheNormalRat
    Version: v0.1.0
    Created: December 11, 2025
#>

# Module Variables
$Script:ModuleRoot = $PSScriptRoot
$Script:UtilitiesPath = Join-Path $ModuleRoot "Utilities"

# Import all utility modules
if (Test-Path $UtilitiesPath) {
    Get-ChildItem -Path $UtilitiesPath -Filter "*.ps1" -Recurse | ForEach-Object {
        Write-Verbose "Loading utility: $($_.Name)"
        . $_.FullName
    }
}

# Export is handled automatically by Export-ModuleMember in each utility file
