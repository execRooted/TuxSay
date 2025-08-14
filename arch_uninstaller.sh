#!/bin/bash
set -e

echo "=== TuxSay Uninstaller ==="

# Remove the tuxsay executable
if [ -f /usr/local/bin/tuxsay ]; then
    echo "Removing /usr/local/bin/tuxsay..."
    sudo rm /usr/local/bin/tuxsay
    echo "tuxsay removed."
else
    echo "tuxsay executable not found in /usr/local/bin."
fi

echo "=== TuxSay uninstallation complete ==="
