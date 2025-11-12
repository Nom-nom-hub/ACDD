---
description: Execute the implementation phase using ACDD methodology with pattern validation, learning evidence collection, and context updates for the learn phase.
scripts:
  sh: scripts/bash/acdd-implement.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/acdd-implement.ps1 -Json -RequireTasks -IncludeTasks
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. Run `{SCRIPT}` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Validate ACDD prerequisites** (if FEATURE_DIR/ exists):
   - Verify `tasks.md` exists with complete task breakdown
   - Verify `plan.md` exists with technical architecture
   - Verify `acdd-checklist.md` exists for ACDD-specific quality checks
   - Verify `spec.md` exists for reference
   - Check if `implement.md` exists (if so, this is a continuation)

   **If any prerequisite missing**:
   - List missing files
   - **STOP** and ask: "Some ACDD prerequisites are missing. Run the appropriate commands to generate them first. Continue anyway? (yes/no)"
   - Wait for user response before continuing
   - If user says "no" or "wait" or "stop", halt execution
   - If user says "yes" or "proceed" or "continue", proceed to step 3

3. **Load ACDD implementation context**:
   - **REQUIRED**: Read `tasks.md` for the complete task list and execution plan
   - **REQUIRED**: Read `plan.md` for tech stack, architecture, and file structure
   - **REQUIRED**: Read `acdd-checklist.md` for ACDD-specific quality gates
   - **REQUIRED**: Read `spec.md` for functional requirements reference
   - **IF EXISTS**: Read `data-model.md` for entities and relationships
   - **IF EXISTS**: Read `contracts/` for API specifications and test requirements
   - **IF EXISTS**: Read `research.md` for technical decisions and constraints
   - **IF EXISTS**: Read `quickstart.md` for integration scenarios
   - **IF EXISTS**: Read previous `implement.md` for continuation context

4. **ACDD Pattern Validation Check**:
   - **REQUIRED**: Identify expected patterns from `plan.md` and `research.md`
   - **Scan implementation tasks** for pattern compliance:
     - For each task, determine which patterns should apply
     - Check if the implementation approach aligns with expected patterns
     - Note any deviations or adaptations needed
   - **Create pattern validation table**:

     ```text
     | Task | Expected Pattern | Pattern Applied | Status | Deviation Notes |
     |------|------------------|-----------------|--------|-----------------|
     | Task 1 | Repository Pattern | Applied | ✓ PASS | None |
     | Task 2 | Observer Pattern | Adapted | ✓ ADAPTED | Modified for async |
     | Task 3 | Factory Pattern | Challenging | ⚠️ CHALLENGING | Not suitable for context |
     ```

   - **Pattern effectiveness criteria**:
     - **PASS**: Pattern applied as expected
     - **ADAPTED**: Pattern modified appropriately for context
     - **CHALLENGING**: Pattern difficult to apply (requires analysis in learn phase)
     - **FAIL**: Pattern not applied when it should have been

   - **If any patterns are FAIL status**:
     - Document specific issues
     - **STOP** and ask: "Critical pattern compliance issues detected. Do you want to address them now or continue with implementation? (address/continue)"
     - Wait for user response before continuing

   - **If all patterns are PASS or ADAPTED**:
     - Document any CHALLENGING patterns for learn phase
     - Proceed to step 5

5. **Project Setup Verification**:
   - **REQUIRED**: Create/verify ignore files based on actual project setup:

   **Detection & Creation Logic**:
   - Check if the following command succeeds to determine if the repository is a git repo (create/verify .gitignore if so):

     ```sh
     git rev-parse --git-dir 2>/dev/null
     ```

   - Check if Dockerfile* exists or Docker in plan.md → create/verify .dockerignore
   - Check if .eslintrc*or eslint.config.* exists → create/verify .eslintignore
   - Check if .prettierrc* exists → create/verify .prettierignore
   - Check if .npmrc or package.json exists → create/verify .npmignore (if publishing)
   - Check if terraform files (*.tf) exist → create/verify .terraformignore
   - Check if .helmignore needed (helm charts present) → create/verify .helmignore

   **If ignore file already exists**: Verify it contains essential patterns, append missing critical patterns only
   **If ignore file missing**: Create with full pattern set for detected technology

   **Common Patterns by Technology** (from plan.md tech stack):
   - **Node.js/JavaScript/TypeScript**: `node_modules/`, `dist/`, `build/`, `*.log`, `.env*`
   - **Python**: `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `dist/`, `*.egg-info/`
   - **Java**: `target/`, `*.class`, `*.jar`, `.gradle/`, `build/`
   - **C#/.NET**: `bin/`, `obj/`, `*.user`, `*.suo`, `packages/`
   - **Go**: `*.exe`, `*.test`, `vendor/`, `*.out`
   - **Ruby**: `.bundle/`, `log/`, `tmp/`, `*.gem`, `vendor/bundle/`
   - **PHP**: `vendor/`, `*.log`, `*.cache`, `*.env`
   - **Rust**: `target/`, `debug/`, `release/`, `*.rs.bk`, `*.rlib`, `*.prof*`, `.idea/`, `*.log`, `.env*`
   - **Kotlin**: `build/`, `out/`, `.gradle/`, `.idea/`, `*.class`, `*.jar`, `*.iml`, `*.log`, `.env*`
   - **C++**: `build/`, `bin/`, `obj/`, `out/`, `*.o`, `*.so`, `*.a`, `*.exe`, `*.dll`, `.idea/`, `*.log`, `.env*`
   - **C**: `build/`, `bin/`, `obj/`, `out/`, `*.o`, `*.a`, `*.so`, `*.exe`, `Makefile`, `config.log`, `.env*`
   - **Swift**: `.build/`, `DerivedData/`, `*.swiftpm/`, `Packages/`
   - **R**: `.Rproj.user/`, `.Rhistory`, `.RData`, `.Ruserdata`, `*.Rproj`, `packrat/`, `renv/`
   - **Universal**: `.DS_Store`, `Thumbs.db`, `*.tmp`, `*.swp`, `.vscode/`, `.idea/`

   **Tool-Specific Patterns**:
   - **Docker**: `node_modules/`, `.git/`, `Dockerfile*`, `.dockerignore`, `*.log*`, `.env*`, `coverage/`
   - **ESLint**: `node_modules/`, `dist/`, `build/`, `coverage/`, `*.min.js`
   - **Prettier**: `node_modules/`, `dist/`, `build/`, `coverage/`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
   - **Terraform**: `.terraform/`, `*.tfstate*`, `*.tfvars`, `.terraform.lock.hcl`
   - **Kubernetes/k8s**: `*.secret.yaml`, `secrets/`, `.kube/`, `kubeconfig*`, `*.key`, `*.crt`

6. **ACDD-Specific Quality Checks**:
   - **Pattern Application Validation**: Verify patterns from plan are being applied
   - **Learning Evidence Collection**: Ensure evidence is being captured during implementation
   - **Context Update Preparation**: Identify what context needs updating post-implementation
   - **Adaptation Readiness**: Check if implementation is creating data for adaptation phase

   **Execute ACDD checklist** from `acdd-checklist.md`:
   - For each checklist item, determine pass/fail status
   - Document evidence for each item
   - Create status table:

     ```text
     | ACDD Quality Item | Status | Evidence | Notes |
     |-------------------|--------|----------|-------|
     | Pattern validation | ✓ PASS | Patterns applied as planned | None |
     | Evidence collection | ✓ PASS | Time, quality, and effectiveness metrics captured | See implement.md |
     | Context updates | ⚠️ PARTIAL | Architecture updates identified | Need to document |
     | Learning readiness | ✓ PASS | Data prepared for learn phase | Ready for analysis |
     ```

7. **Parse tasks.md structure and extract**:
   - **Task phases**: Setup, Tests, Core, Integration, Polish
   - **Task dependencies**: Sequential vs parallel execution rules
   - **Task details**: ID, description, file paths, parallel markers [P]
   - **Pattern requirements**: Which patterns should apply to each task
   - **Evidence collection points**: Where to capture learning evidence
   - **Execution flow**: Order and dependency requirements

8. **Execute implementation following the task plan with ACDD focus**:
   - **Phase-by-phase execution**: Complete each phase before moving to the next
   - **Respect dependencies**: Run sequential tasks in order, parallel tasks [P] can run together
   - **Follow TDD approach**: Execute test tasks before their corresponding implementation tasks
   - **File-based coordination**: Tasks affecting the same files must run sequentially
   - **Pattern validation checkpoints**: Verify pattern application at each phase
   - **Learning evidence collection**: Capture metrics at each completed task
   - **Context update identification**: Note what context needs updating

9. **ACDD Implementation Execution Rules**:
   - **Setup first**: Initialize project structure, dependencies, configuration
     - Apply architectural patterns from plan
     - Set up monitoring for pattern effectiveness
     - Prepare evidence collection mechanisms
   - **Tests before code**: Write tests that validate pattern application
     - Create tests that verify patterns are working as expected
     - Set up performance baselines for pattern effectiveness
     - Establish metrics for pattern success/failure
   - **Core development**: Implement models, services, CLI commands, endpoints
     - Apply patterns as specified in plan and research
     - Document any deviations from expected patterns
     - Collect evidence of pattern effectiveness
     - Note any challenges with pattern application
   - **Integration work**: Database connections, middleware, logging, external services
     - Validate cross-cutting pattern interactions
     - Monitor for pattern conflicts or incompatibilities
     - Collect integration-specific evidence
   - **Polish and validation**: Unit tests, performance optimization, documentation
     - Verify all patterns work together effectively
     - Collect final effectiveness metrics
     - Prepare comprehensive evidence for learn phase

10. **Learning Evidence Collection During Implementation**:
    - **Time Tracking**: Log planned vs actual time for each task
    - **Pattern Effectiveness**: Record how well each pattern performed
    - **Quality Metrics**: Capture test coverage, code complexity, defect rates
    - **Deviation Documentation**: Note where patterns were adapted or challenged
    - **Unexpected Learnings**: Record surprises during implementation
    - **Context Updates Needed**: Identify what context needs updating

11. **Progress tracking and error handling**:
    - Report progress after each completed task
    - Halt execution if any non-parallel task fails
    - For parallel tasks [P], continue with successful tasks, report failed ones
    - Provide clear error messages with context for debugging
    - Suggest next steps if implementation cannot proceed
    - **IMPORTANT** For completed tasks, make sure to mark the task off as [X] in the tasks file
    - **ACDD-SPECIFIC**: For each completed task, update the `implement.md` file with:
      - Pattern applied status
      - Evidence collected
      - Any deviations or challenges
      - Time taken vs planned

12. **ACDD-Specific Completion Validation**:
    - Verify all required tasks are completed
    - Check that implemented features match the original specification
    - Validate that patterns were applied as planned
    - Confirm that learning evidence was collected
    - Verify that context updates are identified
    - Ensure the implementation is ready for the learn phase
    - Report final status with summary of completed work and learning evidence

13. **Prepare for Learn Phase**:
    - **Generate ACDD Summary**: Create or update `ACDD-SUMMARY.md` with:
      - Pattern effectiveness analysis
      - Time and quality metrics
      - Deviations and challenges encountered
      - Recommendations for future implementations
    - **Update Context**: Prepare context updates for:
      - Architecture decisions made
      - Pattern library updates needed
      - Team capability changes
    - **Handoff Preparation**: Ensure all evidence is captured in `implement.md` and ready for analysis

14. **Final ACDD Validation**:
    - **Pattern Application**: All planned patterns were applied or appropriately adapted
    - **Evidence Collection**: All required learning evidence was captured
    - **Context Updates**: All necessary context changes are identified
    - **Learn Phase Readiness**: Implementation is ready for analysis in learn phase

    **Generate final status table**:

    ```text
    | ACDD Validation Item | Status | Details |
    |----------------------|--------|---------|
    | Pattern Application | ✓ PASS/⚠️ PARTIAL/✗ FAIL | [Details] |
    | Evidence Collection | ✓ PASS/⚠️ PARTIAL/✗ FAIL | [Details] |
    | Context Updates | ✓ PASS/⚠️ PARTIAL/✗ FAIL | [Details] |
    | Learn Phase Ready | ✓ PASS/⚠️ PARTIAL/✗ FAIL | [Details] |
    ```

Note: This command assumes a complete task breakdown exists in tasks.md and follows ACDD methodology with focus on pattern validation, learning evidence collection, and preparation for the learn phase. If tasks are incomplete or missing, suggest running `/acdd.tasks` first to regenerate the task list. If ACDD-specific artifacts are missing, suggest running appropriate ACDD commands to generate them.
