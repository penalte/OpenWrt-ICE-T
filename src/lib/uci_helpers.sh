#!/bin/sh

# Revert Uncommitted Changes
revert_changes() {
    log "[INFO] Reverting uncommitted changes..."
    # Get a list of all pending changes
    pending_changes=$(uci changes)
    if [ -z "$pending_changes" ]; then
        log "[INFO] No pending changes to revert."
        additional_message="[INFO] No pending changes to revert."
        return
    fi
    # Extract unique configuration files from pending changes
    config_files=$(echo "$pending_changes" | cut -d'.' -f1 | sort -u)
    # Revert changes for each configuration file
    for config_file in $config_files; do
        if uci revert "$config_file"; then
            log "[OK] Reverted changes for configuration: $config_file"
            additional_message="[OK] Reverted changes for configuration: $config_file"
        else
            log "[ERROR] Failed to revert changes for configuration: $config_file"
            additional_message="[ERROR] Failed to revert changes for configuration: $config_file"
        fi
    done
}

# Preview Pending Changes
preview_changes() {
    banner
    changes=$(uci changes)
    if [ -z "$changes" ]; then
        echo "[INFO] No pending changes."
        return
    fi
    echo "[INFO] Pending Changes:"
    echo
    echo "$changes"
    echo
}

# Check if a UCI configuration exists
uci_config_exists() {
    local config="$1"
    if uci get "$config" >/dev/null 2>&1; then
        return 0  # True: Configuration exists
    else
        return 1  # False: Configuration does not exist
    fi
}

# Set a UCI value safely
set_uci_value() {
    local config="$1"
    local key="$2"
    local value="$3"
    if uci set "$config.$key=$value"; then
        log "[OK] Set UCI value: $config.$key=$value (not yet applied)"
        additional_message="[OK] Set UCI value: $config.$key=$value (not yet applied)"
        return 0
    else
        log "[ERROR] Failed to set UCI value: $config.$key=$value"
        additional_message="[ERROR] Failed to set UCI value: $config.$key=$value"
        return 1
    fi
}

# Commit UCI changes
commit_uci_changes() {
    if uci commit; then
        log "[OK] UCI changes committed successfully!"
        additional_message="[OK] UCI changes committed successfully!"
        return 0
    else
        log "[ERROR] Failed to commit UCI changes."
        additional_message="[ERROR] Failed to commit UCI changes."
        return 1
    fi
}