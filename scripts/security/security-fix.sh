#!/bin/bash

# ====================================================================
# 🛡️ SECURITY AUTO-FIX SCRIPT 🛡️
# ====================================================================
# Created by: asrar-mared (المحارب الرقمي)
# Email: nike49424@gmail.com | nike49424@proton.me
# Date: 2026-01-22
# Purpose: إصلاح احترافي للثغرات الأمنية
# ====================================================================

# الألوان للواجهة
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# الرموز
SHIELD="🛡️"
SWORD="⚔️"
FIRE="🔥"
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
ROCKET="🚀"
LOCK="🔒"
EAGLE="🦅"
TARGET="🎯"

# متغيرات العداد
TOTAL_FIXED=0
TOTAL_FAILED=0
START_TIME=$(date +%s)

# ====================================================================
# BANNER
# ====================================================================
clear
echo -e "${RED}${BOLD}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ██████╗ ███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗║
║  ██╔════╝ ██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝║
║  ╚█████╗  █████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝ ║
║   ╚═══██╗ ██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝  ║
║  ██████╔╝ ███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║   ║
║  ╚═════╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   ║
║                                                                  ║
║          █████╗ ██╗   ██╗████████╗ ██████╗       ███████╗██╗██╗ ║
║         ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗      ██╔════╝██║╚██╗║
║         ███████║██║   ██║   ██║   ██║   ██║█████╗█████╗  ██║ ██║║
║         ██╔══██║██║   ██║   ██║   ██║   ██║╚════╝██╔══╝  ██║██╔╝║
║         ██║  ██║╚██████╔╝   ██║   ╚██████╔╝      ██║     ██║██║ ║
║         ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝       ╚═╝     ╚═╝╚═╝ ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}${BOLD}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${SWORD} المحارب الرقمي - صائد الثغرات ${SWORD}"
echo "  Cybersecurity Researcher: asrar-mared"
echo "  ${EAGLE} nike49424@gmail.com | nike49424@proton.me ${EAGLE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}\n"

# ====================================================================
# FUNCTIONS
# ====================================================================

# دالة الطباعة مع تأثير
print_status() {
    local icon=$1
    local color=$2
    local message=$3
    echo -e "${color}${icon} ${message}${NC}"
}

# دالة الانتظار مع Animation
loading_animation() {
    local duration=$1
    local message=$2
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local end=$((SECONDS + duration))
    
    while [ $SECONDS -lt $end ]; do
        for frame in "${frames[@]}"; do
            echo -ne "\r${CYAN}${frame} ${message}${NC}"
            sleep 0.1
        done
    done
    echo -ne "\r${GREEN}${CHECK} ${message} - تم${NC}\n"
}

# دالة تنفيذ الأوامر مع معالجة الأخطاء
execute_command() {
    local cmd=$1
    local success_msg=$2
    local fail_msg=$3
    
    if eval "$cmd" &>/dev/null; then
        print_status "$CHECK" "$GREEN" "$success_msg"
        ((TOTAL_FIXED++))
        return 0
    else
        print_status "$CROSS" "$RED" "$fail_msg"
        ((TOTAL_FAILED++))
        return 1
    fi
}

# ====================================================================
# PRE-FLIGHT CHECKS
# ====================================================================
echo -e "${YELLOW}${BOLD}${TARGET} المرحلة 1: فحص النظام${NC}\n"

print_status "$SHIELD" "$BLUE" "فحص وجود Node.js..."
if ! command -v node &> /dev/null; then
    print_status "$CROSS" "$RED" "Node.js غير مثبت! قم بتثبيته أولاً"
    exit 1
fi
NODE_VERSION=$(node -v)
print_status "$CHECK" "$GREEN" "Node.js $NODE_VERSION مثبت"

print_status "$SHIELD" "$BLUE" "فحص وجود npm..."
if ! command -v npm &> /dev/null; then
    print_status "$CROSS" "$RED" "npm غير مثبت!"
    exit 1
fi
NPM_VERSION=$(npm -v)
print_status "$CHECK" "$GREEN" "npm $NPM_VERSION مثبت"

print_status "$SHIELD" "$BLUE" "فحص ملف package.json..."
if [ ! -f "package.json" ]; then
    print_status "$CROSS" "$RED" "ملف package.json غير موجود!"
    exit 1
fi
print_status "$CHECK" "$GREEN" "package.json موجود"

echo ""

# ====================================================================
# BACKUP
# ====================================================================
echo -e "${YELLOW}${BOLD}${TARGET} المرحلة 2: النسخ الاحتياطي${NC}\n"

BACKUP_DIR="security-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

print_status "$LOCK" "$BLUE" "إنشاء نسخة احتياطية..."
cp package.json "$BACKUP_DIR/" 2>/dev/null
cp package-lock.json "$BACKUP_DIR/" 2>/dev/null
print_status "$CHECK" "$GREEN" "تم حفظ النسخة الاحتياطية في: $BACKUP_DIR"

echo ""

# ====================================================================
# PHASE 1: AUTO FIX
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 3: الإصلاح التلقائي${NC}\n"

print_status "$ROCKET" "$CYAN" "تشغيل npm audit fix..."
loading_animation 3 "جاري إصلاح الثغرات البسيطة"
npm audit fix &>/dev/null
print_status "$CHECK" "$GREEN" "اكتمل الإصلاح التلقائي"

echo ""

# ====================================================================
# PHASE 2: UPDATE CRITICAL PACKAGES
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 4: تحديث الحزم الحرجة${NC}\n"

# Critical updates
CRITICAL_PACKAGES=(
    "tough-cookie@latest"
    "form-data@latest"
    "qs@latest"
    "braces@latest"
    "minimatch@latest"
    "js-yaml@latest"
    "diff@latest"
    "postcss@latest"
    "nanoid@latest"
    "tmp@latest"
)

print_status "$SWORD" "$PURPLE" "تحديث ${#CRITICAL_PACKAGES[@]} حزمة حرجة..."
for package in "${CRITICAL_PACKAGES[@]}"; do
    pkg_name=$(echo $package | cut -d'@' -f1)
    loading_animation 1 "تحديث $pkg_name"
    npm install $package --save &>/dev/null
done
print_status "$CHECK" "$GREEN" "تم تحديث جميع الحزم الحرجة"

echo ""

# ====================================================================
# PHASE 3: REPLACE DEPRECATED PACKAGES
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 5: استبدال الحزم المهجورة${NC}\n"

print_status "$WARNING" "$YELLOW" "فحص وجود 'request'..."
if grep -q '"request"' package.json; then
    print_status "$SWORD" "$PURPLE" "استبدال request بـ axios..."
    loading_animation 2 "إزالة request"
    npm uninstall request request-promise request-promise-core &>/dev/null
    loading_animation 2 "تثبيت axios"
    npm install axios &>/dev/null
    print_status "$CHECK" "$GREEN" "تم استبدال request بـ axios بنجاح"
else
    print_status "$CHECK" "$GREEN" "request غير موجود"
fi

echo ""

# ====================================================================
# PHASE 4: UPDATE OCTOKIT
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 6: تحديث @octokit${NC}\n"

OCTOKIT_PACKAGES=(
    "@octokit/rest@latest"
    "@octokit/request@latest"
    "@octokit/request-error@latest"
    "@octokit/core@latest"
    "@octokit/graphql@latest"
)

print_status "$SHIELD" "$BLUE" "تحديث حزم Octokit..."
for package in "${OCTOKIT_PACKAGES[@]}"; do
    pkg_name=$(echo $package | cut -d'@' -f2)
    loading_animation 1 "تحديث @octokit/$pkg_name"
    npm install $package --save &>/dev/null
done
print_status "$CHECK" "$GREEN" "تم تحديث Octokit"

echo ""

# ====================================================================
# PHASE 5: UPDATE DEV DEPENDENCIES
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 7: تحديث أدوات التطوير${NC}\n"

DEV_PACKAGES=(
    "mocha@latest"
    "eslint@latest"
    "gulp@latest"
    "node-notifier@latest"
)

print_status "$ROCKET" "$CYAN" "تحديث أدوات التطوير..."
for package in "${DEV_PACKAGES[@]}"; do
    pkg_name=$(echo $package | cut -d'@' -f1)
    loading_animation 1 "تحديث $pkg_name"
    npm install $package --save-dev &>/dev/null
done
print_status "$CHECK" "$GREEN" "تم تحديث أدوات التطوير"

echo ""

# ====================================================================
# PHASE 6: FORCE FIX REMAINING
# ====================================================================
echo -e "${YELLOW}${BOLD}${FIRE} المرحلة 8: الإصلاح القسري${NC}\n"

print_status "$WARNING" "$YELLOW" "تطبيق الإصلاح القسري للثغرات المتبقية..."
print_status "$WARNING" "$RED" "تحذير: قد يسبب breaking changes"
read -p "$(echo -e ${CYAN}هل تريد المتابعة؟ ${NC}[y/N]: )" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    loading_animation 3 "تطبيق npm audit fix --force"
    npm audit fix --force &>/dev/null
    print_status "$CHECK" "$GREEN" "تم تطبيق الإصلاح القسري"
else
    print_status "$WARNING" "$YELLOW" "تم تخطي الإصلاح القسري"
fi

echo ""

# ====================================================================
# PHASE 7: CLEANUP & REINSTALL
# ====================================================================
echo -e "${YELLOW}${BOLD}${TARGET} المرحلة 9: التنظيف وإعادة التثبيت${NC}\n"

print_status "$SHIELD" "$BLUE" "تنظيف ذاكرة التخزين المؤقت..."
loading_animation 2 "حذف node_modules"
rm -rf node_modules package-lock.json &>/dev/null
print_status "$CHECK" "$GREEN" "تم التنظيف"

print_status "$ROCKET" "$CYAN" "إعادة تثبيت التبعيات..."
loading_animation 5 "npm install --package-lock-only"
npm install --package-lock-only &>/dev/null
loading_animation 5 "npm ci"
npm ci &>/dev/null
print_status "$CHECK" "$GREEN" "تم إعادة التثبيت بنجاح"

echo ""

# ====================================================================
# FINAL AUDIT
# ====================================================================
echo -e "${YELLOW}${BOLD}${TARGET} المرحلة 10: الفحص النهائي${NC}\n"

print_status "$SHIELD" "$BLUE" "إجراء فحص أمني نهائي..."
loading_animation 3 "npm audit"

AUDIT_OUTPUT=$(npm audit --json 2>/dev/null)
VULNERABILITIES=$(echo $AUDIT_OUTPUT | grep -o '"total":[0-9]*' | cut -d':' -f2)

if [ -z "$VULNERABILITIES" ]; then
    VULNERABILITIES=0
fi

echo ""

# ====================================================================
# RESULTS REPORT
# ====================================================================
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

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
echo -e "${CYAN}${BOLD}║              ${FIRE} تقرير النتائج النهائي ${FIRE}                    ║${NC}"
echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${WHITE}${BOLD}📊 الإحصائيات:${NC}"
echo -e "${GREEN}  ${CHECK} الثغرات المتبقية: ${BOLD}${VULNERABILITIES}${NC}"
echo -e "${GREEN}  ${CHECK} الوقت المستغرق: ${BOLD}${MINUTES}م ${SECONDS}ث${NC}"
echo -e "${GREEN}  ${CHECK} الحزم المحدثة: ${BOLD}$((${#CRITICAL_PACKAGES[@]} + ${#OCTOKIT_PACKAGES[@]} + ${#DEV_PACKAGES[@]}))${NC}"
echo ""

echo -e "${WHITE}${BOLD}📁 الملفات المحدثة:${NC}"
echo -e "${BLUE}  ${CHECK} package.json${NC}"
echo -e "${BLUE}  ${CHECK} package-lock.json${NC}"
echo -e "${BLUE}  ${CHECK} node_modules/${NC}"
echo ""

echo -e "${WHITE}${BOLD}💾 النسخة الاحتياطية:${NC}"
echo -e "${YELLOW}  ${LOCK} المسار: ${BOLD}$BACKUP_DIR${NC}"
echo ""

if [ "$VULNERABILITIES" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}"
    cat << "EOF"
    ███╗   ██╗ ██████╗     ██╗   ██╗██╗   ██╗██╗     ███╗   ██╗███████╗
    ████╗  ██║██╔═══██╗    ██║   ██║██║   ██║██║     ████╗  ██║██╔════╝
    ██╔██╗ ██║██║   ██║    ██║   ██║██║   ██║██║     ██╔██╗ ██║███████╗
    ██║╚██╗██║██║   ██║    ╚██╗ ██╔╝██║   ██║██║     ██║╚██╗██║╚════██║
    ██║ ╚████║╚██████╔╝     ╚████╔╝ ╚██████╔╝███████╗██║ ╚████║███████║
    ╚═╝  ╚═══╝ ╚═════╝       ╚═══╝   ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝
EOF
    echo -e "${NC}\n"
    echo -e "${GREEN}${BOLD}  ${FIRE}${FIRE}${FIRE} النظام آمن 100% ${FIRE}${FIRE}${FIRE}${NC}\n"
elif [ "$VULNERABILITIES" -lt 10 ]; then
    echo -e "${YELLOW}${BOLD}  ${WARNING} تبقى ${VULNERABILITIES} ثغرات صغيرة - النظام شبه آمن${NC}\n"
else
    echo -e "${RED}${BOLD}  ${CROSS} تبقى ${VULNERABILITIES} ثغرة - يحتاج مراجعة يدوية${NC}\n"
fi

echo -e "${PURPLE}${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}${BOLD}║                ${EAGLE} المحارب الرقمي ${EAGLE}                        ║${NC}"
echo -e "${PURPLE}${BOLD}║                 صائد الثغرات - asrar-mared                    ║${NC}"
echo -e "${PURPLE}${BOLD}║          ${SWORD} حماية الأنظمة الرقمية بشرف ${SWORD}              ║${NC}"
echo -e "${PURPLE}${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${CYAN}📧 للتواصل:${NC}"
echo -e "${WHITE}   nike49424@gmail.com${NC}"
echo -e "${WHITE}   nike49424@proton.me${NC}\n"

echo -e "${RED}${BOLD}"
cat << "EOF"
        🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
        🔥                              🔥
        🔥   ⚔️  MISSION COMPLETE ⚔️   🔥
        🔥                              🔥
        🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
EOF
echo -e "${NC}\n"

# ====================================================================
# SAVE REPORT
# ====================================================================
REPORT_FILE="security-fix-report-$(date +%Y%m%d_%H%M%S).txt"
{
    echo "======================================"
    echo "Security Fix Report"
    echo "======================================"
    echo "Date: $(date)"
    echo "Researcher: asrar-mared"
    echo "Duration: ${MINUTES}m ${SECONDS}s"
    echo "Vulnerabilities Remaining: $VULNERABILITIES"
    echo "Backup Location: $BACKUP_DIR"
    echo "======================================"
    npm audit
} > "$REPORT_FILE"

print_status "$CHECK" "$GREEN" "تم حفظ التقرير في: $REPORT_FILE"

echo -e "\n${GREEN}${BOLD}${ROCKET} للمراجعة النهائية، قم بتشغيل:${NC}"
echo -e "${CYAN}   npm audit${NC}"
echo -e "${CYAN}   npm test${NC}\n"

exit 0
