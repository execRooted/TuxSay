#!/bin/bash
set -e
clear

echo "=== TuxSay Installer ==="
# Function to detect Linux family
detect_linux() {
    if command -v pacman &> /dev/null; then
        echo "Arch"
    elif command -v apt &> /dev/null; then
        echo "Debian"
    elif command -v dnf &> /dev/null; then
        echo "Fedora"
    elif command -v zypper &> /dev/null; then
        echo "openSUSE"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

LINUX_FAMILY=$(detect_linux)
if [ "$LINUX_FAMILY" = "unsupported" ]; then
    echo "Unsupported OS. Made for Linux only!"
    exit 1
fi

echo "Detected Linux family: $LINUX_FAMILY"

# Function to install .NET SDK
install_dotnet() {
    case "$LINUX_FAMILY" in
        arch)
            echo "Installing .NET SDK on Arch-based system..."
            sudo pacman -Sy --noconfirm dotnet-sdk
            ;;
        debian)
            echo "Installing .NET SDK on Debian/Ubuntu..."
            OS_VERSION="unknown"
            if [ -f /etc/os-release ]; then
                OS_VERSION=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f2)
            fi
            echo "Detected OS version: $OS_VERSION"

            TMP_DEB=$(mktemp /tmp/packages-microsoft-prod.XXXX.deb)
            wget https://packages.microsoft.com/config/ubuntu/$OS_VERSION/packages-microsoft-prod.deb -O "$TMP_DEB" || \
            wget https://packages.microsoft.com/config/debian/$OS_VERSION/packages-microsoft-prod.deb -O "$TMP_DEB"
            sudo dpkg -i "$TMP_DEB"
            rm "$TMP_DEB"

            sudo apt update
            sudo apt install -y apt-transport-https dotnet-sdk-7.0
            ;;
        fedora)
            echo "Installing .NET SDK on Fedora..."
            sudo dnf install -y dotnet-sdk-7.0
            ;;
        opensuse)
            echo "Installing .NET SDK on openSUSE..."
            sudo zypper install -y dotnet-sdk-7.0
            ;;
    esac
}

# 1. Check for dotnet SDK
if ! command -v dotnet &> /dev/null; then
    install_dotnet
else
    echo "Dotnet SDK found: $(dotnet --version)"
fi

# 2. Navigate to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 3. Publish TuxSay as a self-contained executable
echo "Publishing TuxSay..."
dotnet publish -c Release -r linux-x64 --self-contained true -o ./publish /p:PublishSingleFile=true

# 4. Find the published executable
EXE_PATH=$(find ./publish -maxdepth 1 -type f -executable | head -n 1)

if [ -z "$EXE_PATH" ]; then
    echo "Error: Published executable not found!"
    exit 1
fi




# 5. Copy the executable to /usr/local/bin as 'tuxsay'
echo "Copying executable to /usr/local/bin..."
sudo cp "$EXE_PATH" /usr/local/bin/tuxsay
sudo chmod +x /usr/local/bin/tuxsay





echo "=== Installation complete! ==="
echo "You can now run 'tuxsay' from anywhere."
