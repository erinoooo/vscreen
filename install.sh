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

# ── Root check ────────────────────────────────────────────────────────────────
[[ $EUID -eq 0 ]] || die "Run with sudo:  curl -fsSL ${RAW}/install.sh | sudo bash"

# ── OS check (warn, never die) ───────────────────────────────────────────────
if ! grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
    warn "Not Ubuntu — vscreen is tested on 22.04/24.04. Continuing anyway."
fi

# ── Dependencies ──────────────────────────────────────────────────────────────
if ! command -v curl &>/dev/null; then
    info "Installing curl..."
    apt-get install -y -qq curl 2>/dev/null || die "Failed to install curl"
fi

# ── Download vscreen ──────────────────────────────────────────────────────────
info "Downloading vscreen..."
if ! curl -fsSL "${RAW}/vscreen" -o "$BIN"; then
    die "Failed to download vscreen. Check your internet connection."
fi
chmod +x "$BIN"
success "Downloaded to ${BIN}"

# ── Run install ───────────────────────────────────────────────────────────────
echo ""
vscreen install

echo ""
echo -e "${GREEN}${BOLD}Ready.${RESET}"
echo ""
echo -e "  ${CYAN}sudo vscreen start${RESET}"
echo ""
