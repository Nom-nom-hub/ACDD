#!/bin/bash

set -e

# Adapt methodology script for ACDD

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

# Check if adaptation report already exists to avoid overwriting
ADAPTATION_FILE="$FEATURE_DIR/adaptation-report.md"
if [ -f "$ADAPTATION_FILE" ]; then
    echo "Adaptation report already exists at $ADAPTATION_FILE" >&2
    if [ "$JSON_MODE" = true ]; then
        printf '{"ADAPTATION_FILE":"%s","FEATURE_DIR":"%s","FEATURE_NUMBER":"%s","WARNING":"File already exists"}\n' "$ADAPTATION_FILE" "$FEATURE_DIR" "$FEATURE_NUMBER"
    else
        echo "ADAPTATION_FILE: $ADAPTATION_FILE"
        echo "FEATURE_DIR: $FEATURE_DIR"
        echo "FEATURE_NUMBER: $FEATURE_NUMBER"
    fi
    exit 0
fi

# Get adapt template
ADAPT_TEMPLATE=$(get_template_file "adapt-template.md" "$REPO_ROOT")
if [ $? -ne 0 ]; then
    echo "Error: Could not find adapt template in templates/adapt-template.md" >&2
    exit 1
fi

# Create adaptation report from template
cp "$ADAPT_TEMPLATE" "$ADAPTATION_FILE"

# Replace placeholders in the adaptation report file
sed -i.bak "s/{FEATURE_NAME}/$(basename "$FEATURE_DIR")/g" "$ADAPTATION_FILE"
sed -i.bak "s/{FEATURE_NUMBER}/$FEATURE_NUMBER/g" "$ADAPTATION_FILE"
sed -i.bak "s/{DATE}/$(date -u)/g" "$ADAPTATION_FILE"
if [ -v USER ]; then
    sed -i.bak "s/{AUTHOR}/$USER/g" "$ADAPTATION_FILE"
else
    sed -i.bak "s/{AUTHOR}/$(whoami)/g" "$ADAPTATION_FILE"
fi

# Remove backup files created by sed
rm -f "$ADAPTATION_FILE.bak"

# Create adaptation directory if it doesn't exist
ADAPTATION_DIR="$FEATURE_DIR/adaptation"
mkdir -p "$ADAPTATION_DIR"

# Set up ACDD-specific adaptation directories and files for this feature
ACDD_FEATURE_DIR="$REPO_ROOT/.acdd/specs/$(basename "$FEATURE_DIR")"
mkdir -p "$ACDD_FEATURE_DIR/adaptation"

# Update global ACDD context based on adaptation
ACDD_CONTEXT_DIR="$REPO_ROOT/.acdd/context"
if [ -d "$ACDD_CONTEXT_DIR" ]; then
    # Update pattern library with adaptation insights
    PATTERN_LIB_FILE="$ACDD_CONTEXT_DIR/team-patterns.md"
    if [ -f "$PATTERN_LIB_FILE" ]; then
        # Add a timestamp to the patterns file to indicate an adaptation has occurred
        echo -e "\n---\n**Last Adaptation Update**: $(date -u)\n" >> "$PATTERN_LIB_FILE"
    fi
fi

# Output results
if $JSON_MODE; then
    printf '{"ADAPTATION_FILE":"%s","FEATURE_DIR":"%s","FEATURE_NUMBER":"%s","STATUS":"CREATED"}\n' "$ADAPTATION_FILE" "$FEATURE_DIR" "$FEATURE_NUMBER"
else
    echo "ADAPTATION_FILE: $ADAPTATION_FILE"
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "FEATURE_NUMBER: $FEATURE_NUMBER"
    echo "Status: Adaptation report created successfully"
fi