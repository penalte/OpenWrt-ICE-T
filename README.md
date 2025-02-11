# ICE-T: ISP Configurations, Enhancements & Tools

![ICE-T Logo](https://raw.githubusercontent.com/penalte/OpenWrt-ICE-T/refs/heads/main/images/logo.png?token=GHSAT0AAAAAAC5A7N5VWFTP44RMXU3NFI6GZ5KRZ6A)

[![GitHub release](https://img.shields.io/github/v/release/penalte/openwrt-ice-t)](https://github.com/penalte/openwrt-ice-t/releases) [![GitHub contributors](https://img.shields.io/github/contributors/penalte/openwrt-ice-t)](https://github.com/penalte/openwrt-ice-t/graphs/contributors) [![License](https://img.shields.io/github/license/penalte/openwrt-ice-t)](LICENSE) [![Issues](https://img.shields.io/github/issues/penalte/openwrt-ice-t)](https://github.com/penalte/openwrt-ice-t/issues)

## 🔹 Overview
ICE-T (**ISP Configurations, Enhancements & Tools**) is a powerful and modular **network automation framework** designed specifically for OpenWrt. Unlike generic OpenWrt tools, ICE-T provides a **specialized approach** for automating ISP configurations, optimizing network performance, and offering advanced troubleshooting utilities.

Initially developed to **simplify ISP configurations for Portugal-based ISPs**, ICE-T has evolved into a **versatile, modular solution** that supports multiple ISPs worldwide. With **a structured, menu-driven CLI**, it caters to both novice users and advanced administrators, ensuring seamless configuration, security, and performance enhancements.

## 🚀 Features
✔ **Automated ISP Configuration** – Pre-configured profiles for major ISPs (Vodafone, MEO, NOS, Digi, and more).  
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
   scp openwrt-ice-t.run root@<router-ip>:/root/
```

## 🎯 Usage
Run the main script:
```sh
./openwrt-ice-t.sh
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
├── openwrt-ice-t.sh        # Main entry point
├── lib/
│   ├── banner.sh           # Displays the ASCII banner
│   ├── logging.sh          # Handles system logging
│   ├── menu_main.sh        # Main menu logic
│   ├── menu_isps.sh        # ISP configuration menu
│   ├── menu_tools.sh       # Tools menu
│   ├── menu_enhancements.sh # Enhancements menu
│   ├── uci_helpers.sh      # UCI-based network settings
│   ├── utils.sh            # General utility functions
│   ├── isps/               # ISP configuration scripts
│   ├── enhancements/       # Network enhancements
│   ├── tools/              # Network tools scripts
```

### ISP Development Guide
#### **How ISP Scripts Work**
ISP scripts are the core of ICE-T, enabling **automatic configuration of network settings** for different ISPs. Each ISP has a dedicated script stored in `lib/isps/`.

- **Naming Convention**: Files must be named `isp_COUNTRY_ISPNAME.sh`.
- **Function Naming**: The function inside must match the filename but prefixed with `configure_`. Example:
  - File: `isp_portugal_vodafone.sh`
  - Function: `configure_isp_portugal_vodafone()`
- **BANNER FIRST**: Every ISP function must begin with `banner` for UI consistency.

#### Example ISP Script: Vodafone Portugal
```sh
#!/bin/sh

ISP_COUNTRY="Portugal"
ISP_NAME="Vodafone"

configure_isp_portugal_vodafone() {
    banner  # Always display the banner first
    while true; do
        echo "Configuring $ISP_NAME ($ISP_COUNTRY):"
        echo "1) Internet only"
        echo "2) Internet + IPTV"
        echo "3) Internet + IPTV + VOIP"
        echo "0) Go back to ISP selection"
        read -r vodafone_choice
        case $vodafone_choice in
            1) log_message "[INFO] Configuring Internet only..." ;;
            2) log_message "[INFO] Configuring Internet + IPTV..." ;;
            3) log_message "[INFO] Configuring Internet + IPTV + VOIP..." ;;
            0) return ;; # Return to ISP selection
            *) log_message "[ERROR] Invalid option selected: $vodafone_choice" ;;
        esac
    done
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