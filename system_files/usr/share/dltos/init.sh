#!/usr/bin/env bash
set -euxo pipefail
DLTOS_DIR="$(dirname "${BASH_SOURCE[0]}")"
exists() {
	[ $# -ge 1 ] || return 1
	command -v "$1" >/dev/null 2>&1
}
install_language_tools() {
	if ! exists rustup; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	fi
	# shellcheck disable=SC1091
	. "$HOME/.cargo/env"
	rustup component add rust-analyzer
	exists just-lsp || cargo install just-lsp
	exists flamegraph || cargo install flamegraph

	for bin in cargo rustc rustup rust-analyzer cargo-clippy cargo-fmt rustfmt rust-gdb rust-lldb; do
		if exists "$bin"; then
			distrobox-export --bin "$(command -v "$bin")" --export-path /usr/local/bin 2>/dev/null || true
		fi
	done
}
install_shell_tools() {
	exists ujust || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/ujust
	exists rpm-ostree || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
	exists qs || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/qs
	exists niri || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/niri
}
install_gaming_tools() {
	exists gamescope || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/gamescope
	exists mangohud || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/mangohud
}
install_ckan() {
	if ! exists ckan; then
		dnf config-manager addrepo --from-repofile https://ksp-ckan.s3-us-west-2.amazonaws.com/rpm/stable/ckan_stable.repo 2>/dev/null \
			|| dnf config-manager --add-repo https://ksp-ckan.s3-us-west-2.amazonaws.com/rpm/stable/ckan_stable.repo
		dnf install -y ckan
	fi
	distrobox-export --app ckan 2>/dev/null || true
	if exists ckan; then
		distrobox-export --bin "$(command -v ckan)" --export-path /usr/local/bin 2>/dev/null || true
	fi
}
install_language_tools &&
	install_shell_tools &&
	install_gaming_tools &&
	install_ckan
