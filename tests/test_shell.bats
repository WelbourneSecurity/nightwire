#!/usr/bin/env bats

setup() {
  export NIGHTWIRE_TESTING=1
  export SCRIPT_ROOT="$BATS_TEST_DIRNAME/.."
  source "$BATS_TEST_DIRNAME/../lib/config.sh"
  source "$BATS_TEST_DIRNAME/../lib/logging.sh"
  source "$BATS_TEST_DIRNAME/../lib/shell.sh"
  ctf_init_defaults

  DRY_RUN=1
  TARGET_USER="$(id -un)"
  TARGET_HOME="$BATS_TEST_TMPDIR"

  # Capture the managed block instead of writing it to disk.
  CAPTURED_MARKER=""
  CAPTURED_BLOCK=""
  ctf_append_marker_block_root() {
    CAPTURED_MARKER="$2"
    CAPTURED_BLOCK="$3"
  }

  # Neutralize the heavy install steps; these tests assert on generated config.
  ctf_install_packages() { :; }
  ctf_install_oh_my_zsh() { :; }
  ctf_install_zsh_plugins() { :; }
  ctf_install_tpm() { :; }
  ctf_write_starship_config() { :; }
}

@test "bash console block wires up ble.sh, completion, fzf and starship" {
  ctf_configure_bash
  [ "$CAPTURED_MARKER" = "bash-console" ]
  [[ "$CAPTURED_BLOCK" == *"blesh/ble.sh"* ]]
  [[ "$CAPTURED_BLOCK" == *"ble-attach"* ]]
  [[ "$CAPTURED_BLOCK" == *"bash-completion/bash_completion"* ]]
  [[ "$CAPTURED_BLOCK" == *"FZF_DEFAULT_COMMAND"* ]]
  [[ "$CAPTURED_BLOCK" == *"starship init bash"* ]]
}

@test "bash console block adds modern CLI tools and the context banner" {
  ctf_configure_bash
  [[ "$CAPTURED_BLOCK" == *"zoxide init bash"* ]]
  [[ "$CAPTURED_BLOCK" == *"eza -alF"* ]]
  [[ "$CAPTURED_BLOCK" == *"nightwire banner"* ]]
}

@test "readline inputrc enables case-insensitive completion and history search" {
  ctf_configure_readline
  [ "$CAPTURED_MARKER" = "readline" ]
  [[ "$CAPTURED_BLOCK" == *"completion-ignore-case on"* ]]
  [[ "$CAPTURED_BLOCK" == *"show-all-if-ambiguous on"* ]]
  [[ "$CAPTURED_BLOCK" == *"history-search-backward"* ]]
}

@test "zsh console block loads the exegol-style plugin set" {
  ctf_configure_zsh
  [ "$CAPTURED_MARKER" = "zsh-console" ]
  [[ "$CAPTURED_BLOCK" == *"compinit"* ]]
  [[ "$CAPTURED_BLOCK" == *"zsh-autosuggestions.zsh"* ]]
  [[ "$CAPTURED_BLOCK" == *"zsh-syntax-highlighting.zsh"* ]]
  [[ "$CAPTURED_BLOCK" == *"fzf-tab.plugin.zsh"* ]]
  [[ "$CAPTURED_BLOCK" == *"zsh-completions/src"* ]]
}

@test "zsh sources syntax highlighting after autosuggestions and fzf-tab" {
  ctf_configure_zsh
  local before_highlight="${CAPTURED_BLOCK%%zsh-syntax-highlighting.zsh*}"
  [[ "$before_highlight" == *"zsh-autosuggestions.zsh"* ]]
  [[ "$before_highlight" == *"fzf-tab.plugin.zsh"* ]]
}

@test "zsh console block sources oh-my-zsh and modern CLI tools" {
  ctf_configure_zsh
  [[ "$CAPTURED_BLOCK" == *"oh-my-zsh.sh"* ]]
  [[ "$CAPTURED_BLOCK" == *"zoxide init zsh"* ]]
  [[ "$CAPTURED_BLOCK" == *"eza -alF"* ]]
}

@test "tmux config enables persistence and the live status helper" {
  ctf_configure_tmux
  [ "$CAPTURED_MARKER" = "tmux-console" ]
  [[ "$CAPTURED_BLOCK" == *"tmux-continuum"* ]]
  [[ "$CAPTURED_BLOCK" == *"tpm/tpm"* ]]
  [[ "$CAPTURED_BLOCK" == *"_tmux-status"* ]]
}

@test "shell library builds ble.sh and clones the zsh plugins" {
  grep -q "akinomyoga/ble.sh" "$BATS_TEST_DIRNAME/../lib/shell.sh"
  grep -q "zsh-users/zsh-autosuggestions" "$BATS_TEST_DIRNAME/../lib/shell.sh"
  grep -q "zsh-users/zsh-syntax-highlighting" "$BATS_TEST_DIRNAME/../lib/shell.sh"
  grep -q "Aloxaf/fzf-tab" "$BATS_TEST_DIRNAME/../lib/shell.sh"
}

@test "shell library installs a pinned Nerd Font and clones oh-my-zsh" {
  grep -q "ryanoasis/nerd-fonts" "$BATS_TEST_DIRNAME/../lib/shell.sh"
  grep -q "ohmyzsh/ohmyzsh.git" "$BATS_TEST_DIRNAME/../lib/shell.sh"
  grep -q "tmux-plugins/tpm" "$BATS_TEST_DIRNAME/../lib/shell.sh"
}
