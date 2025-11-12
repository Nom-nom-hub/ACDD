#!/bin/bash

# ACDD Adapt Command Script
# Implements adaptations based on learning outcomes, updates patterns and processes, and evolves the development methodology

set -e  # Exit on any error

# Default values
JSON_OUTPUT=false
FEATURE_DIR=""
ADAPT_REPORT=""
PATTERN_LIB_DIR=""
BRANCH=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        --require-learn)
            # This flag is for documentation purposes - validation happens in the command template
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

    # Set ADAPT_REPORT path
    if [ -n "$FEATURE_DIR" ]; then
        ADAPT_REPORT="$FEATURE_DIR/adapt-report.md"

        # Copy adapt template if adapt report doesn't exist
        if [ ! -f "$ADAPT_REPORT" ]; then
            if [ -f "$FEATURE_DIR/../templates/adapt-template.md" ]; then
                cp "$FEATURE_DIR/../templates/adapt-template.md" "$ADAPT_REPORT"
            elif [ -f "$FEATURE_DIR/../..//templates/adapt-template.md" ]; then
                cp "$FEATURE_DIR/../..//templates/adapt-template.md" "$ADAPT_REPORT"
            elif [ -f "./templates/adapt-template.md" ]; then
                cp "./templates/adapt-template.md" "$ADAPT_REPORT"
            fi

            # Replace placeholders in the template if it was copied
            if [ -f "$ADAPT_REPORT" ]; then
                # Replace placeholders in the template
                sed -i.bak "s/{FEATURE_NAME}/$(basename $FEATURE_DIR)/g" "$ADAPT_REPORT"
                sed -i.bak "s/{DATE}/$(date -I)/g" "$ADAPT_REPORT"
                sed -i.bak "s/{FEATURE_NUMBER}/$(basename $FEATURE_DIR | sed 's/[^0-9]*//g')/g" "$ADAPT_REPORT"
                sed -i.bak "s/{AUTHOR}/$(git config user.name)/g" "$ADAPT_REPORT"
                rm "$ADAPT_REPORT.bak"
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
  "ADAPT_REPORT": "$ADAPT_REPORT",
  "PATTERN_LIB_DIR": "$PATTERN_LIB_DIR",
  "BRANCH": "$BRANCH"
}
EOF
else
    echo "Usage: $0 --json [--require-learn]"
    exit 1
fi