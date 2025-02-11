#!/bin/sh

TOOLS_DIR="$SCRIPT_DIR/lib/tools"

# Function to extract TOOL_NAME from a script
extract_tool_name() {
    local file="$1"
    grep -E '^TOOL_NAME=' "$file" | sed -E 's/TOOL_NAME="(.*)"/\1/'  
}

# Function to display the dynamic tools menu
display_tools_menu() {
    while true; do
        banner  # Display a banner if applicable

        echo "Select a tool:"
        
        tool_files=$(find "$TOOLS_DIR" -name 'tool_*.sh')
        index=1
        tool_options=""
        
        for file in $tool_files; do
            tool_name=$(extract_tool_name "$file")
            if [ -n "$tool_name" ]; then
                echo "$index) $tool_name"
                tool_options="$tool_options$file "
                index=$((index + 1))
            fi
        done
        echo "0) Go back to the main menu"
        read -r tool_choice

        if [ "$tool_choice" -eq 0 ]; then
            return  # Go back to the main menu
        fi

        # Extract the correct script from the list
        selected_tool=$(echo "$tool_options" | cut -d' ' -f"$tool_choice")

        if [ -z "$selected_tool" ]; then
            echo "[ERROR] Invalid tool selected!"
            continue
        fi

        # Source the selected tool script
        . "$selected_tool"

        # Determine the function name dynamically
        CONFIG_FUNCTION=$(basename "$selected_tool" .sh | sed 's/^tool_/run_tool_/')

        if command -v "$CONFIG_FUNCTION" >/dev/null 2>&1; then
            "$CONFIG_FUNCTION"  # Execute the tool configuration function
        else
            echo "[ERROR] Configuration function $CONFIG_FUNCTION not found!"
        fi
    done
}
