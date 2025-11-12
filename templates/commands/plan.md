---
description: Execute the adaptive planning phase of ACDD methodology using the plan template to generate adaptive design artifacts with context awareness and pattern validation.
scripts:
  sh: scripts/bash/acdd-plan.sh --json
  ps: scripts/powershell/acdd-plan.ps1 -Json
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

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for FEATURE_SPEC, ACDD_IMPL_PLAN, SPECS_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read FEATURE_SPEC, `research.md`, `data-model.md`, `/memory/context-map.md`, `/memory/constitution.md`, and ACDD_IMPL_PLAN template (already copied).

3. **Execute adaptive planning workflow**: Follow the structure in ACDD_IMPL_PLAN template to:
   - Fill Adaptive Technical Context (mark unknowns as "NEEDS CLARIFICATION")
   - Fill Constitutional Check section from constitution
   - Evaluate adaptive gates (ERROR if violations unjustified)
   - Phase 0: Generate adaptive research.md (resolve all NEEDS CLARIFICATION)
   - Phase 1: Generate adaptive data-model.md, contracts/, quickstart.md
   - Phase 1: Update agent context by running the agent script
   - Re-evaluate Constitutional Check post-design

4. **Stop and report**: Command ends after Phase 2 planning. Report branch, ACDD_IMPL_PLAN path, and generated artifacts.

## Phases

### Phase 0: Adaptive Outline & Research

1. **Extract unknowns from Adaptive Technical Context** above:
   - For each NEEDS CLARIFICATION → adaptive research task
   - For each context dependency → context pattern research task
   - For each integration → adaptive patterns research task
   - For each architectural decision → adaptability assessment task

2. **Generate and dispatch adaptive research agents**:

   ```text
   For each unknown in Adaptive Technical Context:
     Task: "Research {unknown} for {feature context} with adaptability focus"
   For each context dependency:
     Task: "Find context patterns for {dependency} in {domain}"
   For each technology choice:
     Task: "Find adaptive patterns for {tech} in {domain}"
   For each architectural decision:
     Task: "Assess adaptability of {decision} for {feature context}"
   ```

3. **Consolidate findings** in `adaptive-research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen with adaptability considerations]
   - Alternatives considered: [what else evaluated]
   - Adaptability impact: [how this affects future adaptability]
   - Context considerations: [how this handles context changes]

**Output**: adaptive-research.md with all NEEDS CLARIFICATION resolved

### Phase 1: Adaptive Design & Contracts

**Prerequisites:** `adaptive-research.md` complete

1. **Extract entities from feature spec** → `adaptive-data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable
   - **Adaptive considerations**: How entities adapt to context changes
   - **Evolution paths**: How entities might change over time
   - **Context tracking**: How to monitor entity changes

2. **Generate adaptive API contracts** from functional requirements:
   - For each user action → adaptive endpoint
   - Use adaptive REST/GraphQL patterns
   - Include context evolution considerations
   - Output OpenAPI/GraphQL schema to `/contracts/`
   - **Adaptation mechanisms**: How contracts handle context changes
   - **Versioning strategy**: How to evolve contracts over time

3. **Agent context update**:
   - Run `{AGENT_SCRIPT}`
   - These scripts detect which AI agent is in use
   - Update the appropriate agent-specific context file
   - Add only new adaptive technology from current plan
   - Preserve manual additions between markers

**Output**: adaptive-data-model.md, /contracts/*, quickstart.md, agent-specific file

## ACDD-Specific Planning Considerations

### Adaptive Architecture Design

1. **Context Awareness Implementation**:
   - Design components with built-in context awareness
   - Plan for context change detection mechanisms
   - Include context evolution tracking in all components

2. **Adaptation Mechanisms**:
   - Plan for graceful adaptation to context changes
   - Design fallback mechanisms for failed adaptations
   - Include monitoring for adaptation effectiveness

3. **Pattern Validation Points**:
   - Plan validation checkpoints for pattern effectiveness
   - Include pattern compliance verification during implementation
   - Design metrics for pattern success/failure assessment

### Context Evolution Planning

1. **Context Change Scenarios**:
   - Plan for likely context evolution scenarios
   - Design components that can handle context changes
   - Include context change impact assessment in design

2. **Evolution Tracking**:
   - Plan for comprehensive context evolution logging
   - Design monitoring for context change effectiveness
   - Include context change validation in quality gates

### Constitutional Compliance in Adaptive Design

1. **Principle Alignment**:
   - Ensure adaptive designs align with constitutional principles
   - Plan for constitutional compliance during adaptation
   - Include constitutional validation in adaptation processes

2. **Adaptation Constraints**:
   - Identify constitutional constraints on adaptability
   - Plan for constitutional amendments if needed
   - Design adaptation processes that respect constitutional principles

## Key rules

- Use absolute paths
- ERROR on gate failures or unresolved clarifications
- Prioritize adaptability and context awareness in all design decisions
- Ensure pattern compliance throughout the design
- Plan for comprehensive learning evidence collection
- Include context evolution considerations in all components
