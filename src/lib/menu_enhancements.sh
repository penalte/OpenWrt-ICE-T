#!/bin/sh

ENHANCEMENTS_DIR="$SCRIPT_DIR/lib/enhancements"

# Function to extract ENHANCEMENT_NAME from a script
extract_enhancement_name() {
    local file="$1"
    grep -E '^ENHANCEMENT_NAME=' "$file" | sed -E 's/ENHANCEMENT_NAME="(.*)"/\1/'
}

# Function to display the dynamic enhancements menu
display_enhancements_menu() {
    while true; do
        banner  # Display a banner if applicable

        echo "Select an enhancement:"
        
        enhancement_files=$(find "$ENHANCEMENTS_DIR" -name 'enhancement_*.sh')
        index=1
        enhancement_options=""

        for file in $enhancement_files; do
            enhancement_name=$(extract_enhancement_name "$file")
            if [ -n "$enhancement_name" ]; then
                echo "$index) $enhancement_name"
                enhancement_options="$enhancement_options$file "
                index=$((index + 1))
            fi
        done
        echo "0) Go back to the main menu"
        read -r enhancement_choice

        if [ "$enhancement_choice" -eq 0 ]; then
            return  # Go back to the main menu
        fi

        # Extract the correct script from the list
        selected_enhancement=$(echo "$enhancement_options" | cut -d' ' -f"$enhancement_choice")

        if [ -z "$selected_enhancement" ]; then
            echo "[ERROR] Invalid enhancement selected!"
            continue
        fi

        # Source the selected enhancement script
        . "$selected_enhancement"

        # Determine the function name dynamically
        CONFIG_FUNCTION=$(basename "$selected_enhancement" .sh | sed 's/^enhancement_/run_enhancement_/')

        if command -v "$CONFIG_FUNCTION" >/dev/null 2>&1; then
            "$CONFIG_FUNCTION"  # Execute the enhancement configuration function
        else
            echo "[ERROR] Configuration function $CONFIG_FUNCTION not found!"
        fi
    done
}
