# ACDD (Adaptive Context-Driven Development) Validation Script
# Provides validation for ACDD-specific requirements and context tracking

param(
    [string]$FeatureDir = "",
    [switch]$Json = $false,
    [switch]$Help = $false
)

if ($Help) {
    Write-Host "ACDD Validation Script"
    Write-Host "Usage: $MyInvocation.MyCommand.Name [OPTIONS]"
    Write-Host "Options:"
    Write-Host "  -FeatureDir DIR  Feature directory to validate"
    Write-Host "  -Json            Output in JSON format"
    Write-Host "  -Help            Show this help message"
    exit 0
}

# Function to output JSON or regular format
function Output-Message {
    param(
        [string]$Type,
        [string]$File,
        [string]$Message,
        [string]$RegularMessage
    )
    
    if ($Json) {
        $output = @{
            type = $Type
            file = $File
            message = $Message
        } | ConvertTo-Json -Compress
        Write-Output $output
    } else {
        Write-Output $RegularMessage
    }
}

# Function to log messages
function Write-Log {
    param(
        [string]$Level,
        [string]$Message
    )
    
    if ($Json) {
        $log = @{
            level = $Level
            message = $Message
        } | ConvertTo-Json -Compress
        Write-Error $log -ErrorAction Continue
    } else {
        switch ($Level) {
            "ERROR" { Write-Host "[ERROR] $Message" -ForegroundColor Red }
            "WARN" { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
            "INFO" { Write-Host "[INFO] $Message" -ForegroundColor Blue }
            "SUCCESS" { Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
        }
    }
}

# Function to validate ACDD-specific requirements
function Validate-ACDDRequirements {
    param([string]$FeatureDir)
    
    $errors = 0
    $warnings = 0
    
    # Check if required ACDD files exist
    $contextMapPath = Join-Path $FeatureDir "context-map.md"
    if (-not (Test-Path $contextMapPath)) {
        $errors++
        Output-Message -Type "error" -File "context-map.md" -Message "ACDD context map file not found" -RegularMessage "Context map file (context-map.md) not found in feature directory"
    } else {
        Output-Message -Type "success" -File "context-map.md" -Message "ACDD context map file found" -RegularMessage "✓ Context map file found"
    }
    
    # Check for context evolution tracking
    $contextDir1 = Join-Path (Split-Path $FeatureDir -Parent) "memory/context"
    $contextDir2 = Join-Path $FeatureDir "memory/context"
    if ((Test-Path $contextDir1) -or (Test-Path $contextDir2)) {
        Output-Message -Type "success" -File "context/memory" -Message "Context evolution tracking directory found" -RegularMessage "✓ Context evolution tracking directory found"
    } else {
        $warnings++
        Output-Message -Type "warning" -File "context/memory" -Message "Context evolution tracking directory not found" -RegularMessage "⚠ Context evolution tracking directory not found (optional for ACDD)"
    }
    
    # Check for pattern compliance validation
    $constitutionPath1 = Join-Path (Split-Path $FeatureDir -Parent) "memory/constitution.md"
    $constitutionPath2 = Join-Path $FeatureDir "memory/constitution.md"
    if ((Test-Path $constitutionPath1) -or (Test-Path $constitutionPath2)) {
        Output-Message -Type "success" -File "constitution.md" -Message "Constitutional principles file found" -RegularMessage "✓ Constitutional principles file found"
    } else {
        $warnings++
        Output-Message -Type "warning" -File "constitution.md" -Message "Constitutional principles file not found" -RegularMessage "⚠ Constitutional principles file not found (required for ACDD pattern compliance)"
    }
    
    # Check for ACDD-specific context tags in tasks if they exist
    $tasksPath = Join-Path $FeatureDir "tasks.md"
    if (Test-Path $tasksPath) {
        $content = Get-Content $tasksPath -Raw
        
        $ctxInitCount = [regex]::Matches($content, '\[CTX-INIT\]').Count
        $ctxLearnCount = [regex]::Matches($content, '\[CTX-LEARN\]').Count
        $ctxAdaptCount = [regex]::Matches($content, '\[CTX-ADAPT\]').Count
        $ctxValidateCount = [regex]::Matches($content, '\[CTX-VALIDATE\]').Count
        
        if ($ctxInitCount -gt 0 -or $ctxLearnCount -gt 0 -or $ctxAdaptCount -gt 0 -or $ctxValidateCount -gt 0) {
            Output-Message -Type "success" -File "tasks.md" -Message "ACDD context tags found in tasks" -RegularMessage "✓ ACDD context tags found in tasks file"
        } else {
            $warnings++
            Output-Message -Type "warning" -File "tasks.md" -Message "No ACDD context tags found in tasks" -RegularMessage "⚠ No ACDD context tags found in tasks file (should include [CTX-INIT], [CTX-LEARN], [CTX-ADAPT], [CTX-VALIDATE])"
        }
    }
    
    if ($Json) {
        $result = @{
            feature_dir = $FeatureDir
            validation_results = @()
            total_errors = $errors
            total_warnings = $warnings
        } | ConvertTo-Json
        Write-Output $result
    } else {
        Write-Host ""
        Write-Host "ACDD Validation Summary:" -ForegroundColor Blue
        Write-Host "Errors: $errors"
        Write-Host "Warnings: $warnings"
        
        if ($errors -eq 0) {
            Write-Host "✓ ACDD validation passed" -ForegroundColor Green
            return $true
        } else {
            Write-Host "✗ ACDD validation failed" -ForegroundColor Red
            return $false
        }
    }
    
    return ($errors -eq 0)
}

# Main execution
if ([string]::IsNullOrEmpty($FeatureDir)) {
    # Try to detect feature directory from current context
    if (Test-Path "specs") {
        $latestSpecDir = Get-ChildItem -Path "specs" -Directory | 
                        Sort-Object CreationTime -Descending | 
                        Select-Object -First 1 -ExpandProperty FullName
        if ($latestSpecDir) {
            $FeatureDir = $latestSpecDir
        }
    }
}

if ([string]::IsNullOrEmpty($FeatureDir)) {
    Write-Log -Level "ERROR" -Message "No feature directory specified and none could be detected"
    exit 1
}

if (-not (Test-Path $FeatureDir)) {
    Write-Log -Level "ERROR" -Message "Feature directory does not exist: $FeatureDir"
    exit 1
}

Write-Log -Level "INFO" -Message "Validating ACDD requirements for feature directory: $FeatureDir"

$result = Validate-ACDDRequirements -FeatureDir $FeatureDir

if ($result) {
    exit 0
} else {
    exit 1
}