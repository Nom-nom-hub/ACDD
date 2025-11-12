#!/bin/bash

set -e

# Setup plan script for ACDD

JSON_MODE=false
FEATURE_NAME=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_MODE=true
            shift
            ;;
        --feature)
            FEATURE_NAME="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Usage: $0 [--json] [--feature <feature_name>]" >&2
            exit 1
            ;;
    esac
done

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Find repository root
REPO_ROOT=$(find_repo_root "$SCRIPT_DIR")
if [ $? -ne 0 ]; then
    echo "Error: Could not find ACDD repository root." >&2
    exit 1
fi

# Validate this is an ACDD project
validate_acdd_project "$REPO_ROOT"
if [ $? -ne 0 ]; then
    exit 1
fi

# Determine feature directory if not provided
if [ -z "$FEATURE_NAME" ]; then
    FEATURE_DIR=$(get_feature_dir "$REPO_ROOT")
    if [ $? -ne 0 ]; then
        echo "Error: Could not determine feature directory. Please specify --feature or run in a feature directory." >&2
        exit 1
    fi
else
    # Use provided feature name to construct feature directory path
    FEATURE_DIR="$REPO_ROOT/specs/$FEATURE_NAME"
    if [ ! -d "$FEATURE_DIR" ]; then
        echo "Error: Feature directory does not exist: $FEATURE_DIR" >&2
        exit 1
    fi
fi

# Validate feature directory
validate_feature_dir "$FEATURE_DIR"
if [ $? -ne 0 ]; then
    exit 1
fi

# Get feature number
FEATURE_NUMBER=$(get_feature_number "$FEATURE_DIR")
if [ $? -ne 0 ]; then
    echo "Error: Could not extract feature number from directory name: $FEATURE_DIR" >&2
    exit 1
fi

# Set up plan file
PLAN_FILE="$FEATURE_DIR/plan.md"

# Check if plan already exists to avoid overwriting
if [ -f "$PLAN_FILE" ]; then
    echo "Plan file already exists at $PLAN_FILE" >&2
    if [ "$JSON_MODE" = true ]; then
        printf '{"PLAN_FILE":"%s","FEATURE_DIR":"%s","FEATURE_NUMBER":"%s","WARNING":"File already exists"}\n' "$PLAN_FILE" "$FEATURE_DIR" "$FEATURE_NUMBER"
    else
        echo "PLAN_FILE: $PLAN_FILE"
        echo "FEATURE_DIR: $FEATURE_DIR"
        echo "FEATURE_NUMBER: $FEATURE_NUMBER"
    fi
    exit 0
fi

# Get plan template
PLAN_TEMPLATE=$(get_template_file "plan-template.md" "$REPO_ROOT")
if [ $? -ne 0 ]; then
    echo "Error: Could not find plan template in templates/plan-template.md" >&2
    exit 1
fi

# Create plan file from template
cp "$PLAN_TEMPLATE" "$PLAN_FILE"

# Replace placeholders in the plan file
sed -i.bak "s/{FEATURE_NAME}/$(basename "$FEATURE_DIR")/g" "$PLAN_FILE"
sed -i.bak "s/{FEATURE_NUMBER}/$FEATURE_NUMBER/g" "$PLAN_FILE"
sed -i.bak "s/{DATE}/$(date -u)/g" "$PLAN_FILE"
if [ -v USER ]; then
    sed -i.bak "s/{AUTHOR}/$USER/g" "$PLAN_FILE"
else
    sed -i.bak "s/{AUTHOR}/$(whoami)/g" "$PLAN_FILE"
fi

# Remove backup files created by sed
rm -f "$PLAN_FILE.bak"

# Create checklists directory if it doesn't exist
CHECKLISTS_DIR="$FEATURE_DIR/checklists"
mkdir -p "$CHECKLISTS_DIR"

# Set up ACDD-specific directories and files for this feature
ACDD_FEATURE_DIR="$REPO_ROOT/.acdd/specs/$(basename "$FEATURE_DIR")"
mkdir -p "$ACDD_FEATURE_DIR"

# Output results
if $JSON_MODE; then
    printf '{"PLAN_FILE":"%s","FEATURE_DIR":"%s","FEATURE_NUMBER":"%s","STATUS":"CREATED"}\n' "$PLAN_FILE" "$FEATURE_DIR" "$FEATURE_NUMBER"
else
    echo "PLAN_FILE: $PLAN_FILE"
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "FEATURE_NUMBER: $FEATURE_NUMBER"
    echo "Status: Plan file created successfully"
fi