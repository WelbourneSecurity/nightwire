#!/usr/bin/env bats

setup() {
  export NIGHTWIRE_TESTING=1
  export SCRIPT_ROOT="$BATS_TEST_DIRNAME/.."
  source "$BATS_TEST_DIRNAME/../lib/config.sh"
  source "$BATS_TEST_DIRNAME/../lib/logging.sh"
  source "$BATS_TEST_DIRNAME/../lib/tui.sh"
  ctf_init_defaults
}

@test "tui is disabled with --yes" {
  YES=1
  run ctf_tui_enabled
  [ "$status" -ne 0 ]
}

@test "tui helper functions are defined" {
  declare -F ctf_menu >/dev/null
  declare -F ctf_checklist >/dev/null
  declare -F ctf_yesno >/dev/null
  declare -F ctf_tui_configure >/dev/null
}

@test "wizard runs before the logging redirect (whiptail needs the terminal)" {
  local installer="$BATS_TEST_DIRNAME/../install.sh"
  local tui_line log_line
  tui_line="$(grep -n 'ctf_tui_configure' "$installer" | head -1 | cut -d: -f1)"
  log_line="$(grep -n 'ctf_setup_logging' "$installer" | head -1 | cut -d: -f1)"
  [ -n "$tui_line" ] && [ -n "$log_line" ]
  [ "$tui_line" -lt "$log_line" ]
}

@test "section headers render a progress bar" {
  CTF_COLOR=0
  ctf_init_colors
  CTF_SECTION_TOTAL=10
  CTF_SECTION_NUM=5
  run ctf_section "Demo"
  [[ "$output" == *"5/10"* ]]
  [[ "$output" == *"█"* ]]
}
