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

echo -e "${YELLOW}Pilih operasi yang ingin dijalankan:${NC}"
echo "1) Subdomain Enumeration"
echo "2) Check Live Subdomains"
echo "3) Historical URLs"
echo "4) Filter URLs with Parameters"
echo "5) GF Pattern Filtering"
echo "6) Cari Form Login dan Upload"
echo "7) Jalankan Semua"
echo "8) Keluar"

read -p "Masukkan pilihan [1-8]: " CHOICE

case $CHOICE in
    1)
        echo -e "${GREEN}[+] Finding subdomains with subfinder...${NC}"
        subfinder -d "$DOMAIN" -silent
        ;;
    2)
        echo -e "${GREEN}[+] Checking live subdomains with httpx...${NC}"
        subfinder -d "$DOMAIN" -silent | httpx -sc -title
        ;;
    3)
        echo -e "${GREEN}[+] Collecting historical URLs with waybackurls...${NC}"
        echo "$DOMAIN" | waybackurls

        echo -e "${GREEN}[+] Collecting historical URLs with gau...${NC}"
        echo "$DOMAIN" | gau
        ;;
    4)
        echo -e "${GREEN}[+] Filtering URLs with parameters (from both sources)...${NC}"
        echo -e "${CYAN}-- URL with '=' from waybackurls --${NC}"
        echo "$DOMAIN" | waybackurls | grep "="

        echo -e "${CYAN}-- URL with '=' from gau --${NC}"
        echo "$DOMAIN" | gau | grep "="
        ;;
    5)
        if command -v gf &> /dev/null; then
            echo -e "${GREEN}[+] Filtering with gf patterns...${NC}"

            echo -e "${CYAN}-- Possible XSS --${NC}"
            echo "$DOMAIN" | gau | grep "=" | gf xss

            echo -e "${CYAN}-- Possible SQLi --${NC}"
            echo "$DOMAIN" | gau | grep "=" | gf sqli
        else
            echo -e "${YELLOW}[!] gf not installed. Skipping gf filtering...${NC}"
        fi
        ;;
    6)
        echo -e "${GREEN}[+] Mencari form login dan upload di historical URLs...${NC}"

        # Gabungkan hasil dari waybackurls dan gau
        echo -e "${CYAN}[*] Mengumpulkan URL dari waybackurls & gau...${NC}"
        URLS=$( (echo "$DOMAIN" | waybackurls; echo "$DOMAIN" | gau) | sort -u )

        # Simpan URL yang mencurigakan (mengandung keyword login/upload)
        echo "$URLS" | grep -Ei 'login|signin|auth|admin|upload' > potential_forms.txt

        echo -e "${CYAN}[*] Memeriksa keberadaan form pada URL...${NC}"
        > found_forms.txt

        while read -r url; do
            echo -e "${YELLOW}[Checking] $url${NC}"

            RESPONSE=$(curl -sk --max-time 10 "$url" | grep -Eio '<form|type=["'\'']?file["'\'']?|type=["'\'']?password["'\'']?>')

            if [[ -n "$RESPONSE" ]]; then
                echo -e "${GREEN}[+] Form ditemukan di: $url${NC}"
                echo "$url" >> found_forms.txt
            fi
        done < potential_forms.txt

        if [ -s found_forms.txt ]; then
            echo -e "${GREEN}[✔] Form login/upload ditemukan. Lihat file: found_forms.txt${NC}"
        else
            echo -e "${YELLOW}[-] Tidak ditemukan form login atau upload.${NC}"
        fi

        rm -f potential_forms.txt
        ;;
    7)
        echo -e "${GREEN}[+] Running full recon...${NC}"

        echo -e "${GREEN}[+] Finding subdomains with subfinder...${NC}"
        subfinder -d "$DOMAIN" -silent

        echo -e "${GREEN}[+] Checking live subdomains with httpx...${NC}"
        subfinder -d "$DOMAIN" -silent | httpx -sc -title

        echo -e "${GREEN}[+] Collecting historical URLs with waybackurls...${NC}"
        echo "$DOMAIN" | waybackurls

        echo -e "${GREEN}[+] Collecting historical URLs with gau...${NC}"
        echo "$DOMAIN" | gau

        echo -e "${GREEN}[+] Filtering URLs with parameters (from both sources)...${NC}"
        echo "$DOMAIN" | waybackurls | grep "="
        echo "$DOMAIN" | gau | grep "="

        if command -v gf &> /dev/null; then
            echo -e "${GREEN}[+] Filtering with gf patterns...${NC}"
            echo "$DOMAIN" | gau | grep "=" | gf xss
            echo "$DOMAIN" | gau | grep "=" | gf sqli
        else
            echo -e "${YELLOW}[!] gf not installed. Skipping gf filtering...${NC}"
        fi
        ;;
    8)
        echo -e "${CYAN}Bye!${NC}"
        exit 0
        ;;
    *)
        echo -e "${YELLOW}[!] Pilihan tidak valid.${NC}"
        ;;
esac

echo -e "${GREEN}[✔] Recon complete for $DOMAIN${NC}"
