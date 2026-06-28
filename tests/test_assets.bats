#!/usr/bin/env bats

setup() {
  export NIGHTWIRE_TESTING=1
  export SCRIPT_ROOT="$BATS_TEST_DIRNAME/.."
  source "$BATS_TEST_DIRNAME/../lib/config.sh"
  source "$BATS_TEST_DIRNAME/../lib/assets.sh"
  ctf_init_defaults
}

@test "classifies archive asset URL" {
  run ctf_asset_url_mode https://example.com/assets.tar.gz
  [ "$status" -eq 0 ]
  [ "$output" = "archive" ]
}

@test "classifies base asset URL" {
  run ctf_asset_url_mode https://example.com/assets
  [ "$status" -eq 0 ]
  [ "$output" = "base" ]
}
