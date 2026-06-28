#!/usr/bin/env bats

setup() {
  export NIGHTWIRE_TESTING=1
  export SCRIPT_ROOT="$BATS_TEST_DIRNAME/.."
  source "$BATS_TEST_DIRNAME/../lib/config.sh"
  source "$BATS_TEST_DIRNAME/../lib/logging.sh"
  source "$BATS_TEST_DIRNAME/../lib/args.sh"
  ctf_init_defaults
}

@test "parses non-interactive flags" {
  ctf_parse_args --profile light --extras web,pwn --shell zsh --desktop xfce --runtime mise --browser proxy --labs local --workspace-dir '~/nightwire-labs' --assets-url https://example.com/assets.tar.gz --dry-run --yes --no-reboot --skip desktop --only runtime,packages,shell
  [ "$PROFILE" = "light" ]
  [ "$EXTRA_PROFILES" = "web,pwn" ]
  [ "$SHELL_MODE" = "zsh" ]
  [ "$DESKTOP_MODE" = "xfce" ]
  [ "$RUNTIME_MODE" = "mise" ]
  [ "$BROWSER_MODE" = "proxy" ]
  [ "$LAB_MODE" = "local" ]
  [ "$WORKSPACE_DIR" = "~/nightwire-labs" ]
  [ "$ASSETS_URL" = "https://example.com/assets.tar.gz" ]
  [ "$DRY_RUN" -eq 1 ]
  [ "$YES" -eq 1 ]
  [ "$NO_REBOOT" -eq 1 ]
  [ "$SKIP_SECTIONS" = "desktop" ]
  [ "$ONLY_SECTIONS" = "runtime,packages,shell" ]
}

@test "parses cache-dir and no-remote-installers" {
  ctf_parse_args --cache-dir /mnt/cache --no-remote-installers
  [ "$CACHE_DIR" = "/mnt/cache" ]
  [ "$REMOTE_INSTALLERS" -eq 0 ]
}

@test "rejects invalid profile" {
  PROFILE="giant"
  SHELL_MODE="both"
  DESKTOP_MODE="auto"
  run ctf_validate_options
  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid --profile"* ]]
}

@test "section filter enables only selected sections" {
  ONLY_SECTIONS="runtime,packages,shell"
  SKIP_SECTIONS=""
  ctf_section_enabled runtime
  ctf_section_enabled packages
  ctf_section_enabled shell
  run ctf_section_enabled desktop
  [ "$status" -ne 0 ]
}

@test "loads simple config file" {
  config_file="$BATS_TEST_TMPDIR/nightwire.yml"
  cat >"$config_file" <<'EOF'
profile: full
extras: ad,malware
shell: both
desktop: auto
runtime: mise
browser: proxy
labs: local
workspace_dir: ~/ctf-config
yes: true
EOF
  ctf_init_defaults
  ctf_parse_args --config "$config_file" --profile standard
  ctf_interactive_defaults
  ctf_validate_options
  [ "$PROFILE" = "standard" ]
  [ "$EXTRA_PROFILES" = "ad,malware" ]
  [ "$RUNTIME_MODE" = "mise" ]
  [ "$WORKSPACE_DIR" = "~/ctf-config" ]
  [ "$YES" -eq 1 ]
}
