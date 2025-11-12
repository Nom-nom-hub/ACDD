#!/bin/bash

# Common functions for ACDD scripts

set -e

# Function to find the repository root by searching for .acdd directory
find_repo_root() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.acdd" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Function to get current feature directory based on git branch or directory structure
get_feature_dir() {
    local repo_root="$1"
    
    # Try to get feature directory from git branch name
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch_name=$(git rev-parse --abbrev-ref HEAD)
        if [[ $branch_name =~ ^[0-9]{3,}- ]]; then
            # Branch name starts with numbers followed by hyphen (e.g., 001-feature-name)
            local feature_dir="$repo_root/specs/$branch_name"
            if [ -d "$feature_dir" ]; then
                echo "$feature_dir"
                return 0
            fi
        fi
    fi
    
    # Fallback: look for directory with numeric prefix in current path
    local current_path="$PWD"
    while [ "$current_path" != "/" ]; do
        local basename=$(basename "$current_path")
        if [[ $basename =~ ^[0-9]{3,}- ]]; then
            if [ -f "$current_path/spec.md" ] || [ -f "$current_path/plan.md" ]; then
                echo "$current_path"
                return 0
            fi
        fi
        current_path=$(dirname "$current_path")
    done
    
    # Check if we're in a feature directory under specs/
    local specs_dir="$repo_root/specs"
    if [[ "$PWD" == "$specs_dir"* ]]; then
        local relative_path="${PWD#$specs_dir/}"
        local feature_part=$(echo "$relative_path" | cut -d'/' -f1)
        if [[ $feature_part =~ ^[0-9]{3,}- ]]; then
            echo "$PWD"
            return 0
        fi
    fi
    
    return 1
}

# Function to get the feature number from a feature directory name
get_feature_number() {
    local feature_dir="$1"
    local basename=$(basename "$feature_dir")
    if [[ $basename =~ ^([0-9]+)- ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi
    return 1
}

# Function to get template file with proper path resolution
get_template_file() {
    local template_name="$1"
    local repo_root="$2"
    local template_path="$repo_root/templates/$template_name"
    
    if [ -f "$template_path" ]; then
        echo "$template_path"
        return 0
    else
        return 1
    fi
}

# Function to validate if we're in a valid ACDD project
validate_acdd_project() {
    local repo_root="$1"
    
    if [ ! -d "$repo_root/.acdd" ]; then
        echo "Error: Not in a valid ACDD project. Missing .acdd directory." >&2
        return 1
    fi
    
    return 0
}

# Function to validate if we're in a valid feature directory
validate_feature_dir() {
    local feature_dir="$1"
    
    if [ ! -d "$feature_dir" ]; then
        echo "Error: Feature directory does not exist: $feature_dir" >&2
        return 1
    fi
    
    return 0
}

# Export functions so they can be used by other scripts
export -f find_repo_root
export -f get_feature_dir
export -f get_feature_number
export -f get_template_file
export -f validate_acdd_project
export -f validate_feature_dir