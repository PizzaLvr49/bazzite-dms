#!/usr/bin/env bash

set -euxo pipefail

DLTOS_DIR="$(dirname "${BASH_SOURCE[0]}")"

# shellcheck disable=SC1091
. "$DLTOS_DIR/cargo-env.sh"

exists() {
	[ $# -ge 1 ] || return 1
	command -v "$1" >/dev/null 2>&1
}

install_language_tools() {
	exists just-lsp || cargo install just-lsp
	exists flamegraph || cargo install flamegraph
}

install_shell_tools() {
	exists ujust || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/ujust
	exists rpm-ostree || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
	exists qs || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/qs
	exists niri || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/niri
	chezmoi init --apply https://github.com/PizzaLvr49/dotfiles.git
}

install_gaming_tools() {
	exists gamescope || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/gamescope
	exists mangohud || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/mangohud
}

install_language_tools &&
	install_shell_tools &&
	install_gaming_tools
