#!/usr/bin/env bash
# vscreen — one-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/erinoooo/vscreen/main/install.sh | sudo bash

set -euo pipefail

REPO="erinoooo/vscreen"
BRANCH="main"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
BIN="/usr/local/bin/vscreen"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "  ${BLUE}→${RESET} $*"; }
success() { echo -e "  ${GREEN}✓${RESET} $*"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET} $*"; }
die()     { echo -e "  ${RED}✗${RESET} $*" >&2; exit 1; }

echo ""
echo -e "${BOLD}vscreen — installer${RESET}"
echo -e "  github.com/${REPO}"
echo ""

[[ $EUID -eq 0 ]] || die "Run with sudo:  curl -fsSL ${RAW}/install.sh | sudo bash"

if ! grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
    warn "Not Ubuntu — vscreen is tested on 22.04/24.04. Continuing anyway."
fi

if ! command -v curl &>/dev/null; then
    info "Installing curl..."
    apt-get install -y -qq curl
fi

info "Downloading vscreen..."
curl -fsSL "${RAW}/vscreen" -o "$BIN"
chmod +x "$BIN"
success "Downloaded to ${BIN}"

echo ""
vscreen install

echo ""
echo -e "${GREEN}${BOLD}Ready.${RESET}"
echo ""
echo -e "  ${CYAN}sudo vscreen start${RESET}"
echo ""
