#!/bin/bash
set -e

echo "=== TuxSay Uninstaller ==="

# Function to detect Linux family
detect_linux() {
    if command -v pacman &> /dev/null; then
        echo "Arch"
    elif command -v apt &> /dev/null; then
        echo "Debian"
    elif command -v dnf &> /dev/null; then
        echo "Fedora"
    elif command -v zypper &> /dev/null; then
        echo "Opensuse"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

LINUX_FAMILY=$(detect_linux)
echo "Detected Linux family: $LINUX_FAMILY"

# Remove the tuxsay executable
if [ -f /usr/local/bin/tuxsay ]; then
    echo "Removing /usr/local/bin/tuxsay..."
    sudo rm /usr/local/bin/tuxsay
    echo "tuxsay removed."
else
    echo "tuxsay executable not found in /usr/local/bin."
fi

# Optionally remove .NET SDK (ask user first)
if command -v dotnet &> /dev/null; then
    read -p "Do you want to remove the .NET SDK? [y/N]: " REMOVE_DOTNET
    if [[ "$REMOVE_DOTNET" =~ ^[Yy]$ ]]; then
        case "$LINUX_FAMILY" in
            Arch)
                sudo pacman -Rns --noconfirm dotnet-sdk
                ;;
            Debian)
                sudo apt remove --purge -y dotnet-sdk-7.0
                sudo apt autoremove -y
                ;;
            Fedora)
                sudo dnf remove -y dotnet-sdk-7.0
                ;;
            Opensuse)
                sudo zypper remove -y dotnet-sdk-7.0
                ;;
        esac
        echo ".NET SDK removed."
    else
        echo "Skipped removing .NET SDK."
    fi
else
    echo ".NET SDK not found, nothing to remove."
fi



echo "=== TuxSay uninstallation complete ==="
