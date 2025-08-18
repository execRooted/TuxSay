#!/bin/bash
set -e
clear

echo "🚀 === Tasky System-Wide Installer ==="

# Function to detect Linux family
detect_linux() {
    if command -v pacman &> /dev/null; then
        echo "arch"
    elif command -v apt &> /dev/null; then
        echo "debian"
    elif command -v dnf &> /dev/null; then
        echo "fedora"
    elif command -v zypper &> /dev/null; then
        echo "opensuse"
    else
        echo "unsupported"
    fi
}

LINUX_FAMILY=$(detect_linux)
if [ "$LINUX_FAMILY" = "unsupported" ]; then
    echo "❌ Unsupported OS"
    exit 1
fi

echo "🔎 Detected Linux family: $LINUX_FAMILY"

# Function to install dependencies
install_deps() {
    case "$LINUX_FAMILY" in
        arch)
            echo "🔵 Installing dependencies on Arch..."
            sudo pacman -Sy --needed --noconfirm base-devel git dotnet-sdk mpv
            ;;
        debian)
            echo "🔵 Installing dependencies on Debian/Ubuntu..."
            sudo apt update
            sudo apt install -y wget git apt-transport-https mpv

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
            sudo apt install -y dotnet-sdk-9.0
            ;;
        fedora)
            echo "🔵 Installing dependencies on Fedora..."
            sudo dnf install -y git dotnet-sdk-9.0 mpv
            ;;
        opensuse)
            echo "🔵 Installing dependencies on openSUSE..."
            sudo zypper install -y git dotnet-sdk-9.0 mpv
            ;;
    esac
}

# 1. Check for dotnet SDK
if ! command -v dotnet &> /dev/null; then
    install_deps
else
    echo "✅ Dotnet SDK found: $(dotnet --version)"
fi

# 2. Ensure we are in the Tasky project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f "Tasky.csproj" ]; then
    echo "🔵 Tasky project not found in current directory"
    read -p "Do you want to clone the repository? (y/n): " clone_choice
    if [ "$clone_choice" = "y" ]; then
        git clone https://github.com/your-repo/tasky.git
        cd tasky || exit 1
    else
        echo "❌ Please run this script in the Tasky project directory"
        exit 1
    fi
fi

# 3. Restore and build Tasky
echo "🔵 Restoring NuGet packages..."
dotnet restore

echo "🔵 Building Tasky..."
dotnet build -c Release

# 4. Publish Tasky as a self-contained executable
echo "🔵 Publishing Tasky..."
dotnet publish -c Release -r linux-x64 --self-contained true -o ./publish /p:PublishSingleFile=true

# 5. Find the published executable
EXE_PATH=$(find ./publish -maxdepth 1 -type f -executable | head -n 1)
if [ -z "$EXE_PATH" ]; then
    echo "❌ Error: Published executable not found!"
    exit 1
fi

# 6. Install system-wide
echo "🔵 Installing Tasky to /usr/local/bin..."
sudo cp "$EXE_PATH" /usr/local/bin/tasky
sudo chmod +x /usr/local/bin/tasky

# 7. Create desktop entry
echo "🔵 Creating desktop entry..."
sudo tee /usr/share/applications/tasky.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Tasky 
Comment=Task Management Application
Exec=tasky
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Utility;Productivity;
EOF

echo ""
echo "🎉 Installation complete!"
echo "You can now run Tasky from anywhere by typing: tasky"
echo ""
echo "Made by execRooted"
echo "github: github.com/execRooted/Tasky"
