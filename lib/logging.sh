#!/usr/bin/env bash

ctf_setup_logging() {
  if [[ -z "$LOG_FILE" ]]; then
    LOG_FILE="${TMPDIR:-/tmp}/nightwire-$(date +%Y%m%d-%H%M%S).log"
  fi

  local log_dir
  log_dir="$(dirname "$LOG_FILE")"
  if ! mkdir -p "$log_dir" 2>/dev/null || ! touch "$LOG_FILE" 2>/dev/null; then
    LOG_FILE="${TMPDIR:-/tmp}/nightwire-$(date +%Y%m%d-%H%M%S).log"
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
  fi

  exec > >(tee -a "$LOG_FILE") 2>&1
}

ctf_banner() {
  cat <<'BANNER'
   ______ ______ ______   _    ____  ___
  / ____//_  __// ____/  | |  / /  |/  /
 / /      / /  / /_____  | | / / /|_/ /
/ /___   / /  / ____/ /  | |/ / /  / /
\____/  /_/  /_/   /_/   |___/_/  /_/

Nightwire Bootstrap
BANNER
  ctf_info "Version: $NIGHTWIRE_VERSION"
  ctf_info "Log file: $LOG_FILE"
}

ctf_timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

ctf_log() {
  local level="$1"
  shift
  printf '[%s] [%s] %s\n' "$(ctf_timestamp)" "$level" "$*"
}

ctf_info() {
  ctf_log INFO "$@"
}

ctf_warn() {
  ctf_log WARN "$@"
  ACTION_WARNINGS+=("$*")
}

ctf_error() {
  ctf_log ERROR "$@"
}

ctf_success() {
  ctf_log OK "$@"
}

ctf_die() {
  ctf_error "$@"
  exit 1
}

ctf_run() {
  ctf_info "+ $*"
  if ((DRY_RUN)); then
    return 0
  fi
  "$@"
}

ctf_run_root() {
  if ((${#SUDO_CMD[@]})); then
    ctf_run "${SUDO_CMD[@]}" "$@"
  else
    ctf_run "$@"
  fi
}

ctf_try_root() {
  ctf_info "+ $*"
  if ((DRY_RUN)); then
    return 0
  fi
  if ((${#SUDO_CMD[@]})); then
    "${SUDO_CMD[@]}" "$@" || ctf_warn "Command failed but bootstrap will continue: $*"
  else
    "$@" || ctf_warn "Command failed but bootstrap will continue: $*"
  fi
}

ctf_run_user_shell() {
  local command="$1"
  local user_path="$TARGET_HOME/.local/bin:$TARGET_HOME/.cargo/bin:$TARGET_HOME/go/bin:$PATH"
  ctf_info "+ user:$TARGET_USER $command"
  if ((DRY_RUN)); then
    return 0
  fi

  if [[ "$(id -un)" == "$TARGET_USER" ]]; then
    HOME="$TARGET_HOME" PATH="$user_path" bash -lc "$command"
  elif command -v sudo >/dev/null 2>&1; then
    sudo -H -u "$TARGET_USER" env HOME="$TARGET_HOME" PATH="$user_path" bash -lc "$command"
  else
    ctf_die "Cannot run user command for $TARGET_USER because sudo is unavailable."
  fi
}

ctf_try_user_shell() {
  local command="$1"
  local user_path="$TARGET_HOME/.local/bin:$TARGET_HOME/.cargo/bin:$TARGET_HOME/go/bin:$PATH"
  ctf_info "+ user:$TARGET_USER $command"
  if ((DRY_RUN)); then
    return 0
  fi

  if [[ "$(id -un)" == "$TARGET_USER" ]]; then
    HOME="$TARGET_HOME" PATH="$user_path" bash -lc "$command" || ctf_warn "User command failed but bootstrap will continue: $command"
  elif command -v sudo >/dev/null 2>&1; then
    sudo -H -u "$TARGET_USER" env HOME="$TARGET_HOME" PATH="$user_path" bash -lc "$command" || ctf_warn "User command failed but bootstrap will continue: $command"
  else
    ctf_warn "Cannot run user command for $TARGET_USER because sudo is unavailable."
  fi
}

ctf_backup_file_once() {
  local path="$1"
  if [[ -e "$path" && ! -e "$path.nightwire.bak" ]]; then
    ctf_run_root cp -a "$path" "$path.nightwire.bak"
  fi
}

ctf_write_root_file() {
  local path="$1"
  local content="$2"
  local mode="${3:-0644}"
  local owner="${4:-root:root}"
  local tmp
  tmp="$(mktemp)"
  printf '%s\n' "$content" >"$tmp"
  ctf_run_root install -D -m "$mode" -o "${owner%%:*}" -g "${owner##*:}" "$tmp" "$path"
  rm -f "$tmp"
}

# Insert or refresh a Nightwire-managed block in a file. The start marker carries
# a content hash, so re-running the installer updates the block in place when its
# content changed, and is a no-op when it did not. Any non-managed content in the
# file is preserved.
ctf_append_marker_block_root() {
  local path="$1"
  local marker="$2"
  local content="$3"
  local owner="${4:-root:root}"
  local start_prefix="# >>> nightwire: $marker "
  local end="# <<< nightwire: $marker <<<"
  local hash
  hash="$(printf '%s' "$content" | cksum | awk '{print $1}')"
  local start="${start_prefix}[v$hash] >>>"

  if [[ -f "$path" ]] && grep -Fq "$start" "$path"; then
    ctf_info "Up to date: $path ($marker)"
    return 0
  fi

  ctf_backup_file_once "$path"

  local existing=""
  if [[ -f "$path" ]]; then
    if grep -Fq "$start_prefix" "$path"; then
      ctf_info "Refreshing managed block: $path ($marker)"
    fi
    existing="$(ctf_strip_marker_block "$path" "$start_prefix" "$end")"
  fi

  local payload
  if [[ -n "$existing" ]]; then
    payload="$existing"$'\n\n'"$start"$'\n'"$content"$'\n'"$end"
  else
    payload="$start"$'\n'"$content"$'\n'"$end"
  fi

  ctf_write_root_file "$path" "$payload" 0644 "$owner"
}

# Print a file's contents with the named Nightwire block removed (inclusive of
# its start and end markers). $() trims the trailing newlines for clean reassembly.
ctf_strip_marker_block() {
  local path="$1"
  local start_prefix="$2"
  local end="$3"
  awk -v sp="$start_prefix" -v e="$end" '
    index($0, sp) == 1 { skip = 1 }
    skip && $0 == e { skip = 0; next }
    skip { next }
    { print }
  ' "$path"
}
