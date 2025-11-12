---
description: Clarify specification details with ACDD pattern considerations.
scripts:
  sh: scripts/bash/common.sh
  ps: scripts/powershell/common.ps1
---

# User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/acdd.clarify` in the triggering message **is** the clarification request. This command resolves ambiguities in the feature specification with special attention to ACDD patterns and learning preparation.

Given that clarification request, do this:

1. **Load the current specification file** from the current feature branch
   - Identify SPEC_FILE based on current branch name pattern (e.g., `001-feature-name/spec.md`)
   - If no spec exists: ERROR "No specification file found in current branch/directory"

2. **Analyze the clarification request**:
   - Identify which parts of the specification need clarification
   - Note any pattern-related questions or concerns
   - Consider how clarifications might affect learning preparation

3. **Update the specification** based on user input:
   - Address all clarification points raised
   - Update pattern references if needed
   - Revise learning preparation elements as necessary
   - Ensure consistency with ACDD methodology

4. **Validate specification quality** against ACDD criteria:

   a. **Update Spec Quality Checklist**: Locate `FEATURE_DIR/checklists/requirements.md` and update validation status with these items:

      ```markdown
      # Specification Quality Checklist: [FEATURE NAME] - Clarification Update

      **Purpose**: Validate specification updates after clarification
      **Updated**: [DATE]
      **Feature**: [Link to spec.md]

      ## Content Quality

      - [X] No implementation details (languages, frameworks, APIs)
      - [X] Focused on user value and business needs
      - [X] Written for non-technical stakeholders
      - [X] All mandatory sections completed

      ## ACDD-Specific Requirements

      - [X] Relevant team patterns identified from `.acdd/context/team-patterns.md`
      - [X] Pattern application approach documented
      - [X] Learning preparation elements included
      - [X] Context evolution considerations noted

      ## Requirement Completeness

      - [X] No [NEEDS CLARIFICATION] markers remain (resolved in this session)
      - [X] Requirements are testable and unambiguous
      - [X] Success criteria are measurable
      - [X] Success criteria are technology-agnostic (no implementation details)
      - [X] All acceptance scenarios are defined
      - [X] Edge cases are identified
      - [X] Scope is clearly bounded
      - [X] Dependencies and assumptions identified

      ## Feature Readiness

      - [X] All functional requirements have clear acceptance criteria
      - [X] User scenarios cover primary flows
      - [X] Feature meets measurable outcomes defined in Success Criteria
      - [X] Pattern application approach is clear
      - [X] Learning preparation is adequate

      ## Clarification Resolution

      - [ ] All user clarification requests addressed
      - [ ] Specification updated based on clarifications
      - [ ] Pattern references revised if needed
      - [ ] Learning preparation updated if needed

      ## Notes

      - Clarification details: [What was clarified in this session]
      - Updated elements: [What was changed in the spec]
      - Pattern implications: [How clarifications affect patterns]
      ```

   b. **Update the checklist** with current status for each item
   c. **Mark clarification-specific items as complete** after processing user input

5. **Verify ACDD alignment**:
   - Confirm pattern references are still appropriate after clarifications
   - Ensure learning preparation elements remain adequate
   - Check that context evolution considerations are still valid

6. Report completion with spec file path, updated checklist, and readiness for the next phase (`/acdd.plan`).

## General Guidelines

## Quick Guidelines

- Address the specific clarification requested by the user
- Maintain focus on WHAT users need and WHY
- Preserve ACDD pattern awareness throughout
- Update learning preparation as needed
- Ensure specification remains technology-agnostic

### Section Requirements

- **Update affected sections**: Only modify sections that relate to the clarification request
- **Maintain ACDD elements**: Keep pattern references, learning preparation, and context considerations
- **Preserve structure**: Don't change the overall specification template structure
- **Document changes**: Note what was clarified and how it affected the spec

### For AI Generation

When clarifying specifications:

1. **Address specific concerns**: Focus on the exact clarification requested
2. **Preserve context**: Don't remove existing information unless explicitly changed
3. **Maintain pattern awareness**: Ensure any clarifications align with team patterns
4. **Consider learning impact**: How does this clarification affect learning preparation?
5. **Keep it measurable**: Ensure success criteria remain verifiable

### ACDD Integration

When clarifying specifications:

1. **Pattern consistency**: Ensure clarifications don't conflict with documented patterns
2. **Learning preparation**: Update learning considerations based on clarifications
3. **Context awareness**: Consider how clarifications affect the living context model
4. **Adaptation readiness**: Ensure clarifications support future adaptation phases
