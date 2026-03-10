#!/bin/bash

# ============================================================
# ⚔️  CYBER OPS ROOM SETUP - asrar-mared
# ============================================================
# المحارب الرقمي: asrar-mared
# Email: nike49424@proton.me
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

banner() {
  echo -e "${RED}"
  echo "  ██████╗██╗   ██╗██████╗ ███████╗██████╗      ██████╗ ██████╗ ███████╗"
  echo " ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗    ██╔═══██╗██╔══██╗██╔════╝"
  echo " ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝    ██║   ██║██████╔╝███████╗"
  echo " ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗    ██║   ██║██╔═══╝ ╚════██║"
  echo " ╚██████╗   ██║   ██████╔╝███████╗██║  ██║    ╚██████╔╝██║     ███████║"
  echo "  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝ ╚═╝     ╚══════╝"
  echo -e "${CYAN}           ⚔️  ROOM SETUP — asrar-mared ⚔️${NC}"
  echo ""
}

step() { echo -e "\n${CYAN}${BOLD}[*] $1${NC}"; }
ok()   { echo -e "${GREEN}[✓] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }

banner

# ============================================================
# 1. SYSTEM UPDATE
# ============================================================
step "تحديث النظام..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y curl wget git nano htop tree unzip software-properties-common \
  apt-transport-https ca-certificates gnupg lsb-release build-essential
ok "تم تحديث النظام"

# ============================================================
# 2. GIT CONFIGURATION - ربط Gitea
# ============================================================
step "إعداد Git + ربط Gitea..."

git config --global user.name "asrar-mared"
git config --global user.email "nike49424@proton.me"
git config --global init.defaultBranch main
git config --global core.editor nano
git config --global pull.rebase false

ok "تم إعداد Git"

# توليد SSH Key لـ Gitea
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "nike49424@proton.me" -f ~/.ssh/id_ed25519 -N ""
  ok "تم إنشاء SSH Key"
else
  warn "SSH Key موجود بالفعل"
fi

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📋 المفتاح العام — انسخه وأضفه في Gitea → Settings → SSH Keys"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat ~/.ssh/id_ed25519.pub
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# SSH config لـ Gitea
mkdir -p ~/.ssh
cat >> ~/.ssh/config << 'SSHCONF'

Host gitea
  HostName gitea.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  StrictHostKeyChecking no
SSHCONF
chmod 600 ~/.ssh/config
ok "تم إعداد SSH Config لـ Gitea"

# استنساخ المستودع الرئيسي (اختياري - يعمل بعد إضافة SSH Key)
# git clone git@gitea.com:asrar-mared/REPO_NAME.git ~/ops/main-repo

# ============================================================
# 3. أدوات الأمن السيبراني الأساسية
# ============================================================
step "تثبيت أدوات الأمن السيبراني..."

# Network Tools
sudo apt install -y nmap wireshark netcat-openbsd tcpdump arp-scan masscan
ok "أدوات الشبكة: nmap, wireshark, netcat, tcpdump"

# Security Analysis
sudo apt install -y nikto sqlmap hydra john hashcat aircrack-ng
ok "أدوات التحليل: nikto, sqlmap, hydra, john, hashcat"

# Forensics & Traffic
sudo apt install -y autopsy binwalk foremost exiftool steghide
ok "أدوات الفورنزيك"

# Firewall & Hardening
sudo apt install -y ufw fail2ban iptables-persistent
ok "أدوات الجدار الناري"

# Web Security
sudo apt install -y dirb gobuster whatweb wfuzz
ok "أدوات أمن الويب"

# Monitoring
sudo apt install -y nethogs iftop vnstat sysstat
ok "أدوات المراقبة"

# ============================================================
# 4. Python بيئة الأمن
# ============================================================
step "إعداد Python + مكتبات الأمن..."

sudo apt install -y python3 python3-pip python3-venv python3-dev
pip3 install --break-system-packages \
  scapy requests beautifulsoup4 paramiko cryptography \
  pwntools shodan censys impacket
ok "تم تثبيت Python وأدواته"

# ============================================================
# 5. Node.js
# ============================================================
step "تثبيت Node.js..."

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node --version && npm --version
ok "Node.js مثبت"

# ============================================================
# 6. Docker
# ============================================================
step "تثبيت Docker..."

if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sudo bash
  sudo usermod -aG docker "$USER"
  ok "تم تثبيت Docker"
else
  warn "Docker مثبت مسبقاً"
fi

# ============================================================
# 7. إعداد UFW Firewall
# ============================================================
step "إعداد UFW Firewall..."

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
ok "Firewall مفعّل"

# ============================================================
# 8. Fail2ban
# ============================================================
step "تفعيل Fail2ban..."

sudo systemctl enable fail2ban
sudo systemctl start fail2ban
ok "Fail2ban يعمل"

# ============================================================
# 9. هيكل مجلدات غرفة العمليات
# ============================================================
step "إنشاء هيكل مجلدات غرفة العمليات..."

mkdir -p ~/ops/{projects,tools,reports,logs,payloads,wordlists,captures,scripts,notes}
mkdir -p ~/ops/projects/{web-sec,network-sec,forensics,pentest,ctf}
mkdir -p ~/ops/logs/{system,network,alerts}

cat > ~/ops/README.md << 'README'
# ⚔️ غرفة العمليات — asrar-mared

## هيكل المجلدات
- projects/   → مشاريع الأمن السيبراني
- tools/      → أدوات مخصصة
- reports/    → تقارير الاختبار
- logs/       → السجلات
- payloads/   → حمولات الاختبار
- wordlists/  → قوائم الكلمات
- captures/   → ملفات pcap
- scripts/    → سكريبتات مخصصة
- notes/      → ملاحظات ومعلومات
README

ok "تم إنشاء هيكل المجلدات في ~/ops/"

# ============================================================
# 10. تحميل Wordlists
# ============================================================
step "تحميل Wordlists (SecLists)..."

if [ ! -d ~/ops/wordlists/SecLists ]; then
  git clone --depth 1 https://github.com/danielmiessler/SecLists.git ~/ops/wordlists/SecLists
  ok "تم تحميل SecLists"
else
  warn "SecLists موجود بالفعل"
fi

# رابط rockyou.txt إن لم يكن موجوداً
if [ ! -f /usr/share/wordlists/rockyou.txt ]; then
  sudo apt install -y wordlists
  sudo gunzip /usr/share/wordlists/rockyou.txt.gz 2>/dev/null || true
  ok "rockyou.txt متاح"
fi

# ============================================================
# 11. Aliases احترافية
# ============================================================
step "إضافة Aliases لغرفة العمليات..."

cat >> ~/.bashrc << 'ALIASES'

# ══════════════════════════════════════════
# ⚔️ CYBER OPS ALIASES — asrar-mared
# ══════════════════════════════════════════

# Navigation
alias ops='cd ~/ops'
alias proj='cd ~/ops/projects'

# Nmap Quick Scans
alias nmap-quick='nmap -sV -sC -O'
alias nmap-full='nmap -sV -sC -O -p- -T4'
alias nmap-vuln='nmap --script vuln'
alias nmap-stealth='nmap -sS -T2'
alias nmap-udp='sudo nmap -sU -T4'

# Network
alias myip='curl -s ifconfig.me && echo'
alias localip="ip addr show | grep 'inet ' | awk '{print \$2}'"
alias ports='ss -tulpn'
alias netwatch='sudo nethogs'
alias trafficwatch='sudo iftop -n'

# Wireshark / tcpdump
alias cap='sudo tcpdump -i any -w ~/ops/captures/cap-$(date +%Y%m%d-%H%M%S).pcap'

# Firewall
alias fwstatus='sudo ufw status verbose'
alias fw-block='sudo ufw deny'
alias fw-allow='sudo ufw allow'
alias f2b-status='sudo fail2ban-client status'

# Hydra shortcuts
alias hydra-ssh='hydra -L users.txt -P ~/ops/wordlists/SecLists/Passwords/rockyou.txt ssh'
alias hydra-http='hydra -L users.txt -P ~/ops/wordlists/SecLists/Passwords/rockyou.txt http-get'

# Gobuster
alias bust-dir='gobuster dir -u'
alias bust-dns='gobuster dns -d'

# System
alias syslog='sudo tail -f /var/log/syslog'
alias authlog='sudo tail -f /var/log/auth.log'
alias resources='htop'
alias diskspace='df -h && du -sh ~/*'

# Git shortcuts
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all'
alias gpull='git pull'

# Gitea remote helper
alias gitea-push='git push gitea main'
alias gitea-clone='git clone git@gitea.com:asrar-mared/'

# Python
alias py='python3'
alias server='python3 -m http.server'
alias venv='python3 -m venv .venv && source .venv/bin/activate'

# Docker
alias dk='docker'
alias dkps='docker ps -a'
alias dkimg='docker images'

ALIASES

ok "تم إضافة الـ Aliases"

# ============================================================
# 12. Metasploit Framework (اختياري - ثقيل)
# ============================================================
step "تثبيت Metasploit Framework..."

if ! command -v msfconsole &>/dev/null; then
  curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
  chmod 755 /tmp/msfinstall
  sudo /tmp/msfinstall
  ok "Metasploit مثبت"
else
  warn "Metasploit موجود بالفعل"
fi

# ============================================================
# 13. سكريبت مراقبة الأمن اليومي
# ============================================================
step "إنشاء سكريبت المراقبة اليومية..."

cat > ~/ops/scripts/daily_monitor.sh << 'MONITOR'
#!/bin/bash
# ⚔️ Daily Security Monitor — asrar-mared

LOG=~/ops/logs/system/monitor-$(date +%Y%m%d).log

{
  echo "══════════════════════════════════════════"
  echo "  ⚔️ DAILY SECURITY REPORT — $(date)"
  echo "══════════════════════════════════════════"
  
  echo -e "\n📡 [NETWORK CONNECTIONS]"
  ss -tulpn
  
  echo -e "\n🔐 [FAILED LOGINS]"
  sudo grep "Failed password" /var/log/auth.log | tail -20
  
  echo -e "\n🚨 [BLOCKED IPs - Fail2ban]"
  sudo fail2ban-client status sshd 2>/dev/null || echo "Fail2ban sshd not active"
  
  echo -e "\n💻 [RUNNING PROCESSES - Suspicious]"
  ps aux --sort=-%cpu | head -15
  
  echo -e "\n🔥 [FIREWALL STATUS]"
  sudo ufw status verbose
  
  echo -e "\n📁 [OPEN PORTS]"
  sudo nmap -sS -T4 localhost
  
  echo "══════════════════════════════════════════"
} | tee "$LOG"

echo "تقرير محفوظ في: $LOG"
MONITOR

chmod +x ~/ops/scripts/daily_monitor.sh
ok "سكريبت المراقبة جاهز: ~/ops/scripts/daily_monitor.sh"

# ============================================================
# 14. Cron للمراقبة اليومية
# ============================================================
step "إعداد Cron للمراقبة التلقائية..."
(crontab -l 2>/dev/null; echo "0 8 * * * ~/ops/scripts/daily_monitor.sh") | crontab -
ok "مراقبة يومية مجدولة كل يوم 8 صباحاً"

# ============================================================
# 15. إنشاء مستودع Gitea محلي وربطه
# ============================================================
step "تهيئة مستودع Git الرئيسي..."

cd ~/ops
git init
git add .
git commit -m "⚔️ Initial ops room setup - asrar-mared"

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📋 خطوات ربط Gitea يدوياً:"
echo ""
echo "  1. افتح: https://gitea.com/asrar-mared"
echo "  2. أنشئ مستودع جديد اسمه: ops-room"
echo "  3. أضف SSH Key من الأعلى"
echo "  4. شغّل هذه الأوامر:"
echo ""
echo "     cd ~/ops"
echo "     git remote add origin git@gitea.com:asrar-mared/ops-room.git"
echo "     git push -u origin main"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# ============================================================
# FINAL SUMMARY
# ============================================================
echo ""
echo -e "${GREEN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║          ✅ غرفة العمليات جاهزة — asrar-mared                  ║"
echo "╠══════════════════════════════════════════════════════════════════╣"
echo "║  🔹 الأدوات: nmap, wireshark, hydra, nikto, sqlmap, gobuster   ║"
echo "║  🔹 Python + scapy + pwntools + impacket                        ║"
echo "║  🔹 Node.js 20 + npm                                            ║"
echo "║  🔹 Docker                                                       ║"
echo "║  🔹 Metasploit Framework                                         ║"
echo "║  🔹 UFW + Fail2ban مفعّلين                                      ║"
echo "║  🔹 Aliases احترافية في ~/.bashrc                               ║"
echo "║  🔹 مجلدات غرفة العمليات في ~/ops/                             ║"
echo "║  🔹 SecLists wordlists                                           ║"
echo "║  🔹 مراقبة يومية تلقائية 8 صباحاً                              ║"
echo "╠══════════════════════════════════════════════════════════════════╣"
echo "║  ⚠️  شغّل: source ~/.bashrc  لتفعيل الـ Aliases                 ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

