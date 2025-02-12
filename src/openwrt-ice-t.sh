#!/bin/sh
set +x

# Initialize variables
allow_snapshots=0
additional_message=""
VERSION=${VERSION:-"Development"}  # Default to "Development" if VERSION is not set

# Export variables
export allow_snapshots
export additional_message

# Parse command-line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --allowsnapshots)
            allow_snapshots=1
            ;;
        --debug)
            set -x  # Enable debug output
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "OpenWrt ICE-T: ISP Configurations, Enhancements & Tools"
            echo
            echo "Options:"
            echo "  --allowsnapshots    Allow running on OpenWrt SNAPSHOT builds"
            echo "  --help, -h          Display this help message"
            echo "  --version, -v       Display version information"
            exit 0
            ;;
        --version|-v)
            echo "OpenWrt-ICE-T - $VERSION"
            exit 0
            ;;
        *)
            log_message "[ERROR] Unknown argument: $1"
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
    esac
    shift
done

# Source library files
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
LIB_DIR="$SCRIPT_DIR/lib"

# shellcheck disable=SC1090
for lib in menu_main.sh utils.sh logging.sh banner.sh uci_helpers.sh menu_isps.sh menu_tools.sh menu_enhancements.sh; do
    if [ ! -f "$LIB_DIR/$lib" ]; then
        echo "Error: Required library $lib not found in $LIB_DIR"
        exit 1
    fi
    . "$LIB_DIR/$lib"
done

# Check for root privileges if needed
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Add check_root before the entry point if needed
check_root

# Add cleanup trap
cleanup() {
    revert_changes
    exit 1
}

trap cleanup INT TERM

# Entry Point
detect_openwrt "$allow_snapshots"  # Pass the allow_snapshots flag to detect_openwrt
revert_changes                     # Revert any uncommitted changes from previous runs
display_main_menu                  # Start the main menu               # Start the main menu