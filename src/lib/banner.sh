#!/bin/sh
# ASCII Banner with Integrated Messages

# Generic function to format and print messages
log_message() {
    color="$1"   # Color code (e.g., "\e[1;32m")
    label="$2"   # Message label (INFO, WARNING, ERROR, DEBUG)
    message="$3" # The actual message

    printf "%b[%s]%b %s\n" "$color" "$label" "\e[0m" "$message"
}

# Function to display an INFO message in green
info() {
    log_message "\033[1;32m" "INFO" "$1"
}

# Function to display a WARNING message in yellow
warning() {
    log_message "\033[1;33m" "WARNING" "$1"
}

# Function to display an ERROR message in red
error() {
    log_message "\033[1;31m" "ERROR" "$1"
}

# Function to display a DEBUG message in blue
debug() {
    log_message "\033[1;34m" "DEBUG" "$1"
}

# Helper function to detect message type and format accordingly
message() {
    local message="$1"

    case "$message" in
        "[INFO]"*) info "${message#*\] }" ;;
        "[WARNING]"*) warning "${message#*\] }" ;;
        "[ERROR]"*) error "${message#*\] }" ;;
        "[DEBUG]"*) debug "${message#*\] }" ;;
        *) printf "%s\n" "$message" ;; # Default plain output
    esac
}

# Banner function
banner() {
    clear  # Attempt to clear the screen (works in most terminals)
    
    # Display the full ASCII banner with colors
    printf "\e[1;34m    _______                     ________        __       \e[0m\n"
    printf "\e[1;34m   |       |.-----.-----.-----.|  |  |  |.----.|  |_     \e[0m\n"
    printf "\e[1;34m   |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|    \e[0m\n"
    printf "\e[1;34m   |_______||   __|_____|__|__||________||__|  |____|    \e[0m\n"
    printf "\e[1;34m     \e[0m\e[1;31mICE-T:\e[0m \e[1;34m|__|\e[0m \e[1;32mISP Configurations, Enhancements & Tools\e[0m\n"
    printf "\n"  # Add consistent spacing after banner

    # Check if the system is running on a SNAPSHOT build
    if is_snapshot_build; then
        warning "OpenWrt SNAPSHOT build detected, ICE-T running with allow snapshots flag. Proceed with caution!"
    fi

    # Check if the device is configured as a Dumb AP
    if is_dumb_ap; then
        info "This device is currently configured as a Dumb AP. Some options are not available."
    fi

    # Add newline if either check was true
    if is_snapshot_build || is_dumb_ap; then
        printf "\n"
    fi

    # Show any additional informational messages
    if [ -n "$additional_message" ]; then
        message "$additional_message"
        printf "\n"
        additional_message=""  # Clear the message after displaying it
    fi
}

# Use a more portable trap syntax
# Some systems only recognize WINCH, others need SIGWINCH
trap banner WINCH
trap banner SIGWINCH 2>/dev/null  # Suppress error if SIGWINCH isn't supported
