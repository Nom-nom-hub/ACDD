---
description: Generate adaptive task lists for ACDD implementation with context evolution tracking and pattern compliance validation.
scripts:
  sh: scripts/bash/acdd-tasks.sh --json
  ps: scripts/powershell/acdd-tasks.ps1 -Json
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for FEATURE_SPEC, ACDD_TASKS, SPECS_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read FEATURE_SPEC, `plan.md`, `research.md`, `data-model.md`, `contracts/`, and `/memory/context-map.md`. Load ACDD_TASKS template (already copied).

3. **Execute ACDD task generation workflow**: Follow the structure in ACDD_TASKS template to:
   - Extract user stories from feature spec
   - Analyze context patterns from context-map.md
   - Generate context-aware tasks with [CTX-INIT], [CTX-LEARN], [CTX-ADAPT], [CTX-VALIDATE] tags
   - Organize tasks by user story for independent implementation
   - Include pattern compliance validation tasks
   - Identify parallel execution opportunities [P]
   - Create dependency mappings for adaptive implementation

4. **ACDD-Specific Task Generation Rules**:
   - **Context Pattern Analysis**: Identify applicable context patterns from context-map.md
   - **Adaptive Foundation**: Generate blocking tasks that must complete before user stories
   - **Context Validation**: Include validation tasks for each context evolution phase
   - **Pattern Compliance**: Add constitutional compliance validation tasks
   - **Learning Preparation**: Generate tasks for knowledge acquisition before implementation
   - **Evolution Tracking**: Create tasks for monitoring context changes during implementation

5. **Task Organization**:
   - Group tasks by ACDD phases: Context Setup, Learning Preparation, Adaptive Foundation, User Stories, Adaptive Polish
   - Map tasks to user stories [US1], [US2], etc. for traceability
   - Tag tasks with context evolution phases [CTX-INIT], [CTX-LEARN], [CTX-ADAPT], [CTX-VALIDATE]
   - Mark parallelizable tasks with [P] tag
   - Identify dependencies between tasks

6. **Quality Validation**:
   - Validate all user stories have corresponding test tasks (if tests requested)
   - Verify adaptive foundation tasks block user story implementation
   - Confirm context validation tasks exist for each phase
   - Check pattern compliance validation tasks are included
   - Ensure learning preparation tasks precede implementation

7. **Stop and report**: Command ends after generating ACDD_TASKS. Report branch, ACDD_TASKS path, and generated task organization.

## ACDD Phases

### Phase 1: Context Setup & Pattern Recognition [CTX-INIT]

1. **Context Pattern Analysis**:
   - Extract context patterns from `/memory/context-map.md`
   - Identify applicable patterns for the current feature
   - Document context change triggers relevant to this feature

2. **Project Structure Setup**:
   - Generate tasks for creating project structure per implementation plan
   - Include context tracking mechanisms in setup tasks
   - Configure context evolution monitoring tools

**Output**: Context-aware project setup with pattern recognition capabilities

### Phase 2: Learning Preparation [CTX-LEARN]

**Prerequisites**: Context Setup Phase complete

1. **Knowledge Acquisition**:
   - Generate research tasks based on context patterns
   - Create tasks for identifying context change triggers and adaptation points
   - Prepare validation criteria and metrics for context evolution

2. **Preparation Tasks**:
   - Set up context monitoring and feedback collection mechanisms
   - Configure pattern compliance checking tools
   - Prepare context evolution validation frameworks

**Output**: Complete learning preparation with context awareness ready for adaptive implementation

### Phase 3: Adaptive Foundation [CTX-ADAPT]

**Prerequisites**: Learning Preparation Phase complete

1. **Blocking Prerequisites**:
   - Generate adaptive database schema tasks with context evolution support
   - Create context-aware authentication/authorization framework tasks
   - Setup adaptive API routing with context evolution middleware
   - Create adaptive base models/entities with context tracking
   - Configure adaptive error handling and context-aware logging
   - Setup context-aware environment configuration management

2. **Foundation Validation**:
   - Include pattern compliance validation tasks
   - Add constitutional compliance checks
   - Create readiness validation tasks

**Output**: Adaptive foundation ready for user story implementation with context awareness

### Phase 4+: User Stories [US1, US2, etc.] [CTX-VALIDATE]

**Prerequisites**: Adaptive Foundation Phase complete

1. **User Story Task Generation**:
   - Extract user stories from feature specification
   - Generate context-aware implementation tasks for each story
   - Include test tasks for context validation
   - Add pattern compliance validation for each story

2. **Story Organization**:
   - Organize tasks by user story for independent implementation
   - Include cross-story integration tasks where needed
   - Add context validation tasks for story interactions

**Output**: Complete set of user story tasks with context awareness and pattern compliance

### Final Phase: Adaptive Polish [CTX-VALIDATE]

**Prerequisites**: Desired user stories complete

1. **Polish Tasks**:
   - Context-aware documentation updates
   - Adaptive code cleanup and refactoring
   - Performance optimization with context-aware profiling
   - Additional context-aware unit tests
   - Security hardening with context-aware validation
   - Quickstart validation with context evolution scenarios
   - Pattern compliance validation against constitution.md
   - Context evolution tracking verification

**Output**: Complete, polished implementation with context awareness and pattern compliance

## Key Rules

- Use absolute paths
- Generate context-aware tasks with appropriate [CTX-xxx] tags
- Include pattern compliance validation throughout
- Ensure user stories can be implemented independently with context awareness
- Mark parallelizable tasks with [P] tag
- Create proper dependency chains for adaptive implementation
- Include constitutional compliance validation tasks
- Add context evolution tracking tasks
