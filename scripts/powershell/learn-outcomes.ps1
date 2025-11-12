# Learn outcomes script for ACDD (PowerShell)

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

# Check if learning report already exists to avoid overwriting
$LearningFile = Join-Path $FeatureDir "learning-report.md"
if (Test-Path $LearningFile -PathType Leaf) {
    $message = "Learning report already exists at $LearningFile"
    if ($Json) {
        $result = @{
            LEARNING_FILE = $LearningFile
            FEATURE_DIR = $FeatureDir
            FEATURE_NUMBER = $FeatureNumber
            WARNING = "File already exists"
        } | ConvertTo-Json
        Write-Output $result
    } else {
        Write-Output $message
        Write-Output "LEARNING_FILE: $LearningFile"
        Write-Output "FEATURE_DIR: $FeatureDir"
        Write-Output "FEATURE_NUMBER: $FeatureNumber"
    }
    exit 0
}

# Get learn template
$LearnTemplate = Get-TemplateFile -TemplateName "learn-template.md" -RepoRoot $RepoRoot
if (-not $LearnTemplate) {
    if ($Json) {
        $result = @{
            ERROR = "Could not find learn template"
            EXPECTED_PATH = (Join-Path $RepoRoot "templates", "learn-template.md")
        } | ConvertTo-Json
        Write-Output $result
    } else {
        Write-Error "Could not find learn template in templates/learn-template.md"
    }
    exit 1
}

# Create learning report from template
Copy-Item -Path $LearnTemplate -Destination $LearningFile

# Replace placeholders in the learning report file
$Content = Get-Content -Path $LearningFile -Raw
$Content = $Content -replace '\{FEATURE_NAME\}', (Split-Path $FeatureDir -Leaf)
$Content = $Content -replace '\{FEATURE_NUMBER\}', $FeatureNumber
$Content = $Content -replace '\{DATE\}', (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
$Content = $Content -replace '\{AUTHOR\}', $env:USERNAME

Set-Content -Path $LearningFile -Value $Content

# Create learning directory if it doesn't exist
$LearningDir = Join-Path $FeatureDir "learning"
if (-not (Test-Path $LearningDir -PathType Container)) {
    New-Item -ItemType Directory -Path $LearningDir -Force | Out-Null
}

# Set up ACDD-specific learning directories and files for this feature
$AcddFeatureDir = Join-Path $RepoRoot ".acdd", "specs", (Split-Path $FeatureDir -Leaf)
$AcddLearningDir = Join-Path $AcddFeatureDir "learning"
if (-not (Test-Path $AcddLearningDir -PathType Container)) {
    New-Item -ItemType Directory -Path $AcddLearningDir -Force | Out-Null
}

# Output results
if ($Json) {
    $result = @{
        LEARNING_FILE = $LearningFile
        FEATURE_DIR = $FeatureDir
        FEATURE_NUMBER = $FeatureNumber
        STATUS = "CREATED"
    } | ConvertTo-Json
    Write-Output $result
} else {
    Write-Output "LEARNING_FILE: $LearningFile"
    Write-Output "FEATURE_DIR: $FeatureDir"
    Write-Output "FEATURE_NUMBER: $FeatureNumber"
    Write-Output "Status: Learning report created successfully"
}