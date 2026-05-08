#!/usr/bin/env bash

set -euxo pipefail

dnf5 -y remove xwaylandvideobridge
dnf5 -y install xdg-desktop-portal-gnome qt6ct
dnf5 -y install wlsunset cava playerctl brightnessctl

dnf5 -y copr enable avengemedia/dms
dnf5 -y install niri dms quickshell-git matugen

mkdir -p /usr/lib/systemd/user/niri.service.wants
ln -s /usr/lib/systemd/user/dms.service \
    /usr/lib/systemd/user/niri.service.wants/dms.service

# Personal Preferences

dnf5 -y install alacritty nu
