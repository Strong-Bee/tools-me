#!/bin/bash

echo "=================================="
echo "    Bug Bounty Tool Installer     "
echo "=================================="

# Detect OS (Ubuntu/Debian)
if ! command -v apt &>/dev/null; then
    echo "[!] This script currently supports Debian/Ubuntu only."
    exit 1
fi

# 1. Install Golang + Git
echo "[*] Installing Golang & Git..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y golang-go git curl

# 2. Setup Go environment
if ! grep -q 'export PATH=.*GOPATH' ~/.bashrc; then
    echo "[*] Setting up Go environment..."
    echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    source ~/.bashrc
fi

# Ensure GOPATH exists
mkdir -p "$HOME/go/bin"

# 3. Install Subfinder
echo "[*] Installing subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# 4. Install httpx
echo "[*] Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# 5. Install waybackurls
echo "[*] Installing waybackurls..."
go install -v github.com/tomnomnom/waybackurls@latest

# 6. Install gau
echo "[*] Installing gau..."
go install -v github.com/lc/gau/v2/cmd/gau@latest

# 7. Install gf
echo "[*] Installing gf..."
go install -v github.com/tomnomnom/gf@latest

# 8. Install GF-Patterns
echo "[*] Installing gf patterns..."
if [ ! -d "$HOME/.gf" ]; then
    git clone https://github.com/1ndianl33t/Gf-Patterns "$HOME/.gf"
fi

if ! grep -q 'export GF_PATH' ~/.bashrc; then
    echo 'export GF_PATH=$HOME/.gf' >> ~/.bashrc
    source ~/.bashrc
fi

# 9. Final PATH export (just to be sure)
export PATH=$PATH:$(go env GOPATH)/bin
export GF_PATH=$HOME/.gf

# 10. Verify installation
echo "=================================="
echo "[*] Verifying installations..."
for tool in subfinder httpx waybackurls gau gf; do
    if command -v $tool &>/dev/null; then
        echo "[✔] $tool installed: $($tool --version 2>/dev/null || echo 'OK')"
    else
        echo "[✘] $tool not found, check logs!"
    fi
done
echo "=================================="
echo "[+] All tools installed successfully!"
echo "[+] Please restart terminal or run: source ~/.bashrc"
echo "=================================="
