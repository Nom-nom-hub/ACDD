---
description: Execute the analysis phase of ACDD methodology by examining context patterns, architectural decisions, and preparing for adaptive implementation.
scripts:
  sh: scripts/bash/acdd-analyze.sh --json
  ps: scripts/powershell/acdd-analyze.ps1 -Json
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for FEATURE_SPEC, ACDD_ANALYSIS, SPECS_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read FEATURE_SPEC, `research.md`, `/memory/context-map.md`, `/memory/constitution.md`, and `/memory/lessons-learned.md`. Load analysis template (already copied).

3. **Execute ACDD analysis workflow**: Follow the structure in analysis template to:
   - Analyze context patterns from context-map.md
   - Identify adaptive requirements from feature spec
   - Evaluate architectural decisions for adaptability
   - Assess pattern applicability for the feature
   - Prepare for adaptive implementation planning

4. **ACDD Context Pattern Analysis**:
   - **Extract context patterns** from `/memory/context-map.md`:
     - Identify patterns relevant to the current feature
     - Assess pattern maturity and effectiveness
     - Document pattern dependencies and interactions
   - **Context change prediction**:
     - Identify potential context changes during implementation
     - Assess impact of context changes on feature requirements
     - Plan for context evolution scenarios
   - **Context adaptation planning**:
     - Determine how the feature should adapt to context changes
     - Identify adaptation triggers and mechanisms
     - Plan for graceful degradation during adaptation

5. **Adaptive Requirements Analysis**:
   - **Extract adaptive requirements** from feature spec:
     - Identify requirements that may change during implementation
     - Assess flexibility needs for each requirement
     - Plan for requirement evolution scenarios
   - **Change impact assessment**:
     - Analyze how requirement changes would affect implementation
     - Identify critical vs flexible requirements
     - Plan for requirement validation during implementation

6. **Architectural Decision Analysis**:
   - **Evaluate architectural patterns** for adaptability:
     - Assess how well current architecture supports adaptation
     - Identify architectural constraints on adaptability
     - Plan architectural modifications for better adaptability
   - **Technology stack assessment**:
     - Evaluate technology choices for adaptation support
     - Identify technology constraints on adaptability
     - Plan for technology evolution scenarios

7. **Pattern Applicability Assessment**:
   - **Evaluate existing patterns** from pattern library:
     - Assess applicability of patterns to current feature
     - Identify patterns that may need adaptation
     - Plan for new pattern creation if needed
   - **Pattern effectiveness prediction**:
     - Predict how well patterns will work for this feature
     - Identify potential pattern conflicts or challenges
     - Plan for pattern validation during implementation

8. **Constitutional Compliance Check**:
   - **Evaluate design decisions** against constitution.md:
     - Verify architectural decisions align with constitutional principles
     - Identify any constitutional conflicts or concerns
     - Propose constitutional amendments if needed
   - **Adaptive compliance planning**:
     - Plan for constitutional compliance during adaptation
     - Identify constitutional constraints on adaptability
     - Assess impact of constitution on feature implementation

9. **Learning Integration**:
   - **Incorporate lessons learned** from lessons-learned.md:
     - Apply insights from previous implementations
     - Avoid repeating past mistakes
     - Leverage successful approaches from history
   - **Update analysis** based on historical patterns:
     - Adjust predictions based on past experience
     - Identify recurring challenges and solutions
     - Plan for similar challenges in current implementation

10. **Risk Assessment**:
    - **Identify adaptation risks**:
      - Risks related to context changes during implementation
      - Risks related to pattern application challenges
      - Risks related to architectural constraints
    - **Risk mitigation planning**:
      - Plan for risk prevention where possible
      - Prepare contingency plans for likely risks
      - Establish risk monitoring during implementation

11. **Analysis Validation**:
    - **Completeness check**: All required analysis areas covered
    - **Consistency check**: Analysis aligns with feature requirements
    - **Feasibility check**: Analysis leads to implementable solutions
    - **Adaptability check**: Analysis supports adaptive implementation

12. **Generate Analysis Artifacts**:
    - **Context Analysis Report**: Summary of context patterns and change predictions
    - **Adaptive Requirements Map**: Flexible vs fixed requirements identification
    - **Architectural Assessment**: Architecture's adaptability evaluation
    - **Pattern Applicability Matrix**: Patterns vs feature mapping
    - **Risk Assessment**: Identified risks and mitigation plans

13. **Prepare for Next Phase**:
    - **Analysis summary** for planning phase
    - **Recommendations** for adaptive implementation approach
    - **Validation criteria** for pattern application
    - **Monitoring requirements** for context changes

14. **Stop and report**: Command ends after completing analysis. Report branch, analysis path, and generated artifacts.

## ACDD Analysis Phases

### Phase 1: Context Pattern Analysis

1. **Pattern Identification**:
   - Extract relevant patterns from context-map.md
   - Assess pattern applicability to current feature
   - Document pattern interactions and dependencies

2. **Context Change Prediction**:
   - Identify potential context evolution scenarios
   - Assess impact of changes on feature requirements
   - Plan adaptation triggers and mechanisms

**Output**: Context-aware pattern analysis with change prediction

### Phase 2: Adaptive Requirements Analysis

**Prerequisites**: Feature specification available

1. **Requirement Flexibility Assessment**:
   - Identify requirements that may change during implementation
   - Assess adaptability needs for each requirement
   - Plan for requirement evolution scenarios

2. **Change Impact Analysis**:
   - Analyze impact of requirement changes on implementation
   - Identify critical vs flexible requirements
   - Plan validation approaches for changing requirements

**Output**: Adaptive requirements map with flexibility assessment

### Phase 3: Architectural Assessment

**Prerequisites**: Architectural decisions available

1. **Adaptability Evaluation**:
   - Assess architecture's support for adaptation
   - Identify architectural constraints on adaptability
   - Plan architectural modifications if needed

2. **Technology Stack Analysis**:
   - Evaluate technology choices for adaptation support
   - Identify technology constraints on adaptability
   - Plan for technology evolution scenarios

**Output**: Architectural assessment with adaptation recommendations

### Phase 4: Pattern Applicability Analysis

**Prerequisites**: Pattern library available

1. **Pattern Matching**:
   - Evaluate existing patterns for feature applicability
   - Identify patterns that may need adaptation
   - Plan for new pattern creation if needed

2. **Effectiveness Prediction**:
   - Predict pattern performance for current feature
   - Identify potential pattern conflicts or challenges
   - Plan validation approaches for pattern application

**Output**: Pattern applicability matrix with effectiveness predictions

## Key Rules

- Use absolute paths
- Focus on adaptability and context awareness
- Integrate lessons learned from previous implementations
- Assess constitutional compliance throughout
- Identify risks and mitigation strategies
- Plan for context evolution scenarios
- Validate analysis completeness and feasibility
