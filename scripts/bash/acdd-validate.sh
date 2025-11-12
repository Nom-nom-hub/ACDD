#!/bin/bash

# ACDD (Adaptive Context-Driven Development) Validation Script
# Provides validation for ACDD-specific requirements and context tracking

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
FEATURE_DIR=""
SHOW_HELP=false
OUTPUT_JSON=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            FEATURE_DIR="$2"
            shift 2
            ;;
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        -h|--help)
            SHOW_HELP=true
            shift
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

if [ "$SHOW_HELP" = true ]; then
    echo "ACDD Validation Script"
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -d, --dir DIR     Feature directory to validate"
    echo "  --json            Output in JSON format"
    echo "  -h, --help        Show this help message"
    exit 0
fi

# Function to output JSON
output_json() {
    if [ "$OUTPUT_JSON" = true ]; then
        echo "$1"
    else
        echo "$2"
    fi
}

# Function to log messages
log() {
    local level=$1
    local message=$2
    
    if [ "$OUTPUT_JSON" = true ]; then
        echo "{\"level\":\"$level\", \"message\":\"$message\"}" >&2
    else
        case $level in
            "ERROR")
                echo -e "${RED}[ERROR]${NC} $message" >&2
                ;;
            "WARN")
                echo -e "${YELLOW}[WARN]${NC} $message" >&2
                ;;
            "INFO")
                echo -e "${BLUE}[INFO]${NC} $message" >&2
                ;;
            "SUCCESS")
                echo -e "${GREEN}[SUCCESS]${NC} $message" >&2
                ;;
        esac
    fi
}

# Function to validate ACDD-specific requirements
validate_acdd_requirements() {
    local feature_dir=$1
    local errors=0
    local warnings=0
    
    if [ "$OUTPUT_JSON" = true ]; then
        echo "{"
        echo "  \"feature_dir\": \"$feature_dir\","
        echo "  \"validation_results\": ["
    fi
    
    # Check if required ACDD files exist
    if [ ! -f "$feature_dir/context-map.md" ]; then
        ((errors++))
        output_json "{\"type\":\"error\", \"file\":\"context-map.md\", \"message\":\"ACDD context map file not found\"}" \
                    "Context map file (context-map.md) not found in feature directory"
    else
        output_json "{\"type\":\"success\", \"file\":\"context-map.md\", \"message\":\"ACDD context map file found\"}" \
                    "✓ Context map file found"
    fi
    
    # Check for context evolution tracking
    if [ -d "$feature_dir/../memory/context" ] || [ -d "$feature_dir/memory/context" ]; then
        output_json "{\"type\":\"success\", \"file\":\"context/memory\", \"message\":\"Context evolution tracking directory found\"}" \
                    "✓ Context evolution tracking directory found"
    else
        ((warnings++))
        output_json "{\"type\":\"warning\", \"file\":\"context/memory\", \"message\":\"Context evolution tracking directory not found\"}" \
                    "⚠ Context evolution tracking directory not found (optional for ACDD)"
    fi
    
    # Check for pattern compliance validation
    if [ -f "$feature_dir/../memory/constitution.md" ] || [ -f "$feature_dir/memory/constitution.md" ]; then
        output_json "{\"type\":\"success\", \"file\":\"constitution.md\", \"message\":\"Constitutional principles file found\"}" \
                    "✓ Constitutional principles file found"
    else
        ((warnings++))
        output_json "{\"type\":\"warning\", \"file\":\"constitution.md\", \"message\":\"Constitutional principles file not found\"}" \
                    "⚠ Constitutional principles file not found (required for ACDD pattern compliance)"
    fi
    
    # Check for ACDD-specific context tags in tasks if they exist
    if [ -f "$feature_dir/tasks.md" ]; then
        local ctx_init_count=$(grep -c "\[CTX-INIT\]" "$feature_dir/tasks.md" 2>/dev/null || echo 0)
        local ctx_learn_count=$(grep -c "\[CTX-LEARN\]" "$feature_dir/tasks.md" 2>/dev/null || echo 0)
        local ctx_adapt_count=$(grep -c "\[CTX-ADAPT\]" "$feature_dir/tasks.md" 2>/dev/null || echo 0)
        local ctx_validate_count=$(grep -c "\[CTX-VALIDATE\]" "$feature_dir/tasks.md" 2>/dev/null || echo 0)
        
        if [ "$ctx_init_count" -gt 0 ] || [ "$ctx_learn_count" -gt 0 ] || [ "$ctx_adapt_count" -gt 0 ] || [ "$ctx_validate_count" -gt 0 ]; then
            output_json "{\"type\":\"success\", \"file\":\"tasks.md\", \"message\":\"ACDD context tags found in tasks\"}" \
                        "✓ ACDD context tags found in tasks file"
        else
            ((warnings++))
            output_json "{\"type\":\"warning\", \"file\":\"tasks.md\", \"message\":\"No ACDD context tags found in tasks\"}" \
                        "⚠ No ACDD context tags found in tasks file (should include [CTX-INIT], [CTX-LEARN], [CTX-ADAPT], [CTX-VALIDATE])"
        fi
    fi
    
    if [ "$OUTPUT_JSON" = true ]; then
        echo "  ],"
        echo "  \"total_errors\": $errors,"
        echo "  \"total_warnings\": $warnings"
        echo "}"
    else
        echo ""
        echo -e "${BLUE}ACDD Validation Summary:${NC}"
        echo "Errors: $errors"
        echo "Warnings: $warnings"
        
        if [ $errors -eq 0 ]; then
            echo -e "${GREEN}✓ ACDD validation passed${NC}"
            return 0
        else
            echo -e "${RED}✗ ACDD validation failed${NC}"
            return 1
        fi
    fi
}

# Main execution
if [ -z "$FEATURE_DIR" ]; then
    # Try to detect feature directory from current context
    if [ -n "$SPECKIT_FEATURE_DIR" ]; then
        FEATURE_DIR="$SPECKIT_FEATURE_DIR"
    else
        # Look for the most recently created feature directory in specs/
        if [ -d "specs" ]; then
            FEATURE_DIR=$(find specs -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
        fi
    fi
fi

if [ -z "$FEATURE_DIR" ]; then
    log "ERROR" "No feature directory specified and none could be detected"
    exit 1
fi

if [ ! -d "$FEATURE_DIR" ]; then
    log "ERROR" "Feature directory does not exist: $FEATURE_DIR"
    exit 1
fi

log "INFO" "Validating ACDD requirements for feature directory: $FEATURE_DIR"

validate_acdd_requirements "$FEATURE_DIR"

exit_code=$?

exit $exit_code