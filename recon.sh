#!/bin/bash

# ===========================================
# Bug Bounty Recon Script - Terminal Only
# ===========================================


# Warna terminal

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Cek input domain
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 domain.com${NC}"
    exit 1
fi

DOMAIN=$1

echo -e "${CYAN}[*] Starting recon for ${DOMAIN}${NC}"

# 1. Cari subdomain
echo -e "${GREEN}[+] Finding subdomains with subfinder...${NC}"
subfinder -d $DOMAIN -silent

# 2. Cek yang aktif pakai httpx
echo -e "${GREEN}[+] Checking live subdomains with httpx...${NC}"
subfinder -d $DOMAIN -silent | httpx -status-code -title -silent

# 3. Ambil URL historis dari waybackurls dan gau
echo -e "${GREEN}[+] Collecting historical URLs with waybackurls...${NC}"
echo $DOMAIN | waybackurls

echo -e "${GREEN}[+] Collecting historical URLs with gau...${NC}"
echo $DOMAIN | gau

# 4. Gabung dan filter URL yang punya parameter
echo -e "${GREEN}[+] Filtering URLs with parameters (from both sources)...${NC}"
echo -e "${CYAN}-- URL with '=' from waybackurls --${NC}"
echo $DOMAIN | waybackurls | grep "="

echo -e "${CYAN}-- URL with '=' from gau --${NC}"
echo $DOMAIN | gau | grep "="

# 5. Filter pakai gf (jika tersedia)
if command -v gf &> /dev/null; then
    echo -e "${GREEN}[+] Filtering with gf patterns...${NC}"
    
    echo -e "${CYAN}-- Possible XSS --${NC}"
    echo $DOMAIN | gau | grep "=" | gf xss

    echo -e "${CYAN}-- Possible SQLi --${NC}"
    echo $DOMAIN | gau | grep "=" | gf sqli
else
    echo -e "${YELLOW}[!] gf not installed. Skipping gf filtering...${NC}"
fi

# 6. Selesai
echo -e "${GREEN}[✔] Recon complete for $DOMAIN${NC}"
