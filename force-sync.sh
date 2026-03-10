#!/bin/bash

#############################################
#                                           #
#     FORCE SYNC - Git Professional        #
#     دمج قوي واحترافي                     #
#                                           #
#  Developer: nike4565                      #
#  Purpose: Sync with upstream main         #
#                                           #
#############################################

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
REMOTE="origin"
MAIN_BRANCH="main"
BACKUP_BRANCH="backup-$(date +%Y%m%d-%H%M%S)"

# Banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
╔══════════════════════════════════════════════════╗
║                                                  ║
║          FORCE SYNC - Git Professional          ║
║             دمج قوي واحترافي                    ║
║                                                  ║
║  Developer: nike4565                             ║
║  Project: Zayed Shield                           ║
║                                                  ║
╚══════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

# Check if in git repo
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}[ERROR] Not a git repository${NC}"
        exit 1
    fi
    echo -e "${GREEN}[✓] Git repository detected${NC}"
}

# Show current status
show_status() {
    echo -e "\n${CYAN}${BOLD}Current Status:${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Current branch
    local current_branch=$(git branch --show-current)
    echo -e "${CYAN}Current Branch:${NC} $current_branch"
    
    # Fetch latest info
    echo -e "\n${YELLOW}[*] Fetching latest information...${NC}"
    git fetch $REMOTE --quiet
    
    # Check ahead/behind
    local ahead=$(git rev-list --count ${REMOTE}/${MAIN_BRANCH}..HEAD 2>/dev/null || echo "0")
    local behind=$(git rev-list --count HEAD..${REMOTE}/${MAIN_BRANCH} 2>/dev/null || echo "0")
    
    echo -e "${GREEN}Ahead:${NC}  $ahead commits"
    echo -e "${RED}Behind:${NC} $behind commits"
    
    # Uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}[!] You have uncommitted changes${NC}"
        git status --short
    fi
    
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    export BEHIND_COUNT=$behind
    export AHEAD_COUNT=$ahead
}

# Create backup
create_backup() {
    echo -e "${YELLOW}[*] Creating backup branch: $BACKUP_BRANCH${NC}"
    git branch $BACKUP_BRANCH
    echo -e "${GREEN}[✓] Backup created${NC}"
}

# Save current work
save_current_work() {
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}[*] Saving uncommitted changes...${NC}"
        git add .
        git commit -m "WIP: Auto-save before force sync - $(date)" || true
        echo -e "${GREEN}[✓] Changes saved${NC}"
    else
        echo -e "${GREEN}[✓] No uncommitted changes${NC}"
    fi
}

# Strategy 1: Hard Reset (Nuclear Option)
strategy_hard_reset() {
    echo -e "\n${RED}${BOLD}Strategy: HARD RESET${NC}"
    echo -e "${RED}Warning: This will discard ALL local changes!${NC}"
    echo -e "${YELLOW}Your work is backed up in: $BACKUP_BRANCH${NC}\n"
    
    read -p "Continue? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        echo -e "${YELLOW}[!] Aborted${NC}"
        exit 0
    fi
    
    echo -e "\n${YELLOW}[*] Performing hard reset...${NC}"
    git reset --hard ${REMOTE}/${MAIN_BRANCH}
    
    echo -e "${GREEN}[✓] Reset completed${NC}"
    echo -e "${YELLOW}[*] Force pushing...${NC}"
    git push ${REMOTE} ${MAIN_BRANCH} --force
    
    echo -e "${GREEN}${BOLD}[✓] SYNC COMPLETE!${NC}"
}

# Strategy 2: Merge (Preserves history)
strategy_merge() {
    echo -e "\n${BLUE}${BOLD}Strategy: MERGE${NC}"
    echo -e "${BLUE}This will preserve your local changes${NC}\n"
    
    echo -e "${YELLOW}[*] Merging ${REMOTE}/${MAIN_BRANCH}...${NC}"
    
    if git merge ${REMOTE}/${MAIN_BRANCH} --no-ff -m "Merge: Sync $BEHIND_COUNT commits from upstream"; then
        echo -e "${GREEN}[✓] Merge successful (no conflicts)${NC}"
    else
        echo -e "${RED}[!] Merge conflicts detected${NC}"
        echo -e "${YELLOW}[*] Conflicts in:${NC}"
        git diff --name-only --diff-filter=U
        
        echo -e "\n${CYAN}Resolve conflicts then run:${NC}"
        echo -e "  git add ."
        echo -e "  git commit -m 'Resolve merge conflicts'"
        echo -e "  git push ${REMOTE} ${MAIN_BRANCH} --force"
        exit 1
    fi
    
    echo -e "${YELLOW}[*] Pushing changes...${NC}"
    git push ${REMOTE} ${MAIN_BRANCH} --force
    
    echo -e "${GREEN}${BOLD}[✓] SYNC COMPLETE!${NC}"
}

# Strategy 3: Rebase (Clean history)
strategy_rebase() {
    echo -e "\n${PURPLE}${BOLD}Strategy: REBASE${NC}"
    echo -e "${PURPLE}This will rewrite history cleanly${NC}\n"
    
    echo -e "${YELLOW}[*] Rebasing onto ${REMOTE}/${MAIN_BRANCH}...${NC}"
    
    if git rebase ${REMOTE}/${MAIN_BRANCH}; then
        echo -e "${GREEN}[✓] Rebase successful${NC}"
    else
        echo -e "${RED}[!] Rebase conflicts detected${NC}"
        echo -e "\n${CYAN}Resolve conflicts then run:${NC}"
        echo -e "  git add ."
        echo -e "  git rebase --continue"
        echo -e "  git push ${REMOTE} ${MAIN_BRANCH} --force"
        exit 1
    fi
    
    echo -e "${YELLOW}[*] Force pushing...${NC}"
    git push ${REMOTE} ${MAIN_BRANCH} --force
    
    echo -e "${GREEN}${BOLD}[✓] SYNC COMPLETE!${NC}"
}

# Strategy 4: Cherry-pick (Selective)
strategy_selective() {
    echo -e "\n${CYAN}${BOLD}Strategy: SELECTIVE SYNC${NC}"
    echo -e "${CYAN}Keep your commits, pull upstream changes${NC}\n"
    
    # Get list of your commits
    echo -e "${YELLOW}[*] Your recent commits:${NC}"
    git log --oneline ${REMOTE}/${MAIN_BRANCH}..HEAD | head -10
    
    # Checkout main, pull, then cherry-pick your commits
    echo -e "\n${YELLOW}[*] Syncing with upstream...${NC}"
    
    local current_branch=$(git branch --show-current)
    local temp_branch="temp-sync-$$"
    
    # Create temp branch with your commits
    git branch $temp_branch
    
    # Reset to upstream
    git reset --hard ${REMOTE}/${MAIN_BRANCH}
    
    # Cherry-pick your commits
    echo -e "${YELLOW}[*] Applying your commits...${NC}"
    git cherry-pick ${REMOTE}/${MAIN_BRANCH}..$temp_branch || {
        echo -e "${RED}[!] Conflicts during cherry-pick${NC}"
        echo -e "${CYAN}Resolve and continue:${NC}"
        echo -e "  git add ."
        echo -e "  git cherry-pick --continue"
        exit 1
    }
    
    # Cleanup
    git branch -D $temp_branch
    
    echo -e "${YELLOW}[*] Pushing...${NC}"
    git push ${REMOTE} ${MAIN_BRANCH} --force
    
    echo -e "${GREEN}${BOLD}[✓] SYNC COMPLETE!${NC}"
}

# Main menu
main_menu() {
    show_banner
    check_git_repo
    show_status
    
    echo -e "${CYAN}${BOLD}Select Sync Strategy:${NC}\n"
    
    echo -e "${RED}1)${NC} Hard Reset     ${RED}(Nuclear - Discard everything)${NC}"
    echo -e "${BLUE}2)${NC} Merge          ${BLUE}(Safe - Preserve changes)${NC}"
    echo -e "${PURPLE}3)${NC} Rebase         ${PURPLE}(Clean - Rewrite history)${NC}"
    echo -e "${CYAN}4)${NC} Selective      ${CYAN}(Smart - Keep your commits)${NC}"
    echo -e "${GREEN}5)${NC} Show Diff      ${GREEN}(View changes first)${NC}"
    echo -e "${YELLOW}6)${NC} Backup Only    ${YELLOW}(Just create backup)${NC}"
    echo -e "${WHITE}0)${NC} Exit"
    
    echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -ne "${BOLD}Choose [0-6]: ${NC}"
    read -r choice
    
    # Create backup first (except for options 5, 6, 0)
    if [[ "$choice" =~ ^[1-4]$ ]]; then
        create_backup
        save_current_work
    fi
    
    case "$choice" in
        1)
            strategy_hard_reset
            ;;
        2)
            strategy_merge
            ;;
        3)
            strategy_rebase
            ;;
        4)
            strategy_selective
            ;;
        5)
            echo -e "\n${CYAN}Showing differences:${NC}\n"
            git log --oneline ${REMOTE}/${MAIN_BRANCH}..HEAD
            echo -e "\n${YELLOW}Press Enter to continue...${NC}"
            read
            main_menu
            ;;
        6)
            create_backup
            echo -e "${GREEN}[✓] Backup created: $BACKUP_BRANCH${NC}"
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            sleep 2
            main_menu
            ;;
    esac
}

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}[*] Cleaning up...${NC}"
    
    # Remove old backup branches (keep last 5)
    git branch | grep "backup-" | sort -r | tail -n +6 | xargs -r git branch -D 2>/dev/null || true
    
    echo -e "${GREEN}[✓] Cleanup complete${NC}"
}

# Final summary
show_summary() {
    echo -e "\n${CYAN}${BOLD}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}           SYNC SUMMARY                 ${NC}"
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════${NC}\n"
    
    local current_branch=$(git branch --show-current)
    local latest_commit=$(git log -1 --oneline)
    
    echo -e "${GREEN}Current Branch:${NC} $current_branch"
    echo -e "${GREEN}Latest Commit:${NC}  $latest_commit"
    echo -e "${GREEN}Backup Branch:${NC}  $BACKUP_BRANCH"
    
    echo -e "\n${CYAN}Verify at:${NC}"
    echo -e "  https://github.com/nike4565/Zayed-Shield"
    
    echo -e "\n${YELLOW}To restore backup if needed:${NC}"
    echo -e "  git reset --hard $BACKUP_BRANCH"
    
    echo -e "\n${GREEN}${BOLD}✓ All operations completed successfully!${NC}\n"
}

# Error handler
error_handler() {
    echo -e "\n${RED}${BOLD}[ERROR] Operation failed!${NC}"
    echo -e "${YELLOW}Your backup is safe at: $BACKUP_BRANCH${NC}"
    echo -e "${CYAN}To restore:${NC}"
    echo -e "  git reset --hard $BACKUP_BRANCH"
    exit 1
}

trap error_handler ERR

# Main execution
main() {
    main_menu
    cleanup
    show_summary
}

# Run
main
