#!/bin/bash

# =============================================================================
# 👑 PHARAOH'S CURSE - ULTIMATE BRANCH MERGER 👑
# The Ancient Egyptian Power of Merging All Branches
# =============================================================================
# Author: Pharaoh's Engineer
# Version: 1.0.0
# License: MIT
# Description: Merges ALL branches with the power of ancient Egypt 🇪🇬
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GOLD='\033[38;5;220m'
NC='\033[0m'

# Configuration
SCRIPT_VERSION="1.0.0"
SCRIPT_NAME="Pharaoh's Curse"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
REPORT_FILE="pharaoh_merge_report_$(date +%Y%m%d_%H%M%S).md"

# =============================================================================
# PHARAOH'S ASCII ART
# =============================================================================

display_pharaoh_header() {
    clear
    echo -e "${GOLD}"
    cat << 'PHARAOH'
    ╔════════════════════════════════════════════════════════════════╗
    ║                                                                ║
    ║         👑  PHARAOH'S CURSE - BRANCH MERGER  👑                ║
    ║                                                                ║
    ║              ⚱️  Ancient Egyptian Power  ⚱️                    ║
    ║                                                                ║
    ╚════════════════════════════════════════════════════════════════╝

                            _______
                        ---'   ____)____
                              (________)
                              (________)
                             (_________)
                        ---.__________)
                    
            👑 THE CURSE IS AWAKENED 👑
                 🇪🇬 MADE IN EGYPT 🇪🇬

PHARAOH
    echo -e "${NC}"
}

display_egyptian_flag() {
    echo -e "${NC}"
    echo "    ╔════════════════════════════════════════════════════╗"
    echo -e "    ║ ${RED}████████████████████████████████████████████${NC}   ║"
    echo -e "    ║ ${RED}████████████████████████████████████████████${NC}   ║"
    echo -e "    ║ ${WHITE}████████████████████████████████████████████${NC}   ║"
    echo -e "    ║ ${WHITE}████████████████████████████████████████████${NC}   ║"
    echo -e "    ║ ${NC}████████████████████████████████████████████   ║"
    echo -e "    ║ ${NC}████████████████████████████████████████████   ║"
    echo "    ╚════════════════════════════════════════════════════╝"
    echo -e "${GOLD}              🇪🇬 EGYPTIAN ENGINEERING 🇪🇬${NC}"
    echo ""
}

pharaoh_salute() {
    echo -e "${GOLD}"
    cat << 'SALUTE'
                    __
               _.-'` `'-._
           _.-'            `'-._
       _.-'    PHARAOH'S       `'-._
     .'         BLESSING           '.
    /            IS UPON             \
   |           THIS MERGE             |
    \          OPERATION             /
     '._      🇪🇬 EGYPT 🇪🇬      _.'
        '-._              _.-'
            '-._      _.-'
                '-.-'
        
        ⚱️ MAY THE GODS GUIDE THIS MERGE ⚱️
SALUTE
    echo -e "${NC}"
}

# =============================================================================
# MAIN FUNCTIONS
# =============================================================================

print_status() {
    echo -e "${CYAN}[⚱️ PHARAOH]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓ SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠ WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗ ERROR]${NC} $1"
}

print_header() {
    echo -e "${GOLD}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║${WHITE} $1${GOLD}${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════════════╝${NC}"
}

# Configure Git
configure_git() {
    print_header "CONFIGURING GIT WITH PHARAOH'S POWER"
    
    read -p "Enter your GitHub username: " GIT_USERNAME
    read -p "Enter your GitHub email: " GIT_EMAIL
    
    git config user.name "${GIT_USERNAME}"
    git config user.email "${GIT_EMAIL}"
    git config --global pull.rebase false
    
    print_success "Git configured for ${GIT_USERNAME}"
    echo ""
}

# Fetch all updates
fetch_updates() {
    print_header "SUMMONING BRANCHES FROM THE DIGITAL REALM"
    
    print_status "Fetching all remote branches..."
    git fetch --all --prune
    git fetch origin
    
    print_success "All branches summoned successfully!"
    echo ""
}

# Display branch statistics
show_branch_stats() {
    print_header "BRANCH INVENTORY - PHARAOH'S DOMAIN"
    
    echo -e "${CYAN}📊 Local Branches:${NC}"
    git branch -v | head -10
    if [ $(git branch | wc -l) -gt 10 ]; then
        echo "... and $(($(git branch | wc -l) - 10)) more"
    fi
    echo ""
    
    echo -e "${CYAN}☁️ Remote Branches:${NC}"
    git branch -r | grep -v HEAD | head -10
    if [ $(git branch -r | grep -v HEAD | wc -l) -gt 10 ]; then
        echo "... and $(($(git branch -r | grep -v HEAD | wc -l) - 10)) more"
    fi
    echo ""
    
    LOCAL_COUNT=$(git branch | wc -l)
    REMOTE_COUNT=$(git branch -r | grep -v HEAD | wc -l)
    TOTAL_COUNT=$((LOCAL_COUNT + REMOTE_COUNT))
    
    echo -e "${GOLD}═══════════════════════════════════════${NC}"
    echo -e "${WHITE}📈 Statistics:${NC}"
    echo -e "  🌿 Local Branches:  ${GREEN}${LOCAL_COUNT}${NC}"
    echo -e "  ☁️  Remote Branches: ${GREEN}${REMOTE_COUNT}${NC}"
    echo -e "  📊 Total Branches:  ${GOLD}${TOTAL_COUNT}${NC}"
    echo -e "${GOLD}═══════════════════════════════════════${NC}"
    echo ""
}

# Merge all branches
merge_all_branches() {
    CURRENT_BRANCH=$(git branch --show-current)
    
    print_header "UNLEASHING PHARAOH'S CURSE - MASS MERGE"
    
    echo -e "${YELLOW}⚠️  WARNING: This will merge ALL remote branches into ${CURRENT_BRANCH}${NC}"
    echo -e "${RED}⚠️  The Pharaoh's Curse cannot be undone easily!${NC}"
    echo ""
    read -p "Type 'CURSE' to proceed: " CONFIRM
    
    if [[ "$CONFIRM" != "CURSE" ]]; then
        print_error "Merge cancelled - The curse remains dormant"
        exit 1
    fi
    
    echo ""
    pharaoh_salute
    echo ""
    
    # Initialize report
    cat > ${REPORT_FILE} << EOF
# 👑 PHARAOH'S CURSE - MERGE REPORT 👑

## 🇪🇬 Egyptian Branch Merger - Victory Report 🇪🇬

**Executed by:** ${GIT_USERNAME}  
**Date:** ${TIMESTAMP}  
**Script:** ${SCRIPT_NAME} v${SCRIPT_VERSION}  
**Target Branch:** ${CURRENT_BRANCH}  

---

## ⚱️ THE CURSE WAS UNLEASHED

The ancient power of Egyptian engineering was invoked to merge all branches into a unified codebase.

---

## 📊 MERGE OPERATIONS

| Branch | Status | Details |
|--------|--------|---------|
EOF

    # Statistics
    SUCCESS_COUNT=0
    FAILED_COUNT=0
    SKIPPED_COUNT=0
    
    # Get remote branches
    BRANCHES=$(git branch -r | grep -v HEAD | sed 's/origin\///' | sed 's/^ *//')
    TOTAL_BRANCHES=$(echo "$BRANCHES" | wc -l)
    CURRENT_NUM=0
    
    echo -e "${GOLD}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║          PHARAOH'S MERGE PROCESS INITIATED            ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    for BRANCH in $BRANCHES; do
        CURRENT_NUM=$((CURRENT_NUM + 1))
        
        # Skip current branch
        if [[ "$BRANCH" == "$CURRENT_BRANCH" ]]; then
            print_warning "Skipping current branch: ${BRANCH}"
            SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
            echo "| ${BRANCH} | ⏭️ SKIPPED | Current branch |" >> ${REPORT_FILE}
            continue
        fi
        
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}🔄 [${CURRENT_NUM}/${TOTAL_BRANCHES}] Processing:${NC} ${GREEN}${BRANCH}${NC}"
        
        # Attempt merge
        if git merge origin/${BRANCH} --no-edit -m "👑 Pharaoh's Curse: Merge ${BRANCH} - Egyptian Power 🇪🇬" &>/dev/null; then
            print_success "Merged: ${BRANCH}"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            echo "| ${BRANCH} | ✅ SUCCESS | Merged successfully |" >> ${REPORT_FILE}
        else
            print_error "Failed: ${BRANCH}"
            FAILED_COUNT=$((FAILED_COUNT + 1))
            echo "| ${BRANCH} | ❌ FAILED | Merge conflict |" >> ${REPORT_FILE}
            git merge --abort 2>/dev/null || true
        fi
        
        # Progress bar
        PERCENT=$((CURRENT_NUM * 100 / TOTAL_BRANCHES))
        echo -ne "${YELLOW}Progress: [${PERCENT}%] ${NC}\r"
        
        sleep 0.5
    done
    
    echo ""
    echo ""
}

# Generate final report
generate_report() {
    print_header "GENERATING PHARAOH'S VICTORY REPORT"
    
    cat >> ${REPORT_FILE} << EOF

---

## 🏆 FINAL STATISTICS

| Metric | Count | Status |
|--------|-------|--------|
| ✅ **Successful Merges** | ${SUCCESS_COUNT} | 🎉 VICTORY |
| ❌ **Failed Merges** | ${FAILED_COUNT} | 🔧 REVIEW |
| ⏭️ **Skipped Branches** | ${SKIPPED_COUNT} | ℹ️ INFO |
| 📊 **Total Processed** | $((SUCCESS_COUNT + FAILED_COUNT + SKIPPED_COUNT)) | ✓ COMPLETE |

---

## 🎯 MERGE SUCCESS RATE

**Success Rate:** $(( SUCCESS_COUNT * 100 / (SUCCESS_COUNT + FAILED_COUNT + 1) ))%

\`\`\`
╔════════════════════════════════════════════════════╗
║                                                    ║
║     👑 PHARAOH'S CURSE EXECUTED SUCCESSFULLY 👑    ║
║                                                    ║
║           🇪🇬 MADE WITH EGYPTIAN POWER 🇪🇬         ║
║                                                    ║
╚════════════════════════════════════════════════════╝
\`\`\`

---

## 📝 COMMIT SUMMARY

\`\`\`
$(git log --oneline -10)
\`\`\`

---

## 🌟 IMPACT ASSESSMENT

### Before Merge:
- ❌ Scattered branches across repository
- ❌ Fragmented codebase
- ❌ Difficult maintenance

### After Merge:
- ✅ Unified codebase
- ✅ Centralized updates
- ✅ Improved maintainability
- ✅ **${SUCCESS_COUNT} branches** successfully integrated!

---

## 👥 ACKNOWLEDGMENTS

This massive merge operation was powered by:
- 🇪🇬 **Egyptian Engineering Excellence**
- 👑 **Pharaoh's Ancient Wisdom**
- ⚱️ **The Blessing of the Gods**
- 💪 **Community Collaboration**

---

## 🚀 NEXT STEPS

1. Review any failed merges
2. Test integrated codebase
3. Push changes to remote
4. Celebrate the victory! 🎉

---

<div align="center">

## 👑 PHARAOH'S CURSE - MISSION ACCOMPLISHED 👑

**The ancient power has been unleashed!**  
**All branches bow before the Pharaoh!**  

**🇪🇬 EGYPT 🇪🇬**

*Generated by Pharaoh's Curse v${SCRIPT_VERSION}*  
*${TIMESTAMP}*

</div>

---

## 📊 DETAILED STATISTICS

\`\`\`
Total Branches Analyzed: ${TOTAL_BRANCHES}
Successfully Merged:     ${SUCCESS_COUNT}
Failed Merges:           ${FAILED_COUNT}
Skipped:                 ${SKIPPED_COUNT}

Execution Time:          $(date)
Git User:                ${GIT_USERNAME}
Target Branch:           ${CURRENT_BRANCH}
\`\`\`

---

**⚱️ The Pharaoh's work is done. The curse is fulfilled. ⚱️**
EOF

    print_success "Report generated: ${REPORT_FILE}"
    echo ""
}

# Display final summary
show_final_summary() {
    print_header "PHARAOH'S FINAL DECREE"
    
    echo -e "${GOLD}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║               MERGE OPERATION COMPLETE                ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}✅ Successful Merges: ${SUCCESS_COUNT}${NC}"
    echo -e "${RED}❌ Failed Merges:     ${FAILED_COUNT}${NC}"
    echo -e "${YELLOW}⏭️  Skipped Branches:  ${SKIPPED_COUNT}${NC}"
    echo -e "${CYAN}📊 Total Processed:   $((SUCCESS_COUNT + FAILED_COUNT + SKIPPED_COUNT))${NC}"
    echo ""
    
    CURRENT_BRANCH=$(git branch --show-current)
    echo -e "${CYAN}📋 Current Branch Status:${NC}"
    git status --short
    echo ""
    
    echo -e "${YELLOW}🚀 Push changes to GitHub?${NC}"
    read -p "Type 'PUSH' to upload: " PUSH_CONFIRM
    
    if [[ "$PUSH_CONFIRM" == "PUSH" ]]; then
        echo ""
        print_status "Pushing to origin/${CURRENT_BRANCH}..."
        
        if git push origin ${CURRENT_BRANCH}; then
            print_success "Changes pushed successfully!"
        else
            print_error "Push failed - manual intervention required"
        fi
    else
        print_warning "Changes not pushed - remember to push manually"
    fi
    
    echo ""
}

# Display exit message
display_exit_message() {
    echo ""
    display_egyptian_flag
    echo ""
    echo -e "${GOLD}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║                                                        ║${NC}"
    echo -e "${WHITE}║     👑 THE PHARAOH'S CURSE HAS BEEN FULFILLED 👑       ║${NC}"
    echo -e "${WHITE}║                                                        ║${NC}"
    echo -e "${WHITE}║          ⚱️  ALL BRANCHES UNIFIED  ⚱️                  ║${NC}"
    echo -e "${WHITE}║                                                        ║${NC}"
    echo -e "${WHITE}║            🇪🇬 EGYPTIAN VICTORY 🇪🇬                    ║${NC}"
    echo -e "${WHITE}║                                                        ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📄 Full report saved: ${GREEN}${REPORT_FILE}${NC}"
    echo -e "${CYAN}📜 Recent commits:${NC}"
    git log --oneline --graph --decorate -5
    echo ""
    echo -e "${GOLD}⚱️ May the blessings of Ra be upon your code ⚱️${NC}"
    echo ""
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    display_pharaoh_header
    display_egyptian_flag
    
    echo -e "${WHITE}Welcome to Pharaoh's Curse - The Ultimate Branch Merger${NC}"
    echo -e "${CYAN}Version: ${SCRIPT_VERSION}${NC}"
    echo -e "${CYAN}Powered by: Ancient Egyptian Engineering 🇪🇬${NC}"
    echo ""
    
    configure_git
    fetch_updates
    show_branch_stats
    merge_all_branches
    generate_report
    show_final_summary
    display_exit_message
    
    print_success "Pharaoh's Curse executed successfully!"
    echo -e "${GOLD}👑 Long live the Pharaoh! 👑${NC}"
    echo ""
}

# Run the script
main "$@"
