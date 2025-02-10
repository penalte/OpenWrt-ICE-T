# OpenWrt-ICE-T

OpenWrt ICE-T: ISP Configurations, Enhancements &amp; Tools



openwrt-ice-t/
├── openwrt-ice-t.sh                            # Main entry point script
├── lib/
│   ├── banner.sh                               # Banner display logic with messages
│   ├── logging.sh                              # Logging and message handling
│   ├── utils.sh                                # Utility functions (e.g., IP validation)
│   ├── uci_helpers.sh                          # UCI-related helper functions
│   ├── menu_main.sh                            # Main menu logic
│   ├── menu_isps.sh                            # ISP´s menu logic to dynamically load ISP scripts
│   ├── menu_tools.sh                           # Tools menu logic to dynamically load tool scripts
│   ├── menu_enhancements.sh                    # Enhancements menu logic to dynamically load enhancement scripts
│   ├── isps/
│   │   ├── isp_portugal_vodafone.sh            # Portugal Vodafone ISP logic
│   │   ├── isp_portugal_meo.sh                 # Portugal MEO ISP logic
│   │   ├── isp_portugal_nos.sh                 # Portugal NOS ISP logic
│   │   └── isp_portugal_digi.sh                # Portugal Digi ISP logic
│   ├── tools/
│   │   ├── tool_device_ip.sh                   # Configure LAN IP
│   │   ├── tool_netmask.sh                     # Configure Netmask
│   │   └── tool_wifi.sh                        # Configure WiFi
│   └── enhancements/
│       └── enhancement_dumb_ap.sh              # Configure Dumb AP
├── README.md                                   # Documentation for the project
└── LICENSE                                     # License file