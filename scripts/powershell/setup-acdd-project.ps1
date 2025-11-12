# Setup ACDD project script for PowerShell

param(
    [switch]$Json = $false,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$ProjectDescription = @()
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

# Find repository root
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$RepoRoot = Find-RepoRoot -StartDir $ScriptDir

if (-not $RepoRoot) {
    if ($Json) {
        Write-Output '{"ERROR":"Could not find repository root"}'
    } else {
        Write-Error "Could not find repository root."
    }
    exit 1
}

# Check if this is already an ACDD project
$AcdDir = Join-Path $RepoRoot ".acdd"
if (Test-Path $AcdDir -PathType Container) {
    if ($Json) {
        $result = @{
            ERROR = "Already an ACDD project"
            PROJECT_PATH = $RepoRoot
        } | ConvertTo-Json
        Write-Output $result
    } else {
        Write-Error "This is already an ACDD project."
    }
    exit 1
}

# Create ACDD directory structure
New-Item -ItemType Directory -Path $AcdDir -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $AcdDir "context") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $AcdDir "memory") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $AcdDir "specs") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $AcdDir "context", "metrics") -Force | Out-Null

# Create initial context files
$TeamPatternsContent = @"
# Team Pattern Library

> A living record of proven, repeatable approaches to solving problems in our team.
> Patterns evolve as we learn what works.

## How to Use This Library

1. **Finding Patterns**: Look for patterns matching your use case
2. **Understanding Impact**: Check velocity/quality metrics for evidence
3. **Applying Patterns**: Reference the example code and follow the approach
4. **Suggesting Updates**: Document deviations and suggest improvements via Learning phase

## Patterns

*(None yet - create your first pattern via ACDD commands)*

---
**Last Updated**: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
"@

$TeamPatternsPath = Join-Path $AcdDir "context", "team-patterns.md"
Set-Content -Path $TeamPatternsPath -Value $TeamPatternsContent

$ArchEvolutionContent = @"
# Architecture Evolution Map

> Timeline of architectural decisions and their outcomes.
> Shows how our architecture evolved and why each decision was made.

## How to Use This Map

- **Understanding**: See why each architectural decision was made
- **Evolution**: Understand the progression and constraints
- **Decisions**: Prepare for next evolution by learning from past outcomes

## Decisions

*(None yet - document decisions during the Specify phase)*

---
**Last Updated**: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
"@

$ArchEvolutionPath = Join-Path $AcdDir "context", "architecture-evolution.md"
Set-Content -Path $ArchEvolutionPath -Value $ArchEvolutionContent

# Create initial constitution file if it doesn't exist
$ConstitutionFile = Join-Path $RepoRoot "constitution.md"
if (-not (Test-Path $ConstitutionFile)) {
    $ProjectDescStr = $ProjectDescription -join " "
    
    $ConstitutionContent = @"
# Project Constitution

**Project**: ${ProjectDescStr}
**Date**: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
**Status**: Initial

## Purpose

This project follows the **Adaptive Context-Driven Development (ACDD)** methodology, an evolution of Spec-Driven Development that incorporates continuous learning and adaptation.

## Core Principles

### Living Context Model
- Context is multidimensional and evolving, not static
- Team patterns, architecture decisions, metrics, and preferences are continuously updated
- Knowledge from past features directly improves future development

### Continuous Learning
- Every feature contributes to organizational learning
- Outcomes are systematically analyzed and documented
- Pattern effectiveness is continuously measured

### Adaptive Methodology
- Development approach evolves based on evidence
- Patterns are refined and updated based on usage outcomes
- Team capabilities and preferences are tracked and leveraged

## Development Workflow

The complete ACDD workflow consists of 9 phases:

1. **Constitution** - Establish project principles and context
2. **Specify** - Define requirements with context awareness 
3. **Clarify** - Resolve specification ambiguities
4. **Plan** - Create implementation plan referencing patterns
5. **Analyze** - Cross-artifact consistency check
6. **Tasks** - Break plan into actionable tasks
7. **Implement** - Execute implementation
8. **Learn** - Analyze outcomes and capture learnings
9. **Adapt** - Update patterns and methodology

"@
    Set-Content -Path $ConstitutionFile -Value $ConstitutionContent
}

# Create specs directory
$SpecsDir = Join-Path $RepoRoot "specs"
New-Item -ItemType Directory -Path $SpecsDir -Force | Out-Null

if ($Json) {
    $result = @{
        STATUS = "CREATED"
        PROJECT_PATH = $RepoRoot
        ACDD_DIR = $AcdDir
        DESCRIPTION = ($ProjectDescription -join " ")
    } | ConvertTo-Json
    Write-Output $result
} else {
    Write-Output "ACDD project initialized in: $RepoRoot"
    Write-Output "ACDD directory created: $AcdDir"
    Write-Output "Initial constitution created: $ConstitutionFile"
    Write-Output "Ready to begin ACDD workflow"
}