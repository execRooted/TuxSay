#!/bin/bash
set -e

echo "=== TuxSay Installer ==="

# 1. Check for dotnet SDK
if ! command -v dotnet &> /dev/null
then
    echo "Dotnet SDK not found. Installing .NET SDK via pacman..."
    sudo pacman -Sy --noconfirm dotnet-sdk
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
EXE_PATH=$(find ./publish -maxdepth 1 -type f -executable)

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
