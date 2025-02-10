#!/bin/sh

ISP_DIR="$SCRIPT_DIR/lib/isps"

# Function to extract the function name from the filename
extract_function_name_from_filename() {
    local file="$1"
    basename "$file" .sh | sed 's/^isp_/configure_isp_/'
}

# Function to extract ISP display names from inside the script
extract_isp_display_names() {
    local file="$1"
    country=$(grep -E '^ISP_COUNTRY=' "$file" | sed -E 's/ISP_COUNTRY="(.*)"/\1/')
    isp=$(grep -E '^ISP_NAME=' "$file" | sed -E 's/ISP_NAME="(.*)"/\1/')
    echo "$country $isp"
}

# Function to display the dynamic ISP menu
display_isps_menu() {
    while true; do
        banner  # Display a banner if applicable

        echo "Select your country:"

        # Get list of unique countries from ISP script variables
        countries=$(find "$ISP_DIR" -name 'isp_*_*.sh' | while read -r file; do
            grep -E '^ISP_COUNTRY=' "$file" | sed -E 's/ISP_COUNTRY="(.*)"/\1/'
        done | sort -u)

        index=1
        for country in $countries; do
            echo "$index) $country"
            country_list="$country_list $country"
            index=$((index + 1))
        done
        echo "0) Go back to the main menu"
        read -r country_choice

        if [ "$country_choice" -eq 0 ]; then
            return  # Return to main menu
        fi

        # Adjust for correct indexing
        adjusted_country_choice=$((country_choice + 1))

        # Get the selected country from the list
        selected_country=$(echo "$country_list" | cut -d' ' -f"$adjusted_country_choice")

        if [ -z "$selected_country" ]; then
            echo "[ERROR] Invalid country selected!"
            continue
        fi

        additional_message="[INFO] You selected $selected_country."
        banner  # Display a banner if applicable

        # List ISPs for the selected country
        echo "Select your ISP for $selected_country:"

        index=1
        available_isps=""
        available_scripts=""
        for file in $(find "$ISP_DIR" -name "isp_*.sh"); do
            file_country_isp=$(extract_isp_display_names "$file")
            file_country=$(echo "$file_country_isp" | cut -d' ' -f1)
            file_isp=$(echo "$file_country_isp" | cut -d' ' -f2)
            if [ "$file_country" = "$selected_country" ]; then
                echo "$index) $file_isp"
                available_isps="$available_isps $file_isp"
                available_scripts="$available_scripts $file"
                index=$((index + 1))
            fi
        done
        echo "0) Go back to the country selection"
        read -r isp_choice

        if [ "$isp_choice" -eq 0 ]; then
            continue  # Go back to country selection
        fi

        adjusted_isp_choice=$((isp_choice + 1))

        # Get the selected ISP and corresponding script
        selected_isp=$(echo "$available_isps" | cut -d' ' -f"$adjusted_isp_choice")
        selected_script=$(echo "$available_scripts" | cut -d' ' -f"$adjusted_isp_choice")

        if [ -z "$selected_isp" ] || [ -z "$selected_script" ]; then
            echo "[ERROR] Invalid ISP selected!"
            continue
        fi

        additional_message="[INFO] You selected $selected_isp ($selected_country)."
        banner  # Display a banner if applicable

        echo "[DEBUG] Sourcing ISP script: $selected_script"
        . "$selected_script"  # Source the ISP script

        # Extract function name dynamically from filename
        CONFIG_FUNCTION=$(extract_function_name_from_filename "$selected_script")

        echo "[DEBUG] Looking for function: $CONFIG_FUNCTION"
        if [ "$(type "$CONFIG_FUNCTION" 2>/dev/null)" ]; then
            echo "[DEBUG] Calling function: $CONFIG_FUNCTION"
            "$CONFIG_FUNCTION"  # Execute the function if it exists
        else
            echo "[ERROR] Configuration function $CONFIG_FUNCTION not found!"
        fi
    done
}
