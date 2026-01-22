#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if keymapper is already installed
if ! command -v keymapper &> /dev/null; then
    echo "Installing Keymapper..."
    wget https://github.com/houmain/keymapper/releases/download/5.3.1/keymapper-5.3.1-Linux-x86_64.deb
    sudo apt install ./keymapper-5.3.1-Linux-x86_64.deb
else
    echo "✓ Keymapper is already installed"
fi

# Configuration options
configs=(
    "Multi-tap (bottom row single-handed):multitap.conf"
    "Right-hand mirrored:right_hand_mirrored_keymapper.conf"
    "Left-hand mirrored:left_hand_mirrored_keymapper.conf"
    "Full mirrored (both hands):full_mirrored_keymapper.conf"
)

# Setup autostart using desktop entry for user session
setup_autostart() {
    echo "Setting up autostart..."

    # Enable keymapper daemon
    sudo systemctl enable keymapperd 2>/dev/null || true

    echo "✓ System daemon enabled"
}

# Update autostart with selected config using desktop entry
update_autostart() {
    local config_file="$1"
    local config_name="$(basename "$config_file")"
    local autostart_file="$HOME/.config/autostart/keymapper.desktop"

    mkdir -p "$(dirname "$autostart_file")"

    # Create desktop entry pointing to our autostart script
    cat >"$autostart_file" <<EOT
[Desktop Entry]
Type=Application
Name=Keymapper
Comment=Remaps the keyboard for me
Exec=$SCRIPT_DIR/autostart.sh $config_name
Hidden=false
Terminal=false
X-GNOME-Autostart-enabled=true
EOT

    echo "✓ Autostart configured with: $config_name"
}

# Display menu
selected=0

show_menu() {
    clear
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│ Keymapper Configuration - Select Configuration      │"
    echo "├─────────────────────────────────────────────────────┤"
    echo "│ Choose a keyboard configuration:                    │"
    echo "│                                                     │"
    for i in "${!configs[@]}"; do
        IFS=':' read -r name file <<< "${configs[$i]}"
        if [ $i -eq $selected ]; then
            echo "│ ► $((i+1)) $name"
        else
            echo "│   $((i+1)) $name"
        fi
    done
    echo "│                                                     │"
    echo "│ (arrow keys, enter to select, esc to cancel)       │"
    echo "└─────────────────────────────────────────────────────┘"
}

# Main setup
echo ""
echo "Keymapper Setup"
echo "═══════════════"
echo ""

# Setup autostart
setup_autostart

echo ""

# Show configuration menu
while true; do
    show_menu
    read -rsn1 key
    case "$key" in
        $'\x1b')
            read -rsn2 key
            case "$key" in
                '[A') selected=$(( (selected - 1 + ${#configs[@]}) % ${#configs[@]} )) ;;
                '[B') selected=$(( (selected + 1) % ${#configs[@]} )) ;;
            esac
            ;;
        '')
            IFS=':' read -r name file <<< "${configs[$selected]}"
            CONFIG_FILE="$SCRIPT_DIR/$file"
            [ ! -f "$CONFIG_FILE" ] && echo "Error: $CONFIG_FILE not found" && read && continue
            pkill -f "keymapper" 2>/dev/null || true
            sleep 1
            # Update autostart with selected config
            update_autostart "$CONFIG_FILE"

            nohup keymapper -c "$CONFIG_FILE" -u > /dev/null 2>&1 &
            clear
            echo "✓ Setup complete"
            echo "✓ Configuration: $name"
            echo "✓ Config file: $file"
            echo "✓ Autostart configured"
            echo "✓ Keymapper started"
            exit 0
            ;;
        $'\x1b'|'q'|'Q') echo ""; echo "Setup cancelled."; exit 0 ;;
    esac
done
