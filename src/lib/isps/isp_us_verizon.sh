#!/bin/sh

ISP_COUNTRY="US"
ISP_NAME="Verizon"

run_isp_us_verizon() {
    banner
    message "Configuring $ISP_NAME ($ISP_COUNTRY): "
    sleep 4
    additional_message="[INFO] $ISP_NAME ($ISP_COUNTRY): Configuration completed."
    display_main_menu  # Return to the main menu
    return
}
