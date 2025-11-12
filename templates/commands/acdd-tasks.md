---
description: Generate an actionable, dependency-ordered ACDD tasks.md for the feature based on available design artifacts with adaptive context tracking.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load design documents**: Read from FEATURE_DIR:
   - **Required**: plan.md (tech stack, libraries, structure), spec.md (user stories with priorities)
   - **Adaptive Context**: context-map.md (context patterns), context-evolution logs from memory/
   - **Optional**: data-model.md (entities), contracts/ (API endpoints), research.md (decisions), quickstart.md (test scenarios)
   - Note: Not all projects have all documents. Generate tasks based on what's available.

3. **Execute ACDD task generation workflow**:
   - Load plan.md and extract tech stack, libraries, project structure
   - Load spec.md and extract user stories with their priorities (P1, P2, P3, etc.)
   - If context-map.md exists: Extract context patterns and adaptation points
   - If data-model.md exists: Extract entities and map to user stories
   - If contracts/ exists: Map endpoints to user stories
   - If research.md exists: Extract decisions for setup tasks
   - If memory/context/ exists: Analyze context evolution patterns for adaptive requirements
   - Generate adaptive tasks organized by user story (see ACDD Task Generation Rules below)
   - Generate context evolution dependency graph showing adaptation points
   - Create parallel execution examples per user story with context awareness
   - Validate adaptive task completeness (each user story has all needed tasks, independently testable with context awareness)

4. **Generate acdd-tasks.md**: Use `templates/acdd-tasks-template.md` as structure, fill with:
   - Correct feature name from plan.md
   - Phase 1: Context Setup & Pattern Recognition (context pattern analysis)
   - Phase 2: Learning Preparation (knowledge acquisition for adaptive implementation)
   - Phase 3: Adaptive Foundation (blocking prerequisites for all user stories with context awareness)
   - Phase 4+: One phase per user story (in priority order from spec.md) with adaptive implementation
   - Each phase includes: story goal, independent test criteria, context adaptation points, tests (if requested), implementation tasks
   - Final Phase: Adaptive Polish & Context Validation
   - All tasks must follow the strict ACDD checklist format (see ACDD Task Generation Rules below)
   - Clear file paths for each task
   - Dependencies section showing story completion order
   - Parallel execution examples per story
   - Implementation strategy section (Adaptive MVP first, incremental delivery)
   - Pattern compliance validation section
   - Context evolution validation section

5. **Report**: Output path to generated acdd-tasks.md and summary:
   - Total task count
   - Task count per user story
   - Parallel opportunities identified
   - Independent test criteria for each story
   - Suggested Adaptive MVP scope (typically just User Story 1 with context awareness)
   - Context evolution tracking points identified
   - Pattern compliance validation points
   - Format validation: Confirm ALL tasks follow the ACDD checklist format (checkbox, ID, labels, file paths, context tags)

Context for ACDD task generation: {ARGS}

The acdd-tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context, while maintaining adaptive context awareness.

## ACDD Task Generation Rules

**CRITICAL**: Tasks MUST be organized by user story to enable independent implementation and testing with adaptive context awareness.

**Tests are OPTIONAL**: Only generate test tasks if explicitly requested in the feature specification or if user requests TDD approach.

**Context Evolution Tracking is MANDATORY**: All tasks must include appropriate context tags and consider adaptive implementation requirements.

### ACDD Checklist Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [Story?] [Context?] Description with file path
```

**Format Components**:

1. **Checkbox**: ALWAYS start with `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different files, no dependencies on incomplete tasks)
4. **[Story] label**: REQUIRED for user story phase tasks only
   - Format: [US1], [US2], [US3], etc. (maps to user stories from spec.md)
   - Context Setup phase: NO story label
   - Learning Preparation phase: NO story label
   - Adaptive Foundation phase: NO story label
   - User Story phases: MUST have story label
   - Adaptive Polish phase: NO story label
5. **[Context] tag**: REQUIRED for ALL tasks to indicate context evolution phase
   - Format: [CTX-INIT], [CTX-LEARN], [CTX-ADAPT], [CTX-VALIDATE]
   - Maps to ACDD methodology phases: Initialization, Learning, Adaptation, Validation
6. **Description**: Clear action with exact file path and context awareness

**Examples**:

- ✅ CORRECT: `- [ ] T001 [CTX-INIT] Create project structure with context tracking per implementation plan`
- ✅ CORRECT: `- [ ] T005 [P] [CTX-ADAPT] Implement context-aware authentication middleware in src/middleware/auth.py`
- ✅ CORRECT: `- [ ] T012 [P] [US1] [CTX-INIT] Create adaptive User model in src/models/user.py with context tracking`
- ✅ CORRECT: `- [ ] T014 [US1] [CTX-ADAPT] Implement adaptive UserService in src/services/user_service.py`
- ✅ CORRECT: `- [ ] T016 [US1] [CTX-VALIDATE] Validate pattern compliance against constitution.md`
- ❌ WRONG: `- [ ] Create adaptive User model` (missing ID, Context tag, and Story label)
- ❌ WRONG: `T001 [US1] [CTX-INIT] Create model` (missing checkbox)
- ❌ WRONG: `- [ ] [US1] [CTX-INIT] Create adaptive User model` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [US1] Create adaptive model` (missing Context tag)
- ❌ WRONG: `- [ ] T001 [CTX-INIT] Create model` (missing Story label for user story task)

### ACDD Task Organization

1. **From User Stories (spec.md)** - PRIMARY ORGANIZATION:
   - Each user story (P1, P2, P3...) gets its own adaptive phase
   - Map all related components to their story with context awareness:
     - Adaptive models needed for that story
     - Adaptive services needed for that story
     - Adaptive endpoints/UI needed for that story
     - If tests requested: Tests specific to that story with context validation
   - Mark story dependencies (most stories should be independent but context-aware)

2. **From Context Patterns (context-map.md)**:
   - Map each context pattern → to the user story it affects
   - Identify adaptation points for each story phase
   - Context change triggers → adaptive implementation tasks

3. **From Contracts**:
   - Map each contract/endpoint → to the user story it serves
   - If tests requested: Each contract → contract test task [P] before implementation in that story's phase
   - Context-aware contract validation tasks

4. **From Data Model**:
   - Map each entity to the user story(ies) that need it with context tracking
   - If entity serves multiple stories: Put in earliest story or Adaptive Foundation phase
   - Relationships → adaptive service layer tasks in appropriate story phase

5. **From Adaptive Infrastructure**:
   - Context-aware infrastructure → Context Setup phase (Phase 1)
   - Learning preparation → Learning Preparation phase (Phase 2)
   - Adaptive foundational/blocking tasks → Adaptive Foundation phase (Phase 3)
   - Story-specific adaptive setup → within that story's phase

### ACDD Phase Structure

- **Phase 1**: Context Setup & Pattern Recognition (context pattern analysis)
- **Phase 2**: Learning Preparation (knowledge acquisition for adaptive implementation)
- **Phase 3**: Adaptive Foundation (blocking prerequisites - MUST complete before user stories with context awareness)
- **Phase 4+**: User Stories in priority order (P1, P2, P3...) with adaptive implementation
  - Within each story: Context Setup → Learning → Tests (if requested) → Adaptive Models → Adaptive Services → Adaptive Endpoints → Integration → Validation
  - Each phase should be a complete, independently testable increment with context awareness
- **Final Phase**: Adaptive Polish & Context Validation

### Context Evolution Requirements

1. **Context Change Detection**:
   - Identify triggers that may require adaptation during implementation
   - Set up monitoring for context changes that affect this feature
   - Document initial context assumptions

2. **Adaptive Implementation**:
   - All components should be designed with context awareness
   - Include mechanisms for adaptation when context changes
   - Implement context-aware error handling and recovery

3. **Context Validation**:
   - Validate that adaptive components work as expected
   - Test context evolution scenarios
   - Verify context consistency across user stories
   - Confirm context-aware logging captures all relevant events

4. **Pattern Compliance**:
   - Ensure all adaptive implementations comply with constitutional principles
   - Validate that context-aware components follow architectural patterns
   - Verify that adaptation mechanisms don't violate core principles

### ACDD Quality Validation

Every generated task must consider:

- **Pattern Compliance**: Does the task ensure constitutional compliance?
- **Context Awareness**: Does the task consider context evolution requirements?
- **Adaptive Implementation**: Does the task support adaptation to changing contexts?
- **Validation**: Does the task include validation for context-aware behavior?
- **Learning**: Does the task contribute to or utilize context learning?

</template>
