#!/bin/sh

TOOL_NAME="Example Tool - Ping"

run_tool_ping() {
    banner  # Always display the banner first
    message "[INFO] Enter the IP address or domain to ping:"
    read -r target
    banner  # Clear the screen after reading input
    log "[INFO] Pinging $target ..."
    message "[INFO] Pinging $target ..."
    ping -c 4 "$target"
    message "[INFO] Press Enter to go back to the main menu."
    read -r  # Wait for user to press Enter
    display_main_menu  # Return to the main menu
    return
}