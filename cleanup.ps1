<#
.SYNOPSIS
Remove common R package build artifacts from the FaultTree repo.

.DESCRIPTION
This script removes generated files that should not be committed to the repository,
including compiled objects, temporary Rcheck directories, generated tarballs, and
other build artifacts.

.EXAMPLE
.\cleanup.ps1 -WhatIf
.\cleanup.ps1
.\cleanup.ps1 -RemoveTarballs -RemoveRcheck
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [switch]$RemoveTarballs,
    [switch]$RemoveRcheck
)

$root = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
Set-Location $root

$paths = @(
    "src\*.o",
    "src\*.obj",
    "src\*.dll",
    "src\*.rds",
    "R\.Rhistory",
    "*.html",
    "*~"
)

if ($RemoveTarballs) {
    $paths += @("*.tar.gz", "*.tgz", "*.zip")
}

if ($RemoveRcheck) {
    $paths += "..Rcheck"
}

Write-Host "Cleaning repository build artifacts from: $root"

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "Removing: $path"
        if ($PSCmdlet.ShouldProcess($path, 'Remove')) {
            Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "Cleanup complete."
