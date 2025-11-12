#!/usr/bin/env pwsh

# ACDD Adapt Command Script (PowerShell)
# Implements adaptations based on learning outcomes, updates patterns and processes, and evolves the development methodology

param(
    [switch]$Json,
    [switch]$RequireLearn
)

if ($Json) {
    # Detect git branch
    $branch = "main"  # Default fallback
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $branch = $(git branch --show-current 2>$null) -replace '^\*?\s*', ''
            if ([string]::IsNullOrWhiteSpace($branch)) {
                $branch = $(git rev-parse --short HEAD 2>$null)
            }
        } catch {
            # If git command fails, keep default
        }
    }

    # Find the feature directory by looking for spec.md
    $featureDir = $null
    if (Test-Path "features") {
        $featureDirs = Get-ChildItem -Directory -Path "features"
        foreach ($dir in $featureDirs) {
            if (Test-Path "$($dir.FullName)/spec.md") {
                $featureDir = $dir.FullName
                break
            }
        }
    }

    # If no feature directory found, try current directory
    if (-not $featureDir -and (Test-Path "spec.md")) {
        $featureDir = Get-Location
    }

    # Set ADAPT_REPORT path
    $adaptReport = $null
    if ($featureDir) {
        $adaptReport = Join-Path $featureDir "adapt-report.md"

        # Copy adapt template if adapt report doesn't exist
        if (-not (Test-Path $adaptReport)) {
            $templatePaths = @(
                "$(Split-Path $featureDir -Parent)/templates/adapt-template.md",
                "$(Split-Path $(Split-Path $featureDir -Parent) -Parent)/templates/adapt-template.md",
                "./templates/adapt-template.md"
            )
            
            foreach ($templatePath in $templatePaths) {
                if (Test-Path $templatePath) {
                    Copy-Item $templatePath $adaptReport
                    break
                }
            }

            # Replace placeholders in the template if it was copied
            if (Test-Path $adaptReport) {
                # Replace placeholders in the template
                $content = Get-Content $adaptReport -Raw
                $content = $content -replace '\{FEATURE_NAME\}', (Split-Path $featureDir -Leaf)
                $content = $content -replace '\{DATE\}', (Get-Date -Format "yyyy-MM-dd")
                $content = $content -replace '\{FEATURE_NUMBER\}', (Split-Path $featureDir -Leaf | Select-String -Pattern '\d{3}' | ForEach-Object { $_.Matches[0].Value })
                $content = $content -replace '\{AUTHOR\}', $(try { git config user.name 2>$null } catch { "Unknown" })
                Set-Content $adaptReport $content
            }
        }
    }

    # Set pattern library directory
    $patternLibDir = $null
    if (Test-Path "./patterns") {
        $patternLibDir = (Get-Item "./patterns").FullName
    } elseif (Test-Path "./memory/patterns") {
        $patternLibDir = (Get-Item "./memory/patterns").FullName
    } else {
        $patternLibDir = (Get-Item "./memory").FullName
    }

    # Output JSON with the required variables
    $result = @{
        FEATURE_DIR = $featureDir
        ADAPT_REPORT = $adaptReport
        PATTERN_LIB_DIR = $patternLibDir
        BRANCH = $branch
    }
    
    $result | ConvertTo-Json
} else {
    Write-Host "Usage: $MyInvocation.MyCommand.Name -Json [-RequireLearn]"
}