#!/bin/bash

echo "=================================="
echo "    Bug Bounty Tool Installer     "
echo "=================================="

# 1. Install Golang
echo "[*] Installing Golang..."
sudo apt update
sudo apt install golang-go git -y

# 2. Setup environment
echo "[*] Setting up Go environment..."
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc

# 3. Install Subfinder
echo "[*] Installing subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# 4. Install httpx
echo "[*] Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# 5. Install waybackurls
echo "[*] Installing waybackurls..."
go install github.com/tomnomnom/waybackurls@latest

# 6. Install gau
echo "[*] Installing gau..."
go install github.com/lc/gau/v2/cmd/gau@latest

# 7. Install gf
echo "[*] Installing gf..."
go install github.com/tomnomnom/gf@latest

# 8. Install GF-Patterns
echo "[*] Installing gf patterns..."
git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf
echo 'export GF_PATH=$HOME/.gf' >> ~/.bashrc
source ~/.bashrc

# 9. Final PATH export (just to be sure)
export PATH=$PATH:$(go env GOPATH)/bin
export GF_PATH=$HOME/.gf

# 10. Done
echo "=================================="
echo "[+] All tools installed successfully!"
echo "[+] Please restart terminal or run: source ~/.bashrc"
echo "=================================="