# Common functions for ACDD PowerShell scripts

# Function to find the repository root by searching for .acdd directory
function Find-RepoRoot {
    param([string]$StartDir = (Get-Location).Path)
    
    $dir = $StartDir
    while ($dir -ne [System.IO.Path]::GetPathRoot($dir)) {
        if (Test-Path (Join-Path $dir ".acdd") -PathType Container) {
            return $dir
        }
        $dir = Split-Path $dir -Parent
    }
    return $null
}

# Function to get current feature directory based on directory structure
function Get-FeatureDir {
    param([string]$RepoRoot)
    
    $CurrentPath = (Get-Location).Path
    
    # Fallback: look for directory with numeric prefix in current path
    $tempPath = $CurrentPath
    while ($tempPath -ne [System.IO.Path]::GetPathRoot($tempPath)) {
        $basename = Split-Path $tempPath -Leaf
        if ($basename -match '^[0-9]{3,}-') {
            $specPath = Join-Path $tempPath "spec.md"
            $planPath = Join-Path $tempPath "plan.md"
            if (Test-Path $specPath -or Test-Path $planPath) {
                return $tempPath
            }
        }
        $tempPath = Split-Path $tempPath -Parent
    }
    
    # Check if we're in a feature directory under specs/
    $specsDir = Join-Path $RepoRoot "specs"
    if ($CurrentPath.StartsWith($specsDir)) {
        $relativePath = Resolve-Path -Path $CurrentPath -Relative
        if ($relativePath -match "^specs[\\/]([0-9]{3,}-[^\\/]+)") {
            $featurePart = $matches[1]
            $featurePath = Join-Path $specsDir $featurePart
            if (Test-Path $featurePath -PathType Container) {
                return $featurePath
            }
        }
    }
    
    return $null
}

# Function to get the feature number from a feature directory name
function Get-FeatureNumber {
    param([string]$FeatureDir)
    
    $basename = Split-Path $FeatureDir -Leaf
    if ($basename -match '^([0-9]+)-') {
        return $matches[1]
    }
    return $null
}

# Function to get template file with proper path resolution
function Get-TemplateFile {
    param([string]$TemplateName, [string]$RepoRoot)
    
    $templatePath = Join-Path $RepoRoot "templates" $TemplateName
    if (Test-Path $templatePath -PathType Leaf) {
        return $templatePath
    }
    return $null
}

# Function to validate if we're in a valid ACDD project
function Validate-AcddProject {
    param([string]$RepoRoot)
    
    if (-not (Test-Path (Join-Path $RepoRoot ".acdd") -PathType Container)) {
        Write-Error "Not in a valid ACDD project. Missing .acdd directory."
        return $false
    }
    
    return $true
}

# Function to validate if we're in a valid feature directory
function Validate-FeatureDir {
    param([string]$FeatureDir)
    
    if (-not (Test-Path $FeatureDir -PathType Container)) {
        Write-Error "Feature directory does not exist: $FeatureDir"
        return $false
    }
    
    return $true
}