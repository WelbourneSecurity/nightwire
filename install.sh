#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/config.sh
source "$SCRIPT_DIR/lib/config.sh"
# shellcheck source=lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"
# shellcheck source=lib/args.sh
source "$SCRIPT_DIR/lib/args.sh"
# shellcheck source=lib/detect.sh
source "$SCRIPT_DIR/lib/detect.sh"
# shellcheck source=lib/apt.sh
source "$SCRIPT_DIR/lib/apt.sh"
# shellcheck source=lib/runtime.sh
source "$SCRIPT_DIR/lib/runtime.sh"
# shellcheck source=lib/packages.sh
source "$SCRIPT_DIR/lib/packages.sh"
# shellcheck source=lib/assets.sh
source "$SCRIPT_DIR/lib/assets.sh"
# shellcheck source=lib/command.sh
source "$SCRIPT_DIR/lib/command.sh"
# shellcheck source=lib/workspace.sh
source "$SCRIPT_DIR/lib/workspace.sh"
# shellcheck source=lib/browser.sh
source "$SCRIPT_DIR/lib/browser.sh"
# shellcheck source=lib/labs.sh
source "$SCRIPT_DIR/lib/labs.sh"
# shellcheck source=lib/vmware.sh
source "$SCRIPT_DIR/lib/vmware.sh"
# shellcheck source=lib/shell.sh
source "$SCRIPT_DIR/lib/shell.sh"
# shellcheck source=lib/desktop.sh
source "$SCRIPT_DIR/lib/desktop.sh"
# shellcheck source=lib/validate.sh
source "$SCRIPT_DIR/lib/validate.sh"

main() {
  ctf_init_defaults
  ctf_parse_args "$@"
  ctf_setup_logging
  trap 'ctf_error "Bootstrap failed near line $LINENO. See $LOG_FILE for details."' ERR

  ctf_banner
  ctf_require_bash
  ctf_detect_platform
  ctf_prepare_privilege
  ctf_resolve_target_user
  ctf_interactive_defaults
  ctf_validate_options
  ctf_confirm_scope
  ctf_preflight_checks

  if ctf_section_enabled runtime; then ctf_setup_runtime; else ctf_info "Skipping section: runtime"; fi
  if ctf_section_enabled packages; then ctf_install_profile; else ctf_info "Skipping section: packages"; fi
  if ctf_section_enabled assets; then ctf_setup_assets; else ctf_info "Skipping section: assets"; fi
  if ctf_section_enabled command; then ctf_install_command_framework; else ctf_info "Skipping section: command"; fi
  if ctf_section_enabled workspace; then ctf_setup_workspace; else ctf_info "Skipping section: workspace"; fi
  if ctf_section_enabled browser; then ctf_setup_browser_helpers; else ctf_info "Skipping section: browser"; fi
  if ctf_section_enabled labs; then ctf_setup_labs; else ctf_info "Skipping section: labs"; fi
  if ctf_section_enabled vmware; then ctf_setup_vmware; else ctf_info "Skipping section: vmware"; fi
  if ctf_section_enabled shell; then ctf_setup_shells; else ctf_info "Skipping section: shell"; fi
  if ctf_section_enabled desktop; then ctf_setup_desktop; else ctf_info "Skipping section: desktop"; fi
  if ctf_section_enabled validate; then ctf_validate_install; else ctf_info "Skipping section: validate"; fi
  ctf_write_report

  ctf_success "Nightwire bootstrap complete. Review the report at $REPORT_FILE"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
