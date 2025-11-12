---
description: Execute the ACDD learning phase by analyzing completed features, capturing learnings about pattern effectiveness, documenting team evolution, and preparing inputs for the adaptation phase with proper script integration, learning validation, and ACDD-specific quality checks.
scripts:
  sh: scripts/bash/acdd-learn.sh --json
  ps: scripts/powershell/acdd-learn.ps1 -Json
agent_scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for FEATURE_DIR, LEARN_REPORT, PATTERN_LIB_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read FEATURE_DIR/learn-template.md, IMPLEMENT_LOG, and `/memory/constitution.md`. Load LEARN_REPORT template (already copied).

3. **Execute learn workflow**: Follow the structure in LEARN_REPORT template to:
   - Analyze completed features against planned outcomes
   - Capture pattern effectiveness evidence
   - Document team evolution and capability changes
   - Validate learning artifacts
   - Prepare adaptation inputs

4. **Stop and report**: Command ends after learning analysis complete. Report branch, LEARN_REPORT path, and generated artifacts.

## Phases

### Phase 0: Feature Completion Analysis

1. **Extract completed feature data**:
   - For each completed task in tasks.md → feature component
   - For each implemented requirement → validation point
   - For each pattern applied → effectiveness measure
   - For each deviation from plan → learning opportunity

2. **Generate and dispatch analysis agents**:

   ```text
   For each completed feature component:
     Task: "Analyze effectiveness of {feature component} in {feature context}"
   For each pattern applied:
     Task: "Evaluate {pattern name} effectiveness in {feature context}"
   For each deviation from plan:
     Task: "Understand reasons for {deviation} and lessons learned"
   ```

3. **Consolidate findings** in `learn-report.md` using format:
   - Feature outcome: [what was achieved]
   - Pattern effectiveness: [how patterns performed]
   - Deviations and reasons: [what changed and why]
   - Team evolution: [how capabilities changed]

**Output**: learn-report.md with comprehensive feature analysis

### Phase 1: Pattern Effectiveness & Learning Capture

**Prerequisites:** `implement.md` and `tasks.md` complete

1. **Extract pattern application data** from implementation log:
   - Pattern ID, expected benefits, actual outcomes
   - Time variance data (planned vs actual for pattern implementations)
   - Quality metrics for pattern-based implementations
   - Challenges encountered with each pattern
   - Adaptations made to patterns during implementation

2. **Generate pattern effectiveness analysis**:
   - For each applied pattern → effectiveness score
   - For each adapted pattern → adaptation reasons
   - For each challenging pattern → improvement opportunities
   - For each new pattern discovered → documentation needs

3. **Agent context update**:
   - Run `{AGENT_SCRIPT}`
   - These scripts detect which AI agent is in use
   - Update the appropriate agent-specific context file
   - Add only new learning insights from current analysis
   - Preserve manual additions between markers

**Output**: learn-report.md with pattern effectiveness analysis, team evolution tracking

## Key ACDD-Specific Quality Checks

- **Pattern Compliance Validation**: Verify all patterns were applied as planned or properly adapted
- **Learning Evidence Collection**: Ensure sufficient data captured for adaptation decisions
- **Team Evolution Tracking**: Document how team capabilities changed during implementation
- **Context Model Updates**: Identify necessary updates to context awareness systems
- **Adaptation Readiness**: Validate that learning report contains actionable items for adaptation phase

## ACDD Learning Validation

- [ ] All planned vs actual comparisons completed
- [ ] Pattern effectiveness metrics collected and analyzed
- [ ] Team evolution documented with specific examples
- [ ] Learning report contains actionable adaptation items
- [ ] Context model updates identified and specified
- [ ] Quality metrics compared against targets
- [ ] Deviations from plan properly analyzed and documented
- [ ] New patterns discovered during implementation documented
- [ ] Pattern library update recommendations created
- [ ] Knowledge base updated with new insights
