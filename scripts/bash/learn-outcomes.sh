#!/bin/bash

set -e

# Learn outcomes script for ACDD

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

# Check if learning report already exists to avoid overwriting
LEARNING_FILE="$FEATURE_DIR/learning-report.md"
if [ -f "$LEARNING_FILE" ]; then
    echo "Learning report already exists at $LEARNING_FILE" >&2
    if [ "$JSON_MODE" = true ]; then
        printf '{"LEARNING_FILE":"%s","FEATURE_DIR":"%s","FEATURE_NUMBER":"%s","WARNING":"File already exists"}\n' "$LEARNING_FILE" "$FEATURE_DIR" "$FEATURE_NUMBER"
    else
        echo "LEARNING_FILE: $LEARNING_FILE"
        echo "FEATURE_DIR: $FEATURE_DIR"
        echo "FEATURE_NUMBER: $FEATURE_NUMBER"
    fi
    exit 0
fi

# Get learn template
LEARN_TEMPLATE=$(get_template_file "learn-template.md" "$REPO_ROOT")
if [ $? -ne 0 ]; then
    echo "Error: Could not find learn template in templates/learn-template.md" >&2
    exit 1
fi

# Create learning report from template
cp "$LEARN_TEMPLATE" "$LEARNING_FILE"

# Replace placeholders in the learning report file
sed -i.bak "s/{FEATURE_NAME}/$(basename "$FEATURE_DIR")/g" "$LEARNING_FILE"
sed -i.bak "s/{FEATURE_NUMBER}/$FEATURE_NUMBER/g" "$LEARNING_FILE"
sed -i.bak "s/{DATE}/$(date -u)/g" "$LEARNING_FILE"
if [ -v USER ]; then
    sed -i.bak "s/{AUTHOR}/$USER/g" "$LEARNING_FILE"
else
    sed -i.bak "s/{AUTHOR}/$(whoami)/g" "$LEARNING_FILE"
fi

# Remove backup files created by sed
rm -f "$LEARNING_FILE.bak"

# Create learning directory if it doesn't exist
LEARNING_DIR="$FEATURE_DIR/learning"
mkdir -p "$LEARNING_DIR"

# Set up ACDD-specific learning directories and files for this feature
ACDD_FEATURE_DIR="$REPO_ROOT/.acdd/specs/$(basename "$FEATURE_DIR")"
mkdir -p "$ACDD_FEATURE_DIR/learning"

# Output results
if $JSON_MODE; then
    printf '{"LEARNING_FILE":"%s","FEATURE_DIR":"%s","FEATURE_NUMBER":"%s","STATUS":"CREATED"}\n' "$LEARNING_FILE" "$FEATURE_DIR" "$FEATURE_NUMBER"
else
    echo "LEARNING_FILE: $LEARNING_FILE"
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "FEATURE_NUMBER: $FEATURE_NUMBER"
    echo "Status: Learning report created successfully"
fi