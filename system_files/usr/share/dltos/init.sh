#!/usr/bin/env bash

set -euxo pipefail

DLTOS_DIR="$(dirname "${BASH_SOURCE[0]}")"

# shellcheck disable=SC1091
. "$DLTOS_DIR/go-env.sh"

# shellcheck disable=SC1091
. "$DLTOS_DIR/cargo-env.sh"

exists() {
	[ $# -ge 1 ] || return 1
	command -v "$1" >/dev/null 2>&1
}

install_language_tools() {
	exists just-lsp || cargo install just-lsp
	exists cargo-bloat || cargo install cargo-bloat
	exists flamegraph || cargo install flamegraph
}

install_shell_tools() {
	exists ujust || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/ujust
	exists rpm-ostree || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
	exists qs || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/qs
	exists niri || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/niri
}

install_dev_tools() {
	exists hugo || go install github.com/gohugoio/hugo@v0.111.3
}

install_container_tools() {
	exists podman || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman
	exists buildah || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/buildah
	exists skopeo || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/skopeo
	exists lazydocker || go install github.com/jesseduffield/lazydocker@latest
	exists firecracker || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/firecracker
}

install_gaming_tools() {
	exists gamescope || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/gamescope
	exists mangohud || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/mangohud
}

install_language_tools &&
	install_shell_tools &&
	install_dev_tools &&
	install_container_tools &&
	install_gaming_tools