# Adapt methodology script for ACDD (PowerShell)

param(
    [switch]$Json = $false,
    [string]$Feature = $null
)

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

# Dot source the common functions
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
. (Join-Path $ScriptDir "common.ps1")

# Find repository root
$RepoRoot = Find-RepoRoot -StartDir $ScriptDir

if (-not $RepoRoot) {
    if ($Json) {
        Write-Output '{"ERROR":"Could not find repository root"}'
    } else {
        Write-Error "Could not find repository root."
    }
    exit 1
}

# Validate this is an ACDD project
if (-not (Validate-AcddProject -RepoRoot $RepoRoot)) {
    exit 1
}

# Determine feature directory if not provided
if (-not $Feature) {
    $FeatureDir = Get-FeatureDir -RepoRoot $RepoRoot
    if (-not $FeatureDir) {
        if ($Json) {
            Write-Output '{"ERROR":"Could not determine feature directory"}'
        } else {
            Write-Error "Could not determine feature directory. Please specify -Feature or run in a feature directory."
        }
        exit 1
    }
} else {
    # Use provided feature name to construct feature directory path
    $FeatureDir = Join-Path $RepoRoot "specs" $Feature
    if (-not (Test-Path $FeatureDir -PathType Container)) {
        if ($Json) {
            $result = @{
                ERROR = "Feature directory does not exist"
                FEATURE_DIR = $FeatureDir
            } | ConvertTo-Json
            Write-Output $result
        } else {
            Write-Error "Feature directory does not exist: $FeatureDir"
        }
        exit 1
    }
}

# Validate feature directory
if (-not (Validate-FeatureDir -FeatureDir $FeatureDir)) {
    exit 1
}

# Get feature number
$FeatureNumber = Get-FeatureNumber -FeatureDir $FeatureDir
if (-not $FeatureNumber) {
    if ($Json) {
        $result = @{
            ERROR = "Could not extract feature number"
            FEATURE_DIR = $FeatureDir
        } | ConvertTo-Json
        Write-Output $result
    } else {
        Write-Error "Could not extract feature number from directory name: $FeatureDir"
    }
    exit 1
}

# Check if adaptation report already exists to avoid overwriting
$AdaptationFile = Join-Path $FeatureDir "adaptation-report.md"
if (Test-Path $AdaptationFile -PathType Leaf) {
    $message = "Adaptation report already exists at $AdaptationFile"
    if ($Json) {
        $result = @{
            ADAPTATION_FILE = $AdaptationFile
            FEATURE_DIR = $FeatureDir
            FEATURE_NUMBER = $FeatureNumber
            WARNING = "File already exists"
        } | ConvertTo-Json
        Write-Output $result
    } else {
        Write-Output $message
        Write-Output "ADAPTATION_FILE: $AdaptationFile"
        Write-Output "FEATURE_DIR: $FeatureDir"
        Write-Output "FEATURE_NUMBER: $FeatureNumber"
    }
    exit 0
}

# Get adapt template
$AdaptTemplate = Get-TemplateFile -TemplateName "adapt-template.md" -RepoRoot $RepoRoot
if (-not $AdaptTemplate) {
    if ($Json) {
        $result = @{
            ERROR = "Could not find adapt template"
            EXPECTED_PATH = (Join-Path $RepoRoot "templates", "adapt-template.md")
        } | ConvertTo-Json
        Write-Output $result
    } else {
        Write-Error "Could not find adapt template in templates/adapt-template.md"
    }
    exit 1
}

# Create adaptation report from template
Copy-Item -Path $AdaptTemplate -Destination $AdaptationFile

# Replace placeholders in the adaptation report file
$Content = Get-Content -Path $AdaptationFile -Raw
$Content = $Content -replace '\{FEATURE_NAME\}', (Split-Path $FeatureDir -Leaf)
$Content = $Content -replace '\{FEATURE_NUMBER\}', $FeatureNumber
$Content = $Content -replace '\{DATE\}', (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
$Content = $Content -replace '\{AUTHOR\}', $env:USERNAME

Set-Content -Path $AdaptationFile -Value $Content

# Create adaptation directory if it doesn't exist
$AdaptationDir = Join-Path $FeatureDir "adaptation"
if (-not (Test-Path $AdaptationDir -PathType Container)) {
    New-Item -ItemType Directory -Path $AdaptationDir -Force | Out-Null
}

# Set up ACDD-specific adaptation directories and files for this feature
$AcddFeatureDir = Join-Path $RepoRoot ".acdd", "specs", (Split-Path $FeatureDir -Leaf)
$AcddAdaptationDir = Join-Path $AcddFeatureDir "adaptation"
if (-not (Test-Path $AcddAdaptationDir -PathType Container)) {
    New-Item -ItemType Directory -Path $AcddAdaptationDir -Force | Out-Null
}

# Update global ACDD context based on adaptation
$AcddContextDir = Join-Path $RepoRoot ".acdd", "context"
if (Test-Path $AcddContextDir -PathType Container) {
    # Update pattern library with adaptation insights
    $PatternLibFile = Join-Path $AcddContextDir "team-patterns.md"
    if (Test-Path $PatternLibFile -PathType Leaf) {
        # Add a timestamp to the patterns file to indicate an adaptation has occurred
        $timestamp = "`n---`n**Last Adaptation Update**: " + (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") + "`n"
        Add-Content -Path $PatternLibFile -Value $timestamp
    }
}

# Output results
if ($Json) {
    $result = @{
        ADAPTATION_FILE = $AdaptationFile
        FEATURE_DIR = $FeatureDir
        FEATURE_NUMBER = $FeatureNumber
        STATUS = "CREATED"
    } | ConvertTo-Json
    Write-Output $result
} else {
    Write-Output "ADAPTATION_FILE: $AdaptationFile"
    Write-Output "FEATURE_DIR: $FeatureDir"
    Write-Output "FEATURE_NUMBER: $FeatureNumber"
    Write-Output "Status: Adaptation report created successfully"
}