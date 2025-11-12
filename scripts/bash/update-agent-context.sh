#!/bin/bash

set -e

# Update agent context script for ACDD

JSON_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_MODE=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Usage: $0 [--json]" >&2
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

# Check if we're in a feature directory
FEATURE_DIR=$(get_feature_dir "$REPO_ROOT")
if [ $? -ne 0 ]; then
    if [ "$JSON_MODE" = true ]; then
        printf '{"ERROR":"Not in a feature directory","REPO_ROOT":"%s"}\n' "$REPO_ROOT"
    else
        echo "Warning: Not in a feature directory, updating global context only"
    fi
else
    # Validate feature directory
    validate_feature_dir "$FEATURE_DIR"
    if [ $? -eq 0 ]; then
        # Update feature-specific context if needed
        echo "Updating context for feature: $(basename "$FEATURE_DIR")"
    fi
fi

# Update ACDD context files
ACDD_CONTEXT_DIR="$REPO_ROOT/.acdd/context"
if [ -d "$ACDD_CONTEXT_DIR" ]; then
    # Touch context files to update their modification time
    for file in "$ACDD_CONTEXT_DIR"/*; do
        if [ -f "$file" ]; then
            touch "$file"
        fi
    done
    
    # Update the main context model
    CONTEXT_JSON="$ACDD_CONTEXT_DIR/context.json"
    if [ -f "$CONTEXT_JSON" ]; then
        # Update timestamp in context.json if it's a valid JSON file
        if command -v jq >/dev/null 2>&1; then
            if jq empty "$CONTEXT_JSON" 2>/dev/null; then
                jq '.last_updated = "'$(date -u -Iseconds)'"' "$CONTEXT_JSON" > "$CONTEXT_JSON.tmp" && mv "$CONTEXT_JSON.tmp" "$CONTEXT_JSON"
            fi
        fi
    fi
    
    if [ "$JSON_MODE" = true ]; then
        printf '{"STATUS":"UPDATED","CONTEXT_DIR":"%s","TIMESTAMP":"%s"}\n' "$ACDD_CONTEXT_DIR" "$(date -u -Iseconds)"
    else
        echo "ACDD context updated in: $ACDD_CONTEXT_DIR"
        echo "Timestamp: $(date -u -Iseconds)"
    fi
else
    if [ "$JSON_MODE" = true ]; then
        printf '{"ERROR":"ACDD context directory does not exist","EXPECTED_PATH":"%s"}\n' "$ACDD_CONTEXT_DIR"
    else
        echo "Error: ACDD context directory does not exist: $ACDD_CONTEXT_DIR" >&2
    fi
    exit 1
fi