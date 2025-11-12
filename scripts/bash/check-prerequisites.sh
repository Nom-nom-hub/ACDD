#!/bin/bash

set -e

# Check prerequisites for ACDD

JSON_MODE=false
VERBOSE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_MODE=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Usage: $0 [--json] [--verbose|-v]" >&2
            exit 1
            ;;
    esac
done

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Check basic prerequisites
MISSING_TOOLS=()
REQUIRED_TOOLS=("bash" "git" "sed" "grep" "find")

# Check if required tools are available
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    elif [ "$VERBOSE" = true ]; then
        echo "Found: $tool ($(command -v "$tool"))" >&2
    fi
done

# Check for optional but useful tools
OPTIONAL_TOOLS=("jq" "curl" "python3")
OPTIONAL_STATUS=()

for tool in "${OPTIONAL_TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        if [ "$VERBOSE" = true ]; then
            echo "Found (optional): $tool" >&2
        fi
        OPTIONAL_STATUS+=("$tool:present")
    else
        OPTIONAL_STATUS+=("$tool:missing")
    fi
done

# Find repository root
REPO_ROOT=$(find_repo_root "$SCRIPT_DIR")
PROJECT_STATUS="unknown"
ACDD_STATUS="not_found"
SPEC_DIR_STATUS="not_found"

if [ $? -eq 0 ]; then
    PROJECT_STATUS="found"
    
    # Check if this is an ACDD project
    if [ -d "$REPO_ROOT/.acdd" ]; then
        ACDD_STATUS="found"
        
        # Check if specs directory exists
        if [ -d "$REPO_ROOT/specs" ]; then
            SPEC_DIR_STATUS="found"
        else
            SPEC_DIR_STATUS="missing"
        fi
    else
        ACDD_STATUS="missing"
    fi
else
    REPO_ROOT="not_found"
fi

# Determine overall status
if [ ${#MISSING_TOOLS[@]} -eq 0 ] && [ "$ACDD_STATUS" = "found" ] && [ "$SPEC_DIR_STATUS" = "found" ]; then
    OVERALL_STATUS="ready"
elif [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    OVERALL_STATUS="missing_tools"
else
    OVERALL_STATUS="setup_required"
fi

if [ "$JSON_MODE" = true ]; then
    printf '{"status":"%s","missing_tools":["%s"],"optional_tools":["%s"],"project_found":"%s","acdd_found":"%s","specs_found":"%s"}\n' \
        "$OVERALL_STATUS" \
        "$(IFS='","'; echo "${MISSING_TOOLS[*]}")" \
        "$(IFS='","'; echo "${OPTIONAL_STATUS[*]}")" \
        "$PROJECT_STATUS" \
        "$ACDD_STATUS" \
        "$SPEC_DIR_STATUS"
else
    echo "ACDD Prerequisites Check"
    echo "========================"
    echo "Overall Status: $OVERALL_STATUS"
    echo
    
    if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
        echo "❌ Missing Required Tools:"
        for tool in "${MISSING_TOOLS[@]}"; do
            echo "  - $tool"
        done
        echo
    else
        echo "✅ All required tools present"
        echo
    fi
    
    echo "Optional Tools Status:"
    for opt_status in "${OPTIONAL_STATUS[@]}"; do
        IFS=':' read -r tool status <<< "$opt_status"
        if [ "$status" = "present" ]; then
            echo "  ✅ $tool"
        else
            echo "  ⚠️  $tool (optional)"
        fi
    done
    echo
    
    echo "Project Status:"
    case "$PROJECT_STATUS" in
        "found") echo "  ✅ Project directory found: $REPO_ROOT" ;;
        *) echo "  ❌ Project directory not found" ;;
    esac
    
    case "$ACDD_STATUS" in
        "found") echo "  ✅ ACDD project structure found" ;;
        *) echo "  ❌ ACDD project structure not found (run setup-acdd-project.sh)" ;;
    esac
    
    case "$SPEC_DIR_STATUS" in
        "found") echo "  ✅ Specs directory found" ;;
        *) echo "  ❌ Specs directory missing" ;;
    esac
fi

# Exit with error code if critical prerequisites are missing
if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    exit 1
elif [ "$ACDD_STATUS" != "found" ]; then
    exit 2
else
    exit 0
fi