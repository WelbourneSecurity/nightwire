#!/usr/bin/env bats

# The desktop customizers only take effect inside a graphical session, so these
# guard the wiring (theme installer + Nordic-with-fallback) against regressions.

DESKTOP="$BATS_TEST_DIRNAME/../lib/desktop.sh"

@test "installs the Nordic theme and Nordzy cursors" {
  grep -q "EliverLara/Nordic" "$DESKTOP"
  grep -q "alvatip/Nordzy-cursors" "$DESKTOP"
}

@test "gnome path applies Nordic with a dark fallback" {
  grep -q "color-scheme prefer-dark" "$DESKTOP"
  grep -q 'theme=Nordic' "$DESKTOP"
  grep -q 'theme=Adwaita-dark' "$DESKTOP"
}

@test "gnome shell theme uses the user-themes extension" {
  grep -q "gnome-shell-extensions" "$DESKTOP"
  grep -q "user-theme@gnome-shell-extensions.gcampax.github.com" "$DESKTOP"
  grep -q "org.gnome.shell.extensions.user-theme name" "$DESKTOP"
}

@test "desktop library is valid bash" {
  bash -n "$DESKTOP"
}

@test "can install and switch to GNOME, sets the noir wallpaper" {
  grep -q "ctf_ensure_gnome" "$DESKTOP"
  grep -q "kali-desktop-gnome" "$DESKTOP"
  grep -q "nightwire-noir.svg" "$BATS_TEST_DIRNAME/../lib/assets.sh"
}

@test "cyber-noir wallpaper is bundled and checksummed" {
  [ -f "$BATS_TEST_DIRNAME/../assets/wallpapers/nightwire-noir.svg" ]
  grep -q "wallpapers/nightwire-noir.svg" "$BATS_TEST_DIRNAME/../assets/manifest.sha256"
}
