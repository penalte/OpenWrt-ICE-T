# ICE-T: ISP Configurations, Enhancements & Tools

<p align="center">
  <img src="https://github.com/penalte/OpenWrt-ICE-T/blob/main/docs/images/logo.png?raw=true" alt="ICE-T Logo">
</p>

<p align="center">
  <a href="https://github.com/penalte/openwrt-ice-t/releases">
    <img src="https://img.shields.io/github/v/release/penalte/openwrt-ice-t" alt="GitHub release">
  </a>
  <a href="https://github.com/penalte/openwrt-ice-t/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/penalte/openwrt-ice-t" alt="GitHub contributors">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/github/license/penalte/openwrt-ice-t" alt="License">
  </a>
  <a href="https://github.com/penalte/openwrt-ice-t/issues">
    <img src="https://img.shields.io/github/issues/penalte/openwrt-ice-t" alt="Issues">
  </a>
</p>

## 🔹 Overview
ICE-T (**ISP Configurations, Enhancements & Tools**) is a powerful and modular **network automation framework** designed specifically for OpenWrt. Unlike generic OpenWrt tools, ICE-T provides a **specialized approach** for automating ISP configurations, optimizing network performance, and offering advanced troubleshooting utilities.

Initially developed to **simplify ISP configurations for Portugal-based ISPs**, ICE-T has evolved into a **versatile, modular solution** that supports multiple ISPs worldwide. With **a structured, menu-driven CLI**, it caters to both novice users and advanced administrators, ensuring seamless configuration, security, and performance enhancements.

## 🚀 Features
✔ **Automated ISP Configuration** – Pre-configured profiles for ISPs (Vodafone, MEO, NOS, Digi, and more).  
✔ **Performance & Security Enhancements** – Optimized routing, QoS, DNS filtering, and firewall tweaks.  
✔ **Advanced Network Tools** – Troubleshooting utilities for connectivity and diagnostics.  
✔ **Interactive CLI** – Menu-based interface for streamlined configuration.  
✔ **Modular & Expandable** – Easily add new ISPs, tools, or enhancements.  
✔ **Reliable & Open-Source** – Built on OpenWrt’s UCI system for transparency and security.  

## 📥 Installation
### Prerequisites
Ensure you have the following before installing ICE-T:
- OpenWrt installed (**latest stable release recommended**)
- SSH access to your router
- Basic familiarity with Linux commands (recommended)

### Installation Steps
1. **Download the self-extracting archive** from the [releases page](https://github.com/penalte/openwrt-ice-t/releases).
2. **Transfer the file to your router** using `scp`:
```sh
scp -O openwrt-ice-t.run root@<router-ip>:/root/
```
3. **SSH into your router**:
```sh
ssh root@<router-ip>
```
4. **Make the script executable**:
```sh
chmod +x openwrt-ice-t.run
```
## 🎯 Usage
Run the main script:
```sh
./openwrt-ice-t.run
```
### Main Menu Options:
1️⃣ **ISP Configuration** – Set up your ISP profile automatically.  
2️⃣ **Tools** – Use network diagnostics and debugging utilities.  
3️⃣ **Enhancements** – Optimize OpenWrt settings for performance and security.  
4️⃣ **Preview Changes** – Review pending modifications before applying them.  
5️⃣ **Revert Changes** – Roll back uncommitted settings and restore previous configurations.  
6️⃣ **Apply Changes & Restart** – Save configurations and reboot the system.  
0️⃣ **Exit Without Applying** – Exit the tool without making changes.  

## 🔧 Development Guide
### Code Structure
```
openwrt-ice-t/
├── openwrt-ice-t.sh         # Main entry point
├── lib/
│   ├── banner.sh            # Displays the ASCII banner with integrated messages
│   ├── logging.sh           # Handles system logging
│   ├── menu_main.sh         # Main menu logic
│   ├── menu_isps.sh         # ISP configuration menu
│   ├── menu_tools.sh        # Tools menu
│   ├── menu_enhancements.sh # Enhancements menu
│   ├── uci_helpers.sh       # UCI-based network settings
│   ├── utils.sh             # General utility functions
│   ├── isps/                # ISP configuration scripts folder
│   ├── enhancements/        # Network enhancements scripts folder
│   ├── tools/               # Network tools scripts folder
```

### Development

#### UI Message System
To maintain UI consistency, every script should include an `additional_message` variable. This variable is used to display additional banner messages or warnings to the user and will be shown at the next UI refresh.

Use the following tags to categorize your messages:
- `[INFO]` for informational messages
- `[ERROR]` for error messages
- `[WARNING]` for warning messages
- `[DEBUG]` for debug messages
- `[OK]` for success messages

Example usage in a script:
```sh
log "[INFO] This is a log message saved in the log file /var/log/openwrt-ice-t.log"
message "[INFO] This is a continuous message displayed"
additional_message="[INFO] This is an additional banner message."
```
## How It Works

- `log "[INFO] ..."`: Saves the message to the system log for tracking.
- `message "[INFO] ..."`: Displays a real-time message to the user.
- `additional_message="[INFO] ..."`: Stores a message that will be displayed in the next UI refresh.

This structure ensures that users receive clear, categorized, and actionable messages while interacting with the system. 🚀

### ISP Development Guide

#### **How ISP Scripts Work**
ISP scripts are the core of ICE-T, enabling **automatic configuration of network settings** for different ISPs. Each ISP has a dedicated script stored in `lib/isps/`.

- **Naming Convention**: Files must be named `isp_COUNTRY_ISPNAME.sh`.
- **Function Naming**: The function inside must match the filename but prefixed with `run_`. Example:
    - File: `isp_portugal_vodafone.sh`
    - Function: `run_isp_portugal_vodafone()`
- **BANNER FIRST**: Every ISP function must begin with `banner` for UI consistency.
- **ISP_COUNTRY and ISP_NAME**: Each script must define `ISP_COUNTRY` and `ISP_NAME` for menu display.

#### Example ISP Script: Vodafone Portugal
```sh
#!/bin/sh

ISP_COUNTRY="Portugal"
ISP_NAME="Vodafone"

run_isp_portugal_vodafone() {
    while true; do
        banner
        echo "Configuring $ISP_NAME ($ISP_COUNTRY):"
        echo "1) Internet (Support coming soon)"
        echo "2) IPTV (Support coming soon)"
        echo "3) VOIP (Support coming soon)"
        echo "0) Go back to Main Menu"
        read -r vodafone_choice
        case $vodafone_choice in
            1|2|3)
                log "[WARNING] Support for $ISP_NAME ($ISP_COUNTRY) is coming soon."
                additional_message="[WARNING] Support for $ISP_NAME ($ISP_COUNTRY) is coming soon."
                ;;
            0)
                additional_message="[WARNING] $ISP_NAME ($ISP_COUNTRY): Configuration not applied."
                display_main_menu  # Return to the main menu
                return
                ;;
            *)
                log "[ERROR] Invalid option selected: $vodafone_choice"
                additional_message="[ERROR] Invalid option! Choose 1-4."
                ;;
        esac
    done
} 
```

### Tools Development Guide
#### **How Tools Scripts Work**
Tools scripts provide various network diagnostics and debugging utilities. Each tool has a dedicated script stored in `lib/tools/`.

- **Naming Convention**: Files must be named `tool_TOOLNAME.sh`.
- **Function Naming**: The function inside must match the filename but prefixed with `run_`. Example:
    - File: `tool_ping.sh`
    - Function: `run_tool_ping()`
- **BANNER FIRST**: Every tool function must begin with `banner` for UI consistency.
- **TOOL_NAME**: Each script must define `TOOL_NAME` for menu display.

#### Example Tool Script: Ping
```sh
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
```

### Enhancements Development Guide
#### **How Enhancements Scripts Work**
Enhancements scripts optimize OpenWrt settings for performance and security. Each enhancement has a dedicated script stored in `lib/enhancements/`.

- **Naming Convention**: Files must be named `enhancement_ENHANCEMENTNAME.sh`.
- **Function Naming**: The function inside must match the filename but prefixed with `run_`. Example:
    - File: `enhancement_cloudflare_dns.sh`
    - Function: `run_enhancement_cloudflare_dns()`
- **BANNER FIRST**: Every enhancement function must begin with `banner` for UI consistency.
- **ENHANCEMENT_NAME**: Each script must define `ENHANCEMENT_NAME` for menu display.

#### Example Enhancement Script: Cloudflare DNS
```sh
#!/bin/sh

ENHANCEMENT_NAME="Example Enhancement - Cloudflare DNS"

run_enhancement_cloudflare_dns() {
    banner  # Always display the banner first
    message "Applying Cloudflare DNS settings for WAN and WAN6..."

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
```

## 🤝 Contributing
We welcome community contributions! To ensure consistency, follow these guidelines:
- **Follow coding standards** – Keep scripts clean and well-documented.
- **Use correct naming conventions** – ISP scripts must follow the required format.
- **Test before submitting** – Ensure that new scripts work without breaking existing functionality.
- **Engage with the community** – Discuss features in GitHub Discussions before major changes.

### Contribution Steps
1. **Fork the repository**.
2. **Create a new branch**: `git checkout -b feature-name`.
3. **Make your changes** and test them.
4. **Submit a pull request (PR)**.

## 📜 License
This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

## 📞 Support & Community
- **GitHub Issues:** [Report a bug](https://github.com/penalte/openwrt-ice-t/issues)
- **Discussions:** Join our [GitHub Discussions](https://github.com/penalte/openwrt-ice-t/discussions)
- **Contributors:** A big thanks to all contributors who help improve ICE-T! 🎉

## 👥 Contributors
Thanks goes to these wonderful people:

[![Contributors](https://contrib.rocks/image?repo=penalte/OpenWrt-ICE-T)](https://github.com/penalte/OpenWrt-ICE-T/graphs/contributors)
