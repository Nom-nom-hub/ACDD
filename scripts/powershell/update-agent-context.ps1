# Update agent context files with ACDD learning insights (PowerShell version)
# 
# Mirrors the behavior of scripts/bash/update-agent-context.sh for ACDD:
#  1. Environment Validation
#  2. Learning Data Extraction
#  3. Agent File Management (create from template or update existing)
#  4. Content Generation (adaptation insights, team evolution, timestamp)
#  5. Multi-Agent Support (claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, roo, amp, q)

param(
    [Parameter(Position=0)]
    [ValidateSet('claude','gemini','copilot','cursor-agent','qwen','opencode','codex','windsurf','kilocode','auggie','roo','codebuddy','amp','q')]
    [string]$AgentType
)

$ErrorActionPreference = 'Stop'

# Import common helpers
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir 'common.ps1')

# Acquire environment paths
$envData = Get-FeaturePathsEnv
$REPO_ROOT     = $envData.REPO_ROOT
$CURRENT_BRANCH = $envData.CURRENT_BRANCH
$HAS_GIT       = $envData.HAS_GIT
$FEATURE_DIR   = $envData.FEATURE_DIR
$LEARN_REPORT  = Join-Path $FEATURE_DIR 'learn-report.md'

# Agent file paths
$CLAUDE_FILE   = Join-Path $REPO_ROOT 'CLAUDE.md'
$GEMINI_FILE   = Join-Path $REPO_ROOT 'GEMINI.md'
$COPILOT_FILE  = Join-Path $REPO_ROOT '.github/copilot-instructions.md'
$CURSOR_FILE   = Join-Path $REPO_ROOT '.cursor/rules/specify-rules.mdc'
$QWEN_FILE     = Join-Path $REPO_ROOT 'QWEN.md'
$AGENTS_FILE   = Join-Path $REPO_ROOT 'AGENTS.md'
$WINDSURF_FILE = Join-Path $REPO_ROOT '.windsurf/rules/specify-rules.md'
$KILOCODE_FILE = Join-Path $REPO_ROOT '.kilocode/rules/specify-rules.md'
$AUGGIE_FILE   = Join-Path $REPO_ROOT '.augment/rules/specify-rules.md'
$ROO_FILE      = Join-Path $REPO_ROOT '.roo/rules/specify-rules.md'
$CODEBUDDY_FILE = Join-Path $REPO_ROOT 'CODEBUDDY.md'
$AMP_FILE      = Join-Path $REPO_ROOT 'AGENTS.md'
$Q_FILE        = Join-Path $REPO_ROOT 'AGENTS.md'

$TEMPLATE_FILE = Join-Path $REPO_ROOT '.acdd/templates/agent-file-template.md'

# Parsed learning data placeholders
$script:PATTERN_EFFECTIVENESS = ''
$script:TEAM_EVOLUTION = ''
$script:ADAPTATION_RECOMMENDATIONS = ''

function Write-Info {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "INFO: $Message"
}

function Write-Success {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "$([char]0x2713) $Message"
}

function Write-WarningMsg {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Warning $Message
}

function Write-Err {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Validate-Environment {
    if (-not $CURRENT_BRANCH) {
        Write-Err 'Unable to determine current feature'
        if ($HAS_GIT) { Write-Info "Make sure you're on a feature branch" } else { Write-Info 'Set SPECIFY_FEATURE environment variable or create a feature first' }
        exit 1
    }
    if (-not (Test-Path $LEARN_REPORT)) {
        Write-Err "No learn-report.md found at $LEARN_REPORT"
        Write-Info 'Ensure you are working on a feature with a completed learning phase'
        if (-not $HAS_GIT) { Write-Info 'Use: $env:SPECIFY_FEATURE=your-feature-name or create a new feature first' }
        exit 1
    }
    if (-not (Test-Path $TEMPLATE_FILE)) {
        Write-Err "Template file not found at $TEMPLATE_FILE"
        Write-Info 'Run acdd init to scaffold .acdd/templates, or add agent-file-template.md there.'
        exit 1
    }
}

function Extract-LearningSection {
    param(
        [Parameter(Mandatory=$true)]
        [string]$SectionHeader,
        [Parameter(Mandatory=$true)]
        [string]$LearnFile
    )
    if (-not (Test-Path $LearnFile)) { return '' }
    # Extract content between the specified header and the next header
    $lines = Get-Content -LiteralPath $LearnFile -Encoding utf8
    $start = -1
    $end = -1
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^## $([Regex]::Escape($SectionHeader))$") {
            $start = $i
        }
        elseif ($start -ne -1 -and $lines[$i] -match "^## ") {
            $end = $i
            break
        }
    }
    
    if ($start -ne -1) {
        if ($end -eq -1) { $end = $lines.Count }
        $content = $lines[$start+1..($end-1)] | Where-Object { $_ -notmatch "^##.*$" -and -not [string]::IsNullOrWhiteSpace($_) }
        return ($content | Select-Object -First 5) -join '; '
    }
    return ''
}

function Extract-PatternEffectiveness {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LearnFile
    )
    if (-not (Test-Path $LearnFile)) { return '' }
    $lines = Get-Content -LiteralPath $LearnFile -Encoding utf8
    $start = -1
    $end = -1
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^### Pattern Effectiveness$") {
            $start = $i
        }
        elseif ($start -ne -1 -and $lines[$i] -match "^### |^## ") {
            $end = $i
            break
        }
    }
    
    if ($start -ne -1) {
        if ($end -eq -1) { $end = $lines.Count }
        $content = $lines[$start+1..($end-1)] | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        return ($content | Where-Object { $_ -notmatch "^###.*$" -and $_ -notmatch "^##.*$" } | Select-Object -First 3) -join '; '
    }
    return 'No pattern effectiveness data found'
}

function Extract-TeamEvolution {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LearnFile
    )
    if (-not (Test-Path $LearnFile)) { return '' }
    $lines = Get-Content -LiteralPath $LearnFile -Encoding utf8
    $start = -1
    $end = -1
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^### Team Evolution Tracking$") {
            $start = $i
        }
        elseif ($start -ne -1 -and $lines[$i] -match "^### |^## ") {
            $end = $i
            break
        }
    }
    
    if ($start -ne -1) {
        if ($end -eq -1) { $end = $lines.Count }
        $content = $lines[$start+1..($end-1)] | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        return ($content | Where-Object { $_ -notmatch "^###.*$" -and $_ -notmatch "^##.*$" } | Select-Object -First 3) -join '; '
    }
    return 'No team evolution data found'
}

function Extract-AdaptationRecommendations {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LearnFile
    )
    if (-not (Test-Path $LearnFile)) { return '' }
    $lines = Get-Content -LiteralPath $LearnFile -Encoding utf8
    $start = -1
    $end = -1
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^### Action Items for Adapt Phase$") {
            $start = $i
        }
        elseif ($start -ne -1 -and $lines[$i] -match "^### |^## ") {
            $end = $i
            break
        }
    }
    
    if ($start -ne -1) {
        if ($end -eq -1) { $end = $lines.Count }
        $content = $lines[$start+1..($end-1)] | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        return ($content | Where-Object { $_ -notmatch "^###.*$" -and $_ -notmatch "^##.*$" } | Select-Object -First 3) -join '; '
    }
    return 'No adaptation recommendations found'
}

function Parse-LearningData {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LearnFile
    )
    if (-not (Test-Path $LearnFile)) { Write-Err "Learn report file not found: $LearnFile"; return $false }
    Write-Info "Parsing learning data from $LearnFile"
    
    $script:PATTERN_EFFECTIVENESS = Extract-PatternEffectiveness -LearnFile $LearnFile
    $script:TEAM_EVOLUTION = Extract-TeamEvolution -LearnFile $LearnFile
    $script:ADAPTATION_RECOMMENDATIONS = Extract-AdaptationRecommendations -LearnFile $LearnFile

    if ($PATTERN_EFFECTIVENESS -and $PATTERN_EFFECTIVENESS -ne 'No pattern effectiveness data found') { 
        Write-Info "Found pattern effectiveness data" 
    } else { 
        Write-WarningMsg 'No pattern effectiveness data found in learn report' 
    }
    
    if ($TEAM_EVOLUTION -and $TEAM_EVOLUTION -ne 'No team evolution data found') { 
        Write-Info "Found team evolution data" 
    } else { 
        Write-WarningMsg 'No team evolution data found in learn report' 
    }
    
    if ($ADAPTATION_RECOMMENDATIONS -and $ADAPTATION_RECOMMENDATIONS -ne 'No adaptation recommendations found') { 
        Write-Info "Found adaptation recommendations" 
    } else { 
        Write-WarningMsg 'No adaptation recommendations found in learn report' 
    }
    
    return $true
}

function Format-AdaptationInsights {
    param(
        [Parameter(Mandatory=$false)]
        [string]$PatternEffectiveness,
        [Parameter(Mandatory=$false)]
        [string]$TeamEvolution
    )
    $parts = @()
    if ($PatternEffectiveness -and $PatternEffectiveness -ne 'No pattern effectiveness data found') { $parts += $PatternEffectiveness }
    if ($TeamEvolution -and $TeamEvolution -ne 'No team evolution data found') { $parts += $TeamEvolution }
    if (-not $parts) { return 'No adaptation insights available' }
    return ($parts -join ' | ')
}

function Get-ACDDStructure {
    return "features/`nmemory/`npatterns/`nlearn-reports/"
}

function Get-ACDDCommands {
    return "acdd learn && acdd adapt"
}

function Get-ACDDConventions {
    return "ACDD: Adaptive Context-Driven Development - Focus on learning and adaptation"
}

function New-AgentFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetFile,
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        [Parameter(Mandatory=$true)]
        [datetime]$Date
    )
    if (-not (Test-Path $TEMPLATE_FILE)) { Write-Err "Template not found at $TEMPLATE_FILE"; return $false }
    $temp = New-TemporaryFile
    Copy-Item -LiteralPath $TEMPLATE_FILE -Destination $temp -Force

    $projectStructure = Get-ACDDStructure
    $commands = Get-ACDDCommands
    $acddConventions = Get-ACDDConventions

    # Prepare ACDD-specific content
    $adaptationInsights = Format-AdaptationInsights -PatternEffectiveness $PATTERN_EFFECTIVENESS -TeamEvolution $TEAM_EVOLUTION

    # Prepare recent changes based on learning
    $recentChange = if ($PATTERN_EFFECTIVENESS -and $PATTERN_EFFECTIVENESS -ne 'No pattern effectiveness data found') {
        "- ${CURRENT_BRANCH}: Learned from pattern effectiveness - $PATTERN_EFFECTIVENESS"
    } else {
        "- ${CURRENT_BRANCH}: Completed learning phase"
    }

    $content = Get-Content -LiteralPath $temp -Raw -Encoding utf8
    $content = $content -replace '\[PROJECT NAME\]',$ProjectName
    $content = $content -replace '\[DATE\]',$Date.ToString('yyyy-MM-dd')

    # Build the adaptation insights string safely
    $adaptationForTemplate = if ($adaptationInsights) { $adaptationInsights } else { "No adaptation insights available" }

    $content = $content -replace '\[EXTRACTED FROM ALL LEARN.MD FILES\]',$adaptationForTemplate
    # For project structure we manually embed (keep newlines)
    $escapedStructure = [Regex]::Escape($projectStructure)
    $content = $content -replace '\[ACTUAL STRUCTURE FROM LEARNINGS\]',$escapedStructure
    # Replace escaped newlines placeholder after all replacements
    $content = $content -replace '\[ACDD-SPECIFIC COMMANDS\]',$commands
    $content = $content -replace '\[ACDD-SPECIFIC CONVENTIONS\]',$acddConventions

    # Build the recent changes string safely
    $content = $content -replace '\[LAST 3 FEATURES AND WHAT THEY LEARNED\]',$recentChange
    # Convert literal \n sequences introduced by Escape to real newlines
    $content = $content -replace '\\n',[Environment]::NewLine

    $parent = Split-Path -Parent $TargetFile
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent | Out-Null }
    Set-Content -LiteralPath $TargetFile -Value $content -NoNewline -Encoding utf8
    Remove-Item $temp -Force
    return $true
}

function Update-ExistingAgentFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetFile,
        [Parameter(Mandatory=$true)]
        [datetime]$Date
    )
    if (-not (Test-Path $TargetFile)) { return (New-AgentFile -TargetFile $TargetFile -ProjectName (Split-Path $REPO_ROOT -Leaf) -Date $Date) }

    $adaptationInsights = Format-AdaptationInsights -PatternEffectiveness $PATTERN_EFFECTIVENESS -TeamEvolution $TEAM_EVOLUTION
    $newAdaptationEntries = @()
    if ($adaptationInsights -and $adaptationInsights -ne 'No adaptation insights available') {
        $escapedAdaptationInsights = [Regex]::Escape($adaptationInsights)
        if (-not (Select-String -Pattern $escapedAdaptationInsights -Path $TargetFile -Quiet)) {
            $newAdaptationEntries += "- $adaptationInsights ($CURRENT_BRANCH)"
        }
    }
    
    $newChangeEntry = if ($PATTERN_EFFECTIVENESS -and $PATTERN_EFFECTIVENESS -ne 'No pattern effectiveness data found') {
        "- ${CURRENT_BRANCH}: Learned from pattern effectiveness - $PATTERN_EFFECTIVENESS"
    } else {
        "- ${CURRENT_BRANCH}: Completed learning phase"
    }

    $lines = Get-Content -LiteralPath $TargetFile -Encoding utf8
    $output = New-Object System.Collections.Generic.List[string]
    $inTech = $false; $inChanges = $false; $inAdaptation = $false; $techAdded = $false; $changeAdded = $false; $adaptationAdded = $false; $existingChanges = 0

    for ($i=0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -eq '## Active Technologies') {
            $output.Add($line)
            $inTech = $true
            continue
        }
        if ($inTech -and $line -match '^##\s') {
            if (-not $techAdded -and $newAdaptationEntries.Count -gt 0) { $newAdaptationEntries | ForEach-Object { $output.Add($_) }; $techAdded = $true }
            $output.Add($line); $inTech = $false; continue
        }
        if ($inTech -and [string]::IsNullOrWhiteSpace($line)) {
            if (-not $techAdded -and $newAdaptationEntries.Count -gt 0) { $newAdaptationEntries | ForEach-Object { $output.Add($_) }; $techAdded = $true }
            $output.Add($line); continue
        }
        if ($line -eq '## Recent Changes') {
            $output.Add($line)
            if ($newChangeEntry) { $output.Add($newChangeEntry); $changeAdded = $true }
            $inChanges = $true
            continue
        }
        if ($inChanges -and $line -match '^##\s') { $output.Add($line); $inChanges = $false; continue }
        if ($inChanges -and $line -match '^- ') {
            if ($existingChanges -lt 2) { $output.Add($line); $existingChanges++ }
            continue
        }
        if ($line -eq '## Adaptation Insights') {
            $output.Add($line)
            if ($adaptationInsights -and $adaptationInsights -ne 'No adaptation insights available') { 
                $output.Add("- $adaptationInsights"); $adaptationAdded = $true 
            }
            $inAdaptation = $true
            continue
        }
        if ($inAdaptation -and $line -match '^##\s') { $output.Add($line); $inAdaptation = $false; continue }
        if ($inAdaptation -and $line -match '^- ') {
            if ($existingChanges -lt 2) { $output.Add($line); $existingChanges++ }
            continue
        }
        if ($line -match '\*\*Last updated\*\*: .*\d{4}-\d{2}-\d{2}') {
            $output.Add(($line -replace '\d{4}-\d{2}-\d{2}',$Date.ToString('yyyy-MM-dd')))
            continue
        }
        $output.Add($line)
    }

    # Post-loop check: if we're still in the Active Technologies section and haven't added new entries
    if ($inTech -and -not $techAdded -and $newAdaptationEntries.Count -gt 0) {
        $newAdaptationEntries | ForEach-Object { $output.Add($_) }
    }

    Set-Content -LiteralPath $TargetFile -Value ($output -join [Environment]::NewLine) -Encoding utf8
    return $true
}

function Update-AgentFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetFile,
        [Parameter(Mandatory=$true)]
        [string]$AgentName
    )
    if (-not $TargetFile -or -not $AgentName) { Write-Err 'Update-AgentFile requires TargetFile and AgentName'; return $false }
    Write-Info "Updating $AgentName context file: $TargetFile"
    $projectName = Split-Path $REPO_ROOT -Leaf
    $date = Get-Date

    $dir = Split-Path -Parent $TargetFile
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

    if (-not (Test-Path $TargetFile)) {
        if (New-AgentFile -TargetFile $TargetFile -ProjectName $projectName -Date $date) { Write-Success "Created new $AgentName context file" } else { Write-Err 'Failed to create new agent file'; return $false }
    } else {
        try {
            if (Update-ExistingAgentFile -TargetFile $TargetFile -Date $date) { Write-Success "Updated existing $AgentName context file" } else { Write-Err 'Failed to update agent file'; return $false }
        } catch {
            Write-Err "Cannot access or update existing file: $TargetFile. $_"
            return $false
        }
    }
    return $true
}

function Update-SpecificAgent {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Type
    )
    switch ($Type) {
        'claude'   { Update-AgentFile -TargetFile $CLAUDE_FILE   -AgentName 'Claude Code' }
        'gemini'   { Update-AgentFile -TargetFile $GEMINI_FILE   -AgentName 'Gemini CLI' }
        'copilot'  { Update-AgentFile -TargetFile $COPILOT_FILE  -AgentName 'GitHub Copilot' }
        'cursor-agent' { Update-AgentFile -TargetFile $CURSOR_FILE   -AgentName 'Cursor IDE' }
        'qwen'     { Update-AgentFile -TargetFile $QWEN_FILE     -AgentName 'Qwen Code' }
        'opencode' { Update-AgentFile -TargetFile $AGENTS_FILE   -AgentName 'opencode' }
        'codex'    { Update-AgentFile -TargetFile $AGENTS_FILE   -AgentName 'Codex CLI' }
        'windsurf' { Update-AgentFile -TargetFile $WINDSURF_FILE -AgentName 'Windsurf' }
        'kilocode' { Update-AgentFile -TargetFile $KILOCODE_FILE -AgentName 'Kilo Code' }
        'auggie'   { Update-AgentFile -TargetFile $AUGGIE_FILE   -AgentName 'Auggie CLI' }
        'roo'      { Update-AgentFile -TargetFile $ROO_FILE      -AgentName 'Roo Code' }
        'codebuddy' { Update-AgentFile -TargetFile $CODEBUDDY_FILE -AgentName 'CodeBuddy CLI' }
        'amp'      { Update-AgentFile -TargetFile $AMP_FILE      -AgentName 'Amp' }
        'q'        { Update-AgentFile -TargetFile $Q_FILE        -AgentName 'Amazon Q Developer CLI' }
        default { Write-Err "Unknown agent type '$Type'"; Write-Err 'Expected: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|codebuddy|amp|q'; return $false }
    }
}

function Update-AllExistingAgents {
    $found = $false
    $ok = $true
    if (Test-Path $CLAUDE_FILE)   { if (-not (Update-AgentFile -TargetFile $CLAUDE_FILE   -AgentName 'Claude Code')) { $ok = $false }; $found = $true }
    if (Test-Path $GEMINI_FILE)   { if (-not (Update-AgentFile -TargetFile $GEMINI_FILE   -AgentName 'Gemini CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $COPILOT_FILE)  { if (-not (Update-AgentFile -TargetFile $COPILOT_FILE  -AgentName 'GitHub Copilot')) { $ok = $false }; $found = $true }
    if (Test-Path $CURSOR_FILE)   { if (-not (Update-AgentFile -TargetFile $CURSOR_FILE   -AgentName 'Cursor IDE')) { $ok = $false }; $found = $true }
    if (Test-Path $QWEN_FILE)     { if (-not (Update-AgentFile -TargetFile $QWEN_FILE     -AgentName 'Qwen Code')) { $ok = $false }; $found = $true }
    if (Test-Path $AGENTS_FILE)   { if (-not (Update-AgentFile -TargetFile $AGENTS_FILE   -AgentName 'Codex/opencode')) { $ok = $false }; $found = $true }
    if (Test-Path $WINDSURF_FILE) { if (-not (Update-AgentFile -TargetFile $WINDSURF_FILE -AgentName 'Windsurf')) { $ok = $false }; $found = $true }
    if (Test-Path $KILOCODE_FILE) { if (-not (Update-AgentFile -TargetFile $KILOCODE_FILE -AgentName 'Kilo Code')) { $ok = $false }; $found = $true }
    if (Test-Path $AUGGIE_FILE)   { if (-not (Update-AgentFile -TargetFile $AUGGIE_FILE   -AgentName 'Auggie CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $ROO_FILE)      { if (-not (Update-AgentFile -TargetFile $ROO_FILE      -AgentName 'Roo Code')) { $ok = $false }; $found = $true }
    if (Test-Path $CODEBUDDY_FILE) { if (-not (Update-AgentFile -TargetFile $CODEBUDDY_FILE -AgentName 'CodeBuddy CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $Q_FILE)        { if (-not (Update-AgentFile -TargetFile $Q_FILE        -AgentName 'Amazon Q Developer CLI')) { $ok = $false }; $found = $true }
    if (-not $found) {
        Write-Info 'No existing agent files found, creating default Claude file...'
        if (-not (Update-AgentFile -TargetFile $CLAUDE_FILE -AgentName 'Claude Code')) { $ok = $false }
    }
    return $ok
}

function Print-Summary {
    Write-Host ''
    Write-Info 'Summary of ACDD learning updates:'
    if ($PATTERN_EFFECTIVENESS) { Write-Host "  - Added pattern effectiveness insights: $PATTERN_EFFECTIVENESS" }
    if ($TEAM_EVOLUTION) { Write-Host "  - Added team evolution data: $TEAM_EVOLUTION" }
    if ($ADAPTATION_RECOMMENDATIONS) { Write-Host "  - Added adaptation recommendations: $ADAPTATION_RECOMMENDATIONS" }
    Write-Host ''
    Write-Info 'Usage: ./update-agent-context.ps1 [-AgentType claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|codebuddy|amp|q]'
}

function Main {
    Validate-Environment
    Write-Info "=== Updating agent context files with ACDD learning insights for feature $CURRENT_BRANCH ==="
    if (-not (Parse-LearningData -LearnFile $LEARN_REPORT)) { Write-Err 'Failed to parse learning data'; exit 1 }
    $success = $true
    if ($AgentType) {
        Write-Info "Updating specific agent: $AgentType"
        if (-not (Update-SpecificAgent -Type $AgentType)) { $success = $false }
    }
    else {
        Write-Info 'No agent specified, updating all existing agent files...'
        if (-not (Update-AllExistingAgents)) { $success = $false }
    }
    Print-Summary
    if ($success) { Write-Success 'Agent context update completed successfully'; exit 0 } else { Write-Err 'Agent context update completed with errors'; exit 1 }
}

Main