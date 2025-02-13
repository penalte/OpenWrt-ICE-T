#!/bin/sh

ENHANCEMENT_NAME="Example Enhancement - Cloudflare DNS"

run_enhancement_cloudflare_dns() {
    banner  # Always display the banner first
    message "Applying Cloudflare DNS settings for WAN and WAN6 ..."

    # Set Cloudflare DNS for WAN
    uci set network.wan.peerdns='0' # Ignore ISP DNS
    uci add_list network.wan.dns='1.1.1.1'
    uci add_list network.wan.dns='1.0.0.0'

    # Set Cloudflare DNS for WAN6
    uci set network.wan6.reqaddress='try'
    uci set network.wan6.reqprefix='auto'
    uci set network.wan6.norelease='1'
    uci set network.wan6.peerdns='0' # Ignore ISP DNS
    uci add_list network.wan6.dns='2606:4700:4700::1111'
    uci add_list network.wan6.dns='2606:4700:4700::1001'

    message "[INFO] Cloudflare DNS settings applied for WAN and WAN6."
    additional_message="[INFO] Cloudflare DNS settings applied for WAN and WAN6."
    display_main_menu  # Return to the main menu
    return
}

