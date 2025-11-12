# ACDD Learn Command Script (PowerShell)
# Generates learning report from completed features, analyzes pattern effectiveness, and prepares adaptation inputs

param(
    [switch]$Json,
    [switch]$Help
)

if ($Help) {
    Write-Output "Usage: acdd-learn.ps1 -Json"
    Write-Output "Generates learning report from completed features, analyzes pattern effectiveness, and prepares adaptation inputs"
    exit 0
}

if ($Json) {
    # Detect git branch
    $branch = "main"  # Default fallback
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $gitDir = git rev-parse --git-dir 2>$null
            if ($LASTEXITCODE -eq 0) {
                $branch = git branch --show-current 2>$null
                if ([string]::IsNullOrEmpty($branch)) {
                    # Use commit hash if detached HEAD
                    $branch = git rev-parse --short HEAD 2>$null
                }
            }
        }
        catch {
            # If git command fails, keep default branch
        }
    }

    # Find the feature directory by looking for spec.md
    $featureDir = $null
    $featuresDirs = Get-ChildItem -Directory -Path "features" -ErrorAction SilentlyContinue
    if ($featuresDirs) {
        foreach ($dir in $featuresDirs) {
            if (Test-Path "$($dir.FullName)\spec.md") {
                $featureDir = $dir.FullName
                break
            }
        }
    }

    # If no feature directory found, try current directory
    if (-not $featureDir -and (Test-Path "spec.md")) {
        $featureDir = (Get-Location).Path
    }

    # Set LEARN_REPORT path
    $learnReport = ""
    if ($featureDir) {
        $learnReport = Join-Path $featureDir "learn-report.md"
        
        # Copy learn template if learn report doesn't exist
        if (-not (Test-Path $learnReport)) {
            $templatePath = Join-Path $featureDir "..\templates\learn-template.md"
            if (-not (Test-Path $templatePath)) {
                $templatePath = Join-Path $featureDir "..\..\templates\learn-template.md"
            }
            if (-not (Test-Path $templatePath)) {
                $templatePath = Join-Path (Get-Location).Path "templates\learn-template.md"
            }
            
            if (Test-Path $templatePath) {
                Copy-Item $templatePath $learnReport
                
                # Replace placeholders in the template
                $content = Get-Content $learnReport -Raw
                $content = $content -replace '\{FEATURE_NAME\}', (Split-Path $featureDir -Leaf)
                $content = $content -replace '\{DATE\}', (Get-Date -Format "yyyy-MM-dd")
                $content = $content -replace '\{FEATURE_NUMBER\}', [regex]::Match((Split-Path $featureDir -Leaf), '\d+').Value
                $content = $content -replace '\{AUTHOR\}', $(try { git config user.name } catch { $env:USERNAME })
                
                Set-Content -Path $learnReport -Value $content
            }
        }
    }

    # Set pattern library directory
    $patternLibDir = ""
    if (Test-Path ".\patterns") {
        $patternLibDir = (Get-Item ".\patterns").FullName
    }
    elseif (Test-Path ".\memory\patterns") {
        $patternLibDir = (Get-Item ".\memory\patterns").FullName
    }
    else {
        $patternLibDir = (Get-Item ".\memory").FullName
    }

    # Output JSON with the required variables
    $output = @{
        FEATURE_DIR = $featureDir
        LEARN_REPORT = $learnReport
        PATTERN_LIB_DIR = $patternLibDir
        BRANCH = $branch
    } | ConvertTo-Json -Compress

    Write-Output $output
}
else {
    Write-Output "Usage: acdd-learn.ps1 -Json"
    exit 1
}