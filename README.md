````markdown
<h1 align="center">🕵️‍♂️ tools-me</h1>
<p align="center">
  <i>Bug Bounty Recon Toolkit - Simple, Fast, and Powerful</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20WSL%20%7C%20GitBash-blue?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Language-Bash-green?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Status-Active-success?style=for-the-badge"/>
</p>

---

## ✨ Fitur

- 🔍 **Subdomain Enumeration** (via `subfinder`)  
- 🌐 **Check Live Subdomains** (via `httpx`)  
- 📜 **Historical URLs** (via `waybackurls` & `gau`)  
- 🧩 **Filter URLs with Parameters**  
- 🎯 **GF Pattern Filtering** (`xss`, `sqli`, dll)  
- 🔑 **Cari Form Login & Upload**  
- ⚡ **One-Click Full Recon**  

---

## 📥 Clone Repository

```bash
git clone https://github.com/Strong-Bee/tools-me.git
cd tools-me
````

---

## ⚙️ Install Dependency

Jalankan installer package terlebih dahulu:

```bash
bash install-tools.sh
```

---

## 🚀 Menjalankan Script

### Recon (versi standar)

```bash
bash recon.sh
# atau
./recon.sh
```

### Recon (versi update / extended)

```bash
bash recon-update.sh
# atau
./recon-update.sh
```

---

## 📌 Catatan

* Pastikan sudah terinstall tools berikut:

  * [subfinder](https://github.com/projectdiscovery/subfinder)
  * [httpx](https://github.com/projectdiscovery/httpx)
  * [gau](https://github.com/lc/gau)
  * [waybackurls](https://github.com/tomnomnom/waybackurls)
  * [gf](https://github.com/tomnomnom/gf)

* Untuk pengguna **Windows**:

  * Gunakan **Git Bash**, atau
  * **WSL (Ubuntu/Debian)** melalui VS Code.

---

## 📷 Demo Output

```
[*] Starting recon for example.com
[+] Finding subdomains with subfinder...
[+] Checking live subdomains with httpx...
[+] Collecting historical URLs...
[+] Filtering URLs with parameters...
[✔] Recon complete for example.com
```

---

<h3 align="center">💡 Dibuat dengan semangat oleh <a href="https://github.com/Strong-Bee">Strong Bee Developer</a></h3>
```

---