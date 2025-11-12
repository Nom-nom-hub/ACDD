---
description: Generate ACDD-specific checklists for validating adaptive implementation, pattern compliance, and learning evidence collection throughout the ACDD methodology phases.
scripts:
  sh: scripts/bash/acdd-checklist.sh --json
  ps: scripts/powershell/acdd-checklist.ps1 -Json
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for FEATURE_SPEC, ACDD_CHECKLIST, SPECS_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read FEATURE_SPEC, `plan.md`, `research.md`, `/memory/constitution.md`, and checklist template (already copied).

3. **Execute ACDD checklist generation workflow**: Follow the structure in checklist template to:
   - Generate adaptive implementation validation checklist
   - Create pattern compliance validation checklist
   - Generate learning evidence collection checklist
   - Create context evolution tracking checklist
   - Include constitutional compliance validation checklist

4. **ACDD-Specific Checklist Categories**:

   a. **Adaptive Implementation Validation**:
      - Verify adaptive components function correctly
      - Validate context change detection mechanisms
      - Confirm adaptation triggers work as expected
      - Test graceful degradation capabilities

   b. **Pattern Compliance Validation**:
      - Verify patterns from plan are applied correctly
      - Validate pattern effectiveness metrics
      - Check for proper pattern documentation
      - Confirm pattern adaptation where needed

   c. **Learning Evidence Collection**:
      - Ensure time tracking is comprehensive
      - Verify quality metrics are captured
      - Confirm pattern effectiveness evidence is collected
      - Check deviation documentation is complete

   d. **Context Evolution Tracking**:
      - Validate context change monitoring is active
      - Confirm evolution scenarios are tracked
      - Verify context impact assessment is recorded
      - Check adaptation effectiveness logging

   e. **Constitutional Compliance Validation**:
      - Verify all implementations follow constitutional principles
      - Validate adaptive changes maintain constitutional compliance
      - Check that adaptation mechanisms respect constitutional constraints

5. **Generate checklist with appropriate validation items**:
   - Include pass/fail criteria for each validation item
   - Provide evidence requirements for each check
   - Add links to relevant documentation
   - Include automated validation where possible

6. **Organize checklist by ACDD phases**:
   - Pre-implementation validation items
   - Implementation validation items
   - Post-implementation validation items
   - Learning phase validation items
   - Adaptation phase validation items

7. **Stop and report**: Command ends after generating ACDD_CHECKLIST. Report branch, checklist path, and generated validation categories.

## ACDD Checklist Categories

### Adaptive Implementation Validation Checklist

**Purpose**: Validate that adaptive implementation meets ACDD requirements

- [ ] Adaptive components function correctly in base context
- [ ] Context change detection mechanisms are active
- [ ] Adaptation triggers respond appropriately
- [ ] Graceful degradation works when adaptation fails
- [ ] Performance meets targets under adaptation
- [ ] User experience remains consistent during adaptation
- [ ] Context evolution scenarios are handled appropriately

### Pattern Compliance Validation Checklist

**Purpose**: Ensure pattern application follows ACDD methodology

- [ ] All planned patterns are applied as specified
- [ ] Pattern adaptations are properly documented
- [ ] Pattern effectiveness metrics are captured
- [ ] Pattern compliance validates against constitution.md
- [ ] New patterns discovered during implementation are documented
- [ ] Pattern deviations are justified and recorded
- [ ] Pattern application evidence is collected

### Learning Evidence Collection Checklist

**Purpose**: Verify learning evidence is comprehensively captured

- [ ] Time tracking records planned vs actual for all tasks
- [ ] Quality metrics are captured for all implemented components
- [ ] Pattern effectiveness evidence is documented
- [ ] Deviation documentation is complete
- [ ] Unexpected learnings are recorded
- [ ] Context update needs are identified
- [ ] Data is prepared for learn phase analysis

### Context Evolution Tracking Checklist

**Purpose**: Validate context evolution is properly monitored

- [ ] Context change monitoring is active for all components
- [ ] Evolution scenario tracking is comprehensive
- [ ] Context impact assessment is recorded
- [ ] Adaptation effectiveness is logged
- [ ] Context-aware error handling is validated
- [ ] Cross-context consistency is maintained
- [ ] Context evolution documentation is complete

### Constitutional Compliance Validation Checklist

**Purpose**: Ensure all implementations follow constitutional principles

- [ ] All adaptive implementations follow constitutional principles
- [ ] Adaptation mechanisms respect constitutional constraints
- [ ] New patterns comply with constitutional guidelines
- [ ] Process changes maintain constitutional compliance
- [ ] Quality gates enforce constitutional requirements
- [ ] Validation criteria align with constitutional principles
- [ ] Adaptation processes follow constitutional procedures

## Key rules

- Use absolute paths
- Include evidence requirements for each validation item
- Organize by ACDD methodology phases
- Include both manual and automated validation items
- Provide clear pass/fail criteria
- Link to relevant documentation and standards
- Ensure checklists support comprehensive validation of ACDD methodology
