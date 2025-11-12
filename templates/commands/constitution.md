---
description: Generate or update the constitutional principles for ACDD methodology with adaptive guidelines, pattern governance, and context-aware constraints.
scripts:
  sh: scripts/bash/acdd-constitution.sh --json
  ps: scripts/powershell/acdd-constitution.ps1 -Json
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for ACDD_CONSTITUTION path. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read existing constitution if it exists, `/memory/lessons-learned.md`, and ACDD methodology documentation.

3. **Execute constitutional generation workflow**: Follow constitutional principles to:
   - Define adaptive implementation constraints
   - Establish pattern governance guidelines
   - Create context-aware development constraints
   - Set adaptive quality standards
   - Define methodology evolution procedures

4. **ACDD Constitutional Principles**:

   a. **Adaptive Implementation Constraints**:
      - All implementations must include context awareness
      - Adaptive components must have graceful degradation
      - Change mechanisms must be built into core components
      - Evolution paths must be planned for all major components

   b. **Pattern Governance Guidelines**:
      - Patterns must be validated before application
      - Pattern adaptations must be documented
      - New patterns must follow constitutional principles
      - Pattern effectiveness must be measured and reported

   c. **Context-Aware Development Constraints**:
      - All components must monitor relevant context changes
      - Context change responses must be predictable and safe
      - Cross-context consistency must be maintained
      - Context evolution must be logged and analyzed

   d. **Adaptive Quality Standards**:
      - Quality metrics must account for adaptation effectiveness
      - Testing must include context change scenarios
      - Performance standards must apply across context changes
      - User experience consistency must be maintained during adaptation

   e. **Methodology Evolution Procedures**:
      - Evolution must be based on implementation learning
      - Changes must follow constitutional amendment procedures
      - Impact assessment required for all constitutional changes
      - Stakeholder approval required for major amendments

5. **Generate constitutional document with appropriate sections**:
   - Include clear principles with specific requirements
   - Provide implementation guidance for each principle
   - Define enforcement mechanisms
   - Include amendment procedures

6. **Incorporate lessons learned** from previous implementations:
   - Apply insights from lessons-learned.md
   - Address recurring issues identified in learning phases
   - Incorporate successful practices from history
   - Refine principles based on implementation experience

7. **Validate constitutional completeness**:
   - Ensure all ACDD methodology aspects are covered
   - Verify principles support adaptive development
   - Confirm constraints are enforceable
   - Check that evolution procedures are practical

8. **Stop and report**: Command ends after generating ACDD_CONSTITUTION. Report path and constitutional summary.

## ACDD Constitutional Articles

### Article I: Adaptive Implementation Requirements

**Principle**: All implementations must be designed for adaptation to context changes

**Requirements**:

- Every component must include context awareness mechanisms
- Adaptive components must have fallback strategies for failed adaptations
- Change impact analysis must be performed before implementation
- Context evolution scenarios must be planned and tested
- Monitoring must be built into all adaptive components

**Enforcement**:

- All implementations must pass adaptive design review
- Context change scenarios must be demonstrated
- Fallback mechanisms must be tested
- Monitoring requirements must be validated

### Article II: Pattern Governance Standards

**Principle**: Patterns must be validated, documented, and effectively applied

**Requirements**:

- All patterns must be validated against constitutional principles
- Pattern applications must be documented with effectiveness metrics
- Pattern adaptations must be justified and recorded
- New patterns must follow constitutional guidelines
- Pattern effectiveness must be measured and reported

**Enforcement**:

- Pattern compliance validation required for all implementations
- Pattern effectiveness evidence must be collected
- Adapted patterns must be reviewed and approved
- New patterns must be added to pattern library

### Article III: Context-Aware Development Constraints

**Principle**: All development must account for context changes and evolution

**Requirements**:

- Context monitoring must be implemented in all components
- Cross-context consistency must be maintained
- Context change responses must be predictable and safe
- Context evolution must be logged and analyzed
- Context-aware error handling must be implemented

**Enforcement**:

- Context awareness validation required for all components
- Cross-context consistency testing required
- Context change scenario validation required
- Context evolution logging verification required

### Article IV: Adaptive Quality Standards

**Principle**: Quality standards must account for adaptation effectiveness and context changes

**Requirements**:

- Quality metrics must include adaptation effectiveness
- Testing must include context change scenarios
- Performance standards must apply across context changes
- User experience consistency must be maintained during adaptation
- Quality gates must validate adaptive components

**Enforcement**:

- Adaptive quality validation required for all implementations
- Context change scenario testing required
- Performance validation across contexts required
- User experience consistency verification required

### Article V: Methodology Evolution Procedures

**Principle**: ACDD methodology must evolve based on implementation learning

**Requirements**:

- Evolution must be based on implementation learning outcomes
- Changes must follow constitutional amendment procedures
- Impact assessment required for all constitutional changes
- Stakeholder approval required for major amendments
- Evolution effectiveness must be measured

**Enforcement**:

- Learning phase required before methodology changes
- Amendment procedures must be followed
- Impact assessment required for changes
- Stakeholder approval verification required

### Article VI: Implementation Learning Requirements

**Principle**: Learning from implementation must be comprehensive and actionable

**Requirements**:

- Comprehensive evidence collection required for all implementations
- Pattern effectiveness analysis must be performed
- Context evolution impact must be documented
- Adaptation effectiveness must be measured
- Lessons learned must be incorporated into methodology

**Enforcement**:

- Complete evidence collection verification required
- Pattern effectiveness analysis validation required
- Context evolution documentation verification required
- Learning incorporation validation required

## Constitutional Amendment Process

### Proposal Requirements

- Amendment must address identified improvement opportunity
- Impact assessment must be provided
- Implementation plan must be included
- Stakeholder input must be gathered

### Review Process

- Constitutional review committee evaluation
- Impact assessment validation
- Implementation plan review
- Stakeholder feedback incorporation

### Approval Process

- Committee approval required
- Stakeholder approval for major changes
- Documentation update required
- Training plan for changes required

## Key rules

- Use absolute paths
- Ensure principles support adaptive development
- Include enforceable requirements
- Define clear validation procedures
- Incorporate lessons learned from implementations
- Maintain constitutional consistency with ACDD methodology
- Provide clear amendment procedures
