#!/usr/bin/env bats

setup() {
  export NIGHTWIRE_TESTING=1
  export SCRIPT_ROOT="$BATS_TEST_DIRNAME/.."
  source "$BATS_TEST_DIRNAME/../lib/config.sh"
  source "$BATS_TEST_DIRNAME/../lib/detect.sh"
  source "$BATS_TEST_DIRNAME/../lib/packages.sh"
  ctf_init_defaults
}

@test "standard includes light and standard packages" {
  DISTRO_FAMILY="ubuntu"
  EXTRA_PROFILES=""
  ctf_resolve_profile_packages standard
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq git
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq sqlmap
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq rustscan
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq cargo
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq golang-go
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq ruby-dev
  printf '%s\n' "${CARGO_TOOLS[@]}" | grep -Fxq 'rustscan|rustscan'
  printf '%s\n' "${GO_TOOLS[@]}" | grep -Fxq 'nuclei|github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest'
  printf '%s\n' "${GEM_TOOLS[@]}" | grep -Fxq wpscan
}

@test "standard adds modern privesc and pivoting tools" {
  DISTRO_FAMILY="ubuntu"
  EXTRA_PROFILES=""
  ctf_resolve_profile_packages standard
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq chisel
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq sshuttle
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq peass-ng
  printf '%s\n' "${PIPX_TOOLS[@]}" | grep -Fxq pwncat-cs
  printf '%s\n' "${GO_TOOLS[@]}" | grep -Fxq 'pspy|github.com/DominicBreuker/pspy@latest'
}

@test "web extra adds modern recon tools including cargo x8" {
  DISTRO_FAMILY="ubuntu"
  EXTRA_PROFILES="web"
  ctf_resolve_profile_packages standard
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq massdns
  printf '%s\n' "${GO_TOOLS[@]}" | grep -Fxq 'gowitness|github.com/sensepost/gowitness@latest'
  printf '%s\n' "${CARGO_TOOLS[@]}" | grep -Fxq 'x8|x8'
}

@test "rev and ad extras add modern crypto/AD tools" {
  DISTRO_FAMILY="ubuntu"
  EXTRA_PROFILES="rev,ad"
  ctf_resolve_profile_packages standard
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq jwt-tool
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq sliver
  printf '%s\n' "${PIPX_TOOLS[@]}" | grep -Fxq name-that-hash
  printf '%s\n' "${PIPX_TOOLS[@]}" | grep -Fxq bloodyAD
}

@test "all extras add category tools" {
  DISTRO_FAMILY="ubuntu"
  EXTRA_PROFILES="all"
  ctf_resolve_profile_packages standard
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq autopsy
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq aircrack-ng
  printf '%s\n' "${GO_TOOLS[@]}" | grep -Fxq 'dnsx|github.com/projectdiscovery/dnsx/cmd/dnsx@latest'
  printf '%s\n' "${PIPX_TOOLS[@]}" | grep -Fxq maigret
  printf '%s\n' "${GEM_TOOLS[@]}" | grep -Fxq one_gadget
}

@test "ad and malware extras add focused tools" {
  DISTRO_FAMILY="ubuntu"
  EXTRA_PROFILES="ad,malware"
  ctf_resolve_profile_packages standard
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq evil-winrm
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq inetsim
  printf '%s\n' "${PIPX_TOOLS[@]}" | grep -Fxq certipy-ad
  printf '%s\n' "${PIPX_TOOLS[@]}" | grep -Fxq oletools
}

@test "full kali includes kali metapackages" {
  DISTRO_FAMILY="kali"
  ctf_resolve_profile_packages full
  printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq kali-tools-top10
}

@test "full ubuntu does not include kali metapackages" {
  DISTRO_FAMILY="ubuntu"
  ctf_resolve_profile_packages full
  ! printf '%s\n' "${PROFILE_PACKAGES[@]}" | grep -Fxq kali-tools-top10
}
