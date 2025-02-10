#!/bin/sh

TOOL_NAME="Export UCI Pending Changes to Defaults File"

defaults_file="/etc/uci-defaults/custom-config"

echo "Exporting pending UCI changes to: $defaults_file"

# Ensure the directory exists
mkdir -p "$(dirname "$defaults_file")"

# Start writing the defaults file
cat << EOF > "$defaults_file"
#!/bin/sh

# ICE-T Banner
echo "    _______                     ________        __       "
echo "   |       |.-----.-----.-----.|  |  |  |.----.|  |_     "  
echo "   |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|    "
echo "   |_______||   __|_____|__|__||________||__|  |____|    "
echo "     ICE-T: |__| ISP Configurations, Enhancements & Tools"

echo "Applying UCI default settings..."
EOF

# Append all pending UCI changes to the file
uci show | grep -v "^#" >> "$defaults_file"

echo "chmod +x $defaults_file"
chmod +x "$defaults_file"

echo "[OK] UCI changes exported successfully to $defaults_file"

echo "Do you want to view the generated file? (y/n)"
read -r view_choice
if [ "$view_choice" = "y" ]; then
    echo ""
    echo ""
    echo "######### START COPYING HERE #########"
    cat "$defaults_file"
    echo "######### END COPYING HERE #########"
    echo ""
    echo ""
    echo "Press Enter to return to the menu..."
    read -r
fi
