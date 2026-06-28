#!/usr/bin/env bats

setup() {
  NW="$BATS_TEST_DIRNAME/../bin/nightwire"
  export HOME="$BATS_TEST_TMPDIR"
  export NIGHTWIRE_BASE="$BATS_TEST_TMPDIR/base"
  export NIGHTWIRE_WORKSPACE="$BATS_TEST_TMPDIR/ws"
  export NIGHTWIRE_STATE="$BATS_TEST_TMPDIR/state"
}

@test "target without host stores state and is read back" {
  run bash "$NW" target 10.10.11.42
  [ "$status" -eq 0 ]
  [[ "$output" == *"target set: 10.10.11.42"* ]]

  run bash "$NW" _target-ip
  [ "$status" -eq 0 ]
  [ "$output" = "10.10.11.42" ]

  run bash "$NW" target
  [[ "$output" == *"IP=10.10.11.42"* ]]
}

@test "target clear removes the pinned box" {
  bash "$NW" target 10.0.0.1 >/dev/null
  run bash "$NW" target clear
  [[ "$output" == *"cleared"* ]]
  run bash "$NW" _target-ip
  [ -z "$output" ]
}

@test "invalid target is rejected" {
  run bash "$NW" target 'bad ip!'
  [ "$status" -ne 0 ]
}

@test "help lists the CTF context commands" {
  run bash "$NW" help
  [[ "$output" == *"vpn up FILE"* ]]
  [[ "$output" == *"target"* ]]
  [[ "$output" == *"banner"* ]]
}

@test "secrets round-trip parses values without sourcing the file" {
  export NIGHTWIRE_SECRETS="$BATS_TEST_TMPDIR/secrets.env"
  bash "$NW" secrets set API_KEY 'v1=v2'
  run bash "$NW" secrets get API_KEY
  [ "$output" = "v1=v2" ]
  run bash "$NW" secrets list
  [[ "$output" == *API_KEY* ]]
  bash "$NW" secrets remove API_KEY
  run bash "$NW" secrets get API_KEY
  [ -z "$output" ]
}

@test "revshell prints payloads for an explicit lhost" {
  run bash "$NW" revshell 10.10.14.7 9001
  [ "$status" -eq 0 ]
  [[ "$output" == *"/dev/tcp/10.10.14.7/9001"* ]]
}

@test "reconfigure fails cleanly without a staged installer" {
  run bash "$NW" reconfigure
  [ "$status" -ne 0 ]
}

@test "help lists the workflow commands" {
  run bash "$NW" help
  [[ "$output" == *"enum"* ]]
  [[ "$output" == *"revshell"* ]]
  [[ "$output" == *"reconfigure"* ]]
}
