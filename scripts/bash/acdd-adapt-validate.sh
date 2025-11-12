#!/bin/bash

# ACDD Adapt Validation Script
# Validates that adaptation phase was completed properly with all ACDD-specific requirements

set -e

# Default values
JSON_OUTPUT=false
FEATURE_DIR=""

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

validate_adapt_phase() {
    local feature_dir="$1"
    local validation_results=()
    local all_passed=true

    echo "Validating adaptation phase in $feature_dir..."

    # Check for required adaptation artifacts
    local required_files=(
        "$feature_dir/adapt-report.md"
        "$feature_dir/learn-report.md"
        "$feature_dir/implement.md"
    )

    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            validation_results+=("✓ Found: $(basename "$file")")
        else
            validation_results+=("✗ Missing: $(basename "$file")")
            all_passed=false
        fi
    done

    # Check for pattern library updates
    local pattern_dirs=("./patterns" "./memory/patterns" "./memory")
    local patterns_updated=false
    
    for pattern_dir in "${pattern_dirs[@]}"; do
        if [[ -d "$pattern_dir" ]]; then
            # Check if any pattern files were recently modified (within last 24 hours)
            if find "$pattern_dir" -name "*.md" -mmin -1440 2>/dev/null | grep -q .; then
                validation_results+=("✓ Pattern library updated")
                patterns_updated=true
                break
            fi
        fi
    done
    
    if [[ "$patterns_updated" == false ]]; then
        validation_results+=("⚠️  No recent pattern updates detected")
    fi

    # Check for process improvements documentation
    local process_files=("$feature_dir/plan.md" "$feature_dir/tasks.md" "$feature_dir/ACDD-SUMMARY.md")
    local process_improvements_found=false
    
    for file in "${process_files[@]}"; do
        if [[ -f "$file" ]]; then
            if grep -q -i "improv\|adapt\|learn\|evolut\|enhanc\|refin\|optimiz" "$file"; then
                process_improvements_found=true
                break
            fi
        fi
    done
    
    if [[ "$process_improvements_found" == true ]]; then
        validation_results+=("✓ Process improvements documented")
    else
        validation_results+=("⚠️  No process improvements detected in documentation")
    fi

    # Check adaptation validation checklist
    if [[ -f "$feature_dir/adapt-report.md" ]]; then
        local validation_checklist_items=(
            "All high-priority adaptations implemented"
            "Pattern library updated with learning insights"
            "Process improvements documented and applied"
            "Methodology documentation reflects new insights"
            "Knowledge base updated with adaptation outcomes"
        )
        
        local checklist_validated=true
        for item in "${validation_checklist_items[@]}"; do
            if ! grep -q "\[x\].*$item" "$feature_dir/adapt-report.md" && ! grep -q "\[\s\].*$item" "$feature_dir/adapt-report.md"; then
                validation_results+=("⚠️  Checklist item not found: $item")
            elif grep -q "\[\s\].*$item" "$feature_dir/adapt-report.md"; then
                validation_results+=("⚠️  Checklist item incomplete: $item")
                all_passed=false
            elif grep -q "\[x\].*$item" "$feature_dir/adapt-report.md"; then
                validation_results+=("✓ Checklist item completed: $item")
            fi
        done
    fi

    # Output validation results
    if [[ "$JSON_OUTPUT" == true ]]; then
        local status="PASS"
        if [[ "$all_passed" == false ]]; then
            status="FAIL"
        fi
        
        cat <<EOF
{
  "validation_status": "$status",
  "feature_dir": "$feature_dir",
  "results": [
$(printf '%s\n' "${validation_results[@]}" | sed 's/^/    "/g; s/$/",/g' | sed '$s/,$//')
  ]
}
EOF
    else
        printf '%s\n' "${validation_results[@]}"
        if [[ "$all_passed" == true ]]; then
            echo
            echo "✅ All adaptation validations passed!"
            return 0
        else
            echo
            echo "❌ Some adaptation validations failed or have warnings!"
            return 1
        fi
    fi
}

if [[ "$JSON_OUTPUT" == true ]]; then
    # Find feature directory
    for dir in features/*/; do
        if [[ -d "$dir" ]] && [[ -f "${dir}spec.md" ]]; then
            FEATURE_DIR=$(realpath "$dir")
            break
        fi
    done

    if [[ -z "$FEATURE_DIR" ]] && [[ -f "spec.md" ]]; then
        FEATURE_DIR=$(pwd)
    fi

    if [[ -n "$FEATURE_DIR" ]]; then
        validate_adapt_phase "$FEATURE_DIR"
    else
        cat <<EOF
{
  "validation_status": "FAIL",
  "feature_dir": "",
  "results": [
    "✗ No feature directory found with spec.md"
  ]
}
EOF
        exit 1
    fi
else
    echo "Usage: $0 --json"
    exit 1
fi