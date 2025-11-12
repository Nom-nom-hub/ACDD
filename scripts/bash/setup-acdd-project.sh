#!/bin/bash

set -e

# Setup ACDD project script

JSON_MODE=false
PROJECT_DESCRIPTION=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_MODE=true
            shift
            ;;
        *)
            PROJECT_DESCRIPTION="$*"
            break
            ;;
    esac
done

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Find repository root
REPO_ROOT=$(find_repo_root "$SCRIPT_DIR")
if [ $? -ne 0 ]; then
    echo "Error: Could not find repository root." >&2
    exit 1
fi

# Check if this is already an ACDD project
if [ -d "$REPO_ROOT/.acdd" ]; then
    if [ "$JSON_MODE" = true ]; then
        printf '{"ERROR":"Already an ACDD project","PROJECT_PATH":"%s"}\n' "$REPO_ROOT"
    else
        echo "Error: This is already an ACDD project." >&2
    fi
    exit 1
fi

# Create ACDD directory structure
ACDD_DIR="$REPO_ROOT/.acdd"
mkdir -p "$ACDD_DIR"
mkdir -p "$ACDD_DIR/context"
mkdir -p "$ACDD_DIR/memory"
mkdir -p "$ACDD_DIR/specs"
mkdir -p "$ACDD_DIR/context/metrics"

# Create initial context files
cat > "$ACDD_DIR/context/team-patterns.md" << 'EOL'
# Team Pattern Library

> A living record of proven, repeatable approaches to solving problems in our team.
> Patterns evolve as we learn what works.

## How to Use This Library

1. **Finding Patterns**: Look for patterns matching your use case
2. **Understanding Impact**: Check velocity/quality metrics for evidence
3. **Applying Patterns**: Reference the example code and follow the approach
4. **Suggesting Updates**: Document deviations and suggest improvements via Learning phase

## Patterns

*(None yet - create your first pattern via ACDD commands)*

---
**Last Updated**: $(date -u)
EOL

cat > "$ACDD_DIR/context/architecture-evolution.md" << 'EOL'
# Architecture Evolution Map

> Timeline of architectural decisions and their outcomes.
> Shows how our architecture evolved and why each decision was made.

## How to Use This Map

- **Understanding**: See why each architectural decision was made
- **Evolution**: Understand the progression and constraints
- **Decisions**: Prepare for next evolution by learning from past outcomes

## Decisions

*(None yet - document decisions during the Specify phase)*

---
**Last Updated**: $(date -u)
EOL

# Create initial constitution file if it doesn't exist
CONSTITUTION_FILE="$REPO_ROOT/constitution.md"
if [ ! -f "$CONSTITUTION_FILE" ]; then
    CONSTITUTION_TEMPLATE=$(get_template_file "constitution.md" "$REPO_ROOT")
    if [ $? -eq 0 ]; then
        cp "$CONSTITUTION_TEMPLATE" "$CONSTITUTION_FILE"
    else
        # Create a minimal constitution if template not found
        cat > "$CONSTITUTION_FILE" << EOL
# Project Constitution

**Project**: ${PROJECT_DESCRIPTION:-"New ACDD Project"}
**Date**: $(date -u)
**Status**: Initial

## Purpose

This project follows the **Adaptive Context-Driven Development (ACDD)** methodology, an evolution of Spec-Driven Development that incorporates continuous learning and adaptation.

## Core Principles

### Living Context Model
- Context is multidimensional and evolving, not static
- Team patterns, architecture decisions, metrics, and preferences are continuously updated
- Knowledge from past features directly improves future development

### Continuous Learning
- Every feature contributes to organizational learning
- Outcomes are systematically analyzed and documented
- Pattern effectiveness is continuously measured

### Adaptive Methodology
- Development approach evolves based on evidence
- Patterns are refined and updated based on usage outcomes
- Team capabilities and preferences are tracked and leveraged

## Development Workflow

The complete ACDD workflow consists of 9 phases:

1. **Constitution** - Establish project principles and context
2. **Specify** - Define requirements with context awareness 
3. **Clarify** - Resolve specification ambiguities
4. **Plan** - Create implementation plan referencing patterns
5. **Analyze** - Cross-artifact consistency check
6. **Tasks** - Break plan into actionable tasks
7. **Implement** - Execute implementation
8. **Learn** - Analyze outcomes and capture learnings
9. **Adapt** - Update patterns and methodology

EOL
    fi
fi

# Create specs directory
mkdir -p "$REPO_ROOT/specs"

if [ "$JSON_MODE" = true ]; then
    printf '{"STATUS":"CREATED","PROJECT_PATH":"%s","ACDD_DIR":"%s","DESCRIPTION":"%s"}\n' "$REPO_ROOT" "$ACDD_DIR" "$PROJECT_DESCRIPTION"
else
    echo "ACDD project initialized in: $REPO_ROOT"
    echo "ACDD directory created: $ACDD_DIR"
    echo "Initial constitution created: $CONSTITUTION_FILE"
    echo "Ready to begin ACDD workflow"
fi