#!/usr/bin/env bash

# Ensure only one instance of this script runs
LOCK_FILE="/tmp/setup-bar.lock"
if [[ -f "$LOCK_FILE" ]]; then
    OLD_PID=$(cat "$LOCK_FILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        # Another instance is running, exit
        exit 0
    fi
fi
echo $$ > "$LOCK_FILE"

# Watch both the source file (for manual edits) and the symlink target (for home-manager updates)
SOURCE_FILE="$HOME/nix-conf/quickshell/shell.qml"
SYMLINK_FILE="$HOME/.config/quickshell/shell.qml"
previous_hash=""

# Function to get the hash of the actual file quickshell uses
get_config_hash() {
    # Get the resolved path (follow symlinks)
    local resolved_file=$(readlink -f "$SYMLINK_FILE" 2>/dev/null || echo "$SYMLINK_FILE")
    if [[ -f "$resolved_file" ]]; then
        md5sum "$resolved_file" 2>/dev/null | cut -d' ' -f1
    elif [[ -f "$SOURCE_FILE" ]]; then
        # Fallback to source file if symlink doesn't exist yet
        md5sum "$SOURCE_FILE" 2>/dev/null | cut -d' ' -f1
    fi
}

# Function to kill all quickshell processes
kill_quickshell() {
    # Kill by exact process name
    pkill -x qs 2>/dev/null
    # Also kill by pattern (in case of child processes)
    pkill -f quickshell 2>/dev/null
    # Wait a bit for processes to terminate
    sleep 0.3
    # Double-check and force kill if still running
    pkill -9 -x qs 2>/dev/null
    pkill -9 -f quickshell 2>/dev/null
    sleep 0.1
}

# Kill any existing quickshell processes
kill_quickshell

# Start quickshell initially
qs &

while true; do
    current_hash=$(get_config_hash)
    
    # If hash changed, restart quickshell
    if [[ -n "$current_hash" && "$current_hash" != "$previous_hash" && -n "$previous_hash" ]]; then
        echo "Quickshell config changed, restarting..."
        kill_quickshell
        qs &
    fi
    
    # Update hash for next comparison (initialize on first run)
    if [[ -n "$current_hash" ]]; then
        previous_hash="$current_hash"
    fi
    
    sleep 2
done
