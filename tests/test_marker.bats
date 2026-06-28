#!/usr/bin/env bats

setup() {
  export NIGHTWIRE_TESTING=1
  export SCRIPT_ROOT="$BATS_TEST_DIRNAME/.."
  source "$BATS_TEST_DIRNAME/../lib/config.sh"
  source "$BATS_TEST_DIRNAME/../lib/logging.sh"
  ctf_init_defaults
  DRY_RUN=0
  SUDO_CMD=()

  # Local writers that skip ownership operations (not available in CI sandboxes).
  ctf_write_root_file() { printf '%s\n' "$2" >"$1"; }
  ctf_backup_file_once() { :; }

  FILE="$BATS_TEST_TMPDIR/rc"
  printf 'KEEP-TOP\n' >"$FILE"
}

@test "inserts a managed block and preserves existing content" {
  ctf_append_marker_block_root "$FILE" demo "alpha" root:root
  grep -q 'KEEP-TOP' "$FILE"
  grep -q 'alpha' "$FILE"
  [ "$(grep -c 'nightwire: demo' "$FILE")" -eq 2 ]
}

@test "is idempotent for identical content" {
  ctf_append_marker_block_root "$FILE" demo "alpha" root:root
  cp "$FILE" "$FILE.1"
  ctf_append_marker_block_root "$FILE" demo "alpha" root:root
  diff "$FILE" "$FILE.1"
}

@test "refreshes the block in place when content changes" {
  ctf_append_marker_block_root "$FILE" demo "alpha" root:root
  ctf_append_marker_block_root "$FILE" demo "beta-v2" root:root
  grep -q 'beta-v2' "$FILE"
  ! grep -q 'alpha' "$FILE"
  [ "$(grep -c 'nightwire: demo' "$FILE")" -eq 2 ]
  grep -q 'KEEP-TOP' "$FILE"
}

@test "a prefixed marker name does not clobber another block" {
  ctf_append_marker_block_root "$FILE" bash-console "console" root:root
  ctf_append_marker_block_root "$FILE" bash "other" root:root
  [ "$(grep -c 'nightwire: bash-console' "$FILE")" -eq 2 ]
  grep -q 'console' "$FILE"
  grep -q 'other' "$FILE"
}
