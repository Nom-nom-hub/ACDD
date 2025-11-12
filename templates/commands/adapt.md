---
description: Execute the adaptation phase of ACDD methodology by implementing changes based on learning outcomes, updating patterns and processes, and evolving the development methodology with proper script integration, adaptation validation, and ACDD-specific quality checks.
scripts:
  sh: scripts/bash/acdd-adapt.sh --json --require-learn
  ps: scripts/powershell/acdd-adapt.ps1 -Json -RequireLearn
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for FEATURE_DIR, ADAPT_REPORT, PATTERN_LIB_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Validate ACDD adapt prerequisites** (if FEATURE_DIR/ exists):
   - Verify `learn.md` or learning report exists with complete analysis
   - Verify `ACDD-SUMMARY.md` exists with learning outcomes
   - Verify `implement.md` exists for reference to implementation context
   - Verify `adapt-template.md` exists for adaptation structure
   - Check if adaptation action items exist from previous learn phase

   **If any prerequisite missing**:
   - List missing files
   - **STOP** and ask: "Some ACDD adapt prerequisites are missing. Run the appropriate commands to generate them first. Continue anyway? (yes/no)"
   - Wait for user response before continuing
   - If user says "no" or "wait" or "stop", halt execution
   - If user says "yes" or "proceed" or "continue", proceed to step 3

3. **Load context**: Read FEATURE_DIR/adapt-template.md, LEARN_REPORT, and `/memory/constitution.md`. Load ADAPT_REPORT template (already copied).

4. **Execute adapt workflow**: Follow the structure in ADAPT_REPORT template to:
   - Implement pattern library updates based on learning
   - Apply process improvements identified during learning
   - Update methodology documentation with new insights
   - Validate adaptation implementations
   - Prepare for next implementation cycle

5. **Stop and report**: Command ends after adaptation implementation complete. Report branch, ADAPT_REPORT path, and generated artifacts.

## Phases

### Phase 0: Adaptation Planning & Prioritization

1. **Extract adaptation items from learning report**:
   - Critical changes that must be implemented immediately
   - Important improvements for next few implementations
   - Beneficial changes for future iterations
   - Strategic evolutions to methodology
   - Pattern updates and deprecations identified

2. **Create adaptation priority matrix**:

   ```text
   | Adaptation Item | Category | Impact | Effort | Priority | Status |
   |-----------------|----------|--------|--------|----------|--------|
   | Update Repository pattern | Immediate | High | Low | P0 | Pending |
   | Improve estimation process | Short-term | High | Medium | P1 | Pending |
   | Add performance validation | Medium-term | Medium | High | P2 | Pending |
   | Redesign pattern library | Long-term | High | Very High | P3 | Pending |
   ```

3. **Apply adaptation criteria**:
   - **High Impact, Low Effort**: Implement immediately (P0)
   - **High Impact, Medium Effort**: Plan for short-term (P1)
   - **Medium Impact, Low Effort**: Plan for short-term (P1)
   - **Medium Impact, Medium Effort**: Plan for medium-term (P2)
   - **High Impact, High Effort**: Plan for long-term (P3)
   - **Low Impact**: Defer or deprioritize

4. **Generate and dispatch adaptation agents**:

   ```text
   For each immediate adaptation:
     Task: "Implement {adaptation item} in {feature context}"
   For each pattern update:
     Task: "Update {pattern name} documentation based on learning outcomes"
   For each process improvement:
     Task: "Modify {process name} to incorporate lessons learned"
   ```

**Output**: Adaptation plan with prioritized items and implementation strategy

### Phase 1: Pattern Library Evolution & Process Updates

**Prerequisites:** Learning report with identified pattern issues and process improvements

1. **Implement pattern updates**:
   - Update existing pattern documentation with learning insights
   - Add new patterns discovered during implementation
   - Deprecate or modify ineffective patterns
   - Include adaptation examples and variations
   - Update pattern application guidance based on experience

2. **Execute process improvements**:
   - Update task generation templates with learning insights
   - Modify quality gates based on effectiveness analysis
   - Adjust phase dependencies based on implementation experience
   - Update validation criteria based on quality outcomes
   - Refine success metrics based on actual results

3. **Update methodology documentation**:
   - Add lessons learned to methodology documentation
   - Update best practices based on pattern effectiveness
   - Modify phase structures based on implementation flow
   - Adjust quality criteria based on outcome analysis
   - Incorporate team feedback on methodology changes

**Output**: Updated pattern library, improved processes, evolved methodology

## Key ACDD-Specific Quality Checks

- **Adaptation Implementation Validation**: Verify all planned adaptations were implemented correctly
- **Pattern Library Consistency**: Ensure updated patterns are consistent with methodology
- **Process Integration**: Confirm new processes integrate well with existing workflows
- **Knowledge Transfer**: Validate that adaptations are properly documented and communicated
- **Adaptation Effectiveness**: Ensure changes address learning report insights effectively

## ACDD Adaptation Validation

- [ ] All high-priority adaptations implemented
- [ ] Pattern library updated with learning insights
- [ ] Process improvements documented and applied
- [ ] Methodology documentation reflects new insights
- [ ] Adaptation effectiveness metrics established
- [ ] Knowledge base updated with adaptation outcomes
- [ ] Team communication plan executed for changes
- [ ] Risk mitigation strategies implemented for adaptations
- [ ] Validation plan created for adaptation success
- [ ] Next implementation cycle prepared with improvements
