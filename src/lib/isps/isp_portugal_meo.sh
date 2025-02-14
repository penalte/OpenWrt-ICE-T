#!/bin/sh

ISP_COUNTRY="Portugal"
ISP_NAME="Meo"

run_isp_portugal_meo() {
    banner
    message "Configuring $ISP_NAME ($ISP_COUNTRY): "
    sleep 4
    additional_message="[INFO] $ISP_NAME ($ISP_COUNTRY): Configuration completed."
    display_main_menu  # Return to the main menu
    return
}
