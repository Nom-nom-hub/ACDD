#!/bin/bash

# ACDD Learn Command Script
# Generates learning report from completed features, analyzes pattern effectiveness, and prepares adaptation inputs

set -e  # Exit on any error

# Default values
JSON_OUTPUT=false
FEATURE_DIR=""
LEARN_REPORT=""
PATTERN_LIB_DIR=""
BRANCH=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        *)
            echo "Unknown parameter: $1" >&2
            exit 1
            ;;
    esac
done

if [ "$JSON_OUTPUT" = true ]; then
    # Detect git branch
    if git rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git branch --show-current)
        if [ -z "$BRANCH" ]; then
            BRANCH=$(git rev-parse --short HEAD)  # Use commit hash if detached HEAD
        fi
    else
        BRANCH="main"  # Default fallback
    fi

    # Find the feature directory by looking for spec.md
    for dir in features/*/; do
        if [ -f "${dir}spec.md" ]; then
            FEATURE_DIR=$(realpath "$dir")
            break
        fi
    done

    # If no feature directory found, try current directory
    if [ -z "$FEATURE_DIR" ] && [ -f "spec.md" ]; then
        FEATURE_DIR=$(pwd)
    fi

    # Set LEARN_REPORT path
    if [ -n "$FEATURE_DIR" ]; then
        LEARN_REPORT="$FEATURE_DIR/learn-report.md"
        
        # Copy learn template if learn report doesn't exist
        if [ ! -f "$LEARN_REPORT" ]; then
            if [ -f "$FEATURE_DIR/../templates/learn-template.md" ]; then
                cp "$FEATURE_DIR/../templates/learn-template.md" "$LEARN_REPORT"
            elif [ -f "$FEATURE_DIR/../..//templates/learn-template.md" ]; then
                cp "$FEATURE_DIR/../..//templates/learn-template.md" "$LEARN_REPORT"
            elif [ -f "./templates/learn-template.md" ]; then
                cp "./templates/learn-template.md" "$LEARN_REPORT"
            fi
            
            # Replace placeholders in the template if it was copied
            if [ -f "$LEARN_REPORT" ]; then
                # Replace placeholders in the template
                sed -i.bak "s/{FEATURE_NAME}/$(basename $FEATURE_DIR)/g" "$LEARN_REPORT"
                sed -i.bak "s/{DATE}/$(date -I)/g" "$LEARN_REPORT"
                sed -i.bak "s/{FEATURE_NUMBER}/$(basename $FEATURE_DIR | sed 's/[^0-9]*//g')/g" "$LEARN_REPORT"
                sed -i.bak "s/{AUTHOR}/$(git config user.name)/g" "$LEARN_REPORT"
                rm "$LEARN_REPORT.bak"
            fi
        fi
    fi

    # Set pattern library directory
    if [ -d "./patterns" ]; then
        PATTERN_LIB_DIR=$(realpath "./patterns")
    elif [ -d "./memory/patterns" ]; then
        PATTERN_LIB_DIR=$(realpath "./memory/patterns")
    else
        PATTERN_LIB_DIR=$(realpath "./memory")
    fi

    # Output JSON with the required variables
    cat <<EOF
{
  "FEATURE_DIR": "$FEATURE_DIR",
  "LEARN_REPORT": "$LEARN_REPORT",
  "PATTERN_LIB_DIR": "$PATTERN_LIB_DIR",
  "BRANCH": "$BRANCH"
}
EOF
else
    echo "Usage: $0 --json"
    exit 1
fi