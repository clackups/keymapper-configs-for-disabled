#!/bin/bash

# Keymapper autostart script for user session startup
# This script should be added to user's startup applications

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/$1"  # Pass config file as first argument

# Default config if none specified or file doesn't exist
if [ -z "$1" ] || [ ! -f "$CONFIG_FILE" ]; then
    CONFIG_FILE="$SCRIPT_DIR/multitap.conf"
    echo "[Keymapper Autostart] Using default config: $(basename "$CONFIG_FILE")"
fi

# Check if keymapper is installed
if ! command -v keymapper &> /dev/null; then
    echo "[Keymapper Autostart] Error: Keymapper not found"
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "[Keymapper Autostart] Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

# Function to kill existing keymapper processes
kill_keymapper() {
    pkill -f "keymapper.*-u" 2>/dev/null || true
    sleep 2
}

# Start keymapper with selected config
start_keymapper() {
    echo "[Keymapper Autostart] Starting with config: $(basename "$CONFIG_FILE")"

    # Kill any existing instances
    kill_keymapper

    # Start new instance
    cd "$SCRIPT_DIR"

    # Create log directory if it doesn't exist
    mkdir -p "$(dirname /tmp/keymapper-autostart.log)"

    # Start new instance with proper environment
    nohup keymapper -c "$CONFIG_FILE" -u > /tmp/keymapper-autostart.log 2>&1 &

    # Verify it started
    sleep 3
    if pgrep -f "keymapper.*-u" > /dev/null; then
        echo "[Keymapper Autostart] Started successfully"
    else
        echo "[Keymapper Autostart] Failed to start"
        echo "[Keymapper Autostart] Log output:"
        cat /tmp/keymapper-autostart.log
    fi
}

# Handle different startup methods
case "$1" in
    --test)
        echo "[Keymapper Autostart] Test mode"
        echo "Config file: $CONFIG_FILE"
        echo "Keymapper found: $(command -v keymapper)"
        echo "Config file exists: $([ -f "$CONFIG_FILE" ] && echo 'Yes' || echo 'No')"
        ;;
    *)
        start_keymapper
        ;;
esac