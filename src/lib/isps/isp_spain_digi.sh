#!/bin/sh

ISP_COUNTRY="Spain"
ISP_NAME="Digi"

run_isp_spain_digi() {
    banner
    message "Configuring $ISP_NAME ($ISP_COUNTRY):"
    sleep 4
    additional_message="[INFO] $ISP_NAME ($ISP_COUNTRY): Configuration completed."
    display_main_menu  # Return to the main menu
    return
}
