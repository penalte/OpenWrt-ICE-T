#!/bin/sh

display_main_menu() {
    while true; do
        banner
        echo "Configuration Menu:"
        echo "1) ISP Configuration"
        echo "2) Tools"
        echo "3) Enhancements"
        echo "4) Preview Pending Changes"
        echo "5) Revert Pending Changes"
        echo "6) Apply Changes and Restart"
        echo "0) Exit Without Applying"
        read -r choice
        case $choice in
            1)
                #if is_dumb_ap; then 
                #    log_message "[WARNING] This device is configured as a Dumb AP. Network Tools are not available."
                #    additional_message="[WARNING] This device is configured as a Dumb AP. Network Tools are not available."
                #else
                    display_isps_menu
                #fi
                ;;
            2)
                #if is_dumb_ap; then
                #    log_message "[WARNING] This device is configured as a Dumb AP. ISP Settings are not available."
                #    additional_message="[WARNING] This device is configured as a Dumb AP. ISP Settings are not available."
                #else
                    display_tools_menu
                #fi
                ;;
            3) display_enhancements_menu ;;
            4) preview_changes
		echo "Press Enter to return to the main menu."
   		read -r _
	       ;;
            5) revert_changes ;;
            6)
                preview_changes
                echo "[WARNING] Are you sure you want to apply these changes and restart the device? (y/n)"
                read -r confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    if uci commit; then
                        log_message "[OK] Changes committed successfully!"
                        additional_message="[OK] Changes committed successfully!"
                        echo "[WARNING] The device will now restart in 10 seconds to apply changes."
                        for i in $(seq 10 -1 1); do
                            echo -ne "Restarting in $i seconds...\r"
                            sleep 1
                        done
                        echo "[OK] Restarting now..."
                        reboot
                    else
                        log_message "[ERROR] Failed to commit changes."
                        additional_message="[ERROR] Failed to commit changes. Please try again."
                    fi
                else
                    log_message "[INFO] Changes were not applied. Returning to the main menu."
                    additional_message="[INFO] Changes were not applied. Returning to the main menu."
                fi
                ;;
            0)
                revert_changes
                log_message "[INFO] Exiting without applying changes."
                additional_message="[INFO] Exiting without applying changes."
                clear  # Clear the terminal before exiting
                exit 0
                ;;
            *)
                log_message "[ERROR] Invalid option selected: $choice"
                additional_message="[ERROR] Invalid option! Choose 1-6 or 0 to exit."
                ;;
        esac
    done
}