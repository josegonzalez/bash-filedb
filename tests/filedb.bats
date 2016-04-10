#!/usr/bin/env bats

export FILEDB_ROOT="$PWD/data"

setup() {
  mkdir -p "$FILEDB_ROOT/DOMAIN"
  echo "VALUE" > "$FILEDB_ROOT/DOMAIN/KEY"
}

teardown() {
  rm -rf "$FILEDB_ROOT"
}

@test "(clear-key) a-ok" {
  run ./filedb clear-key DOMAIN KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/KEY"
  assert_success

  run ./filedb clear-key INVALID_DOMAIN INVALID_KEY
  assert_success

  run ./filedb clear-key DOMAIN INVALID_KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/INVALID_KEY"
  assert_failure
}

@test "(clear-key) invalid execution" {
  run ./filedb clear-key
  assert_failure

  run ./filedb clear-key DOMAIN
  assert_failure
}

@test "(unset-key) a-ok" {
  run ./filedb unset-key DOMAIN KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/KEY"
  assert_failure

  run ./filedb unset-key INVALID_DOMAIN KEY
  assert_success

  run ./filedb unset-key DOMAIN INVALID_KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/INVALID_KEY"
  assert_failure
}

@test "(unset-key) invalid execution" {
  run ./filedb unset-key
  assert_failure

  run ./filedb unset-key DOMAIN
  assert_failure
}

@test "(exists-key) a-ok" {
  run ./filedb exists-key DOMAIN KEY
  assert_success

  run ./filedb exists-key INVALID_DOMAIN KEY
  assert_failure

  run ./filedb exists-key DOMAIN INVALID_KEY
  assert_failure
}

@test "(exists-key) invalid execution" {
  run ./filedb exists-key
  assert_failure

  run ./filedb exists-key DOMAIN
  assert_failure

  run ./filedb exists-key DOMAIN INVALID_KEY
  assert_failure
}

@test "(get-key) a-ok" {
  run ./filedb get-key INVALID_DOMAIN KEY
  assert_output ""

  run ./filedb get-key DOMAIN KEY
  assert_output "VALUE"

  run ./filedb get-key DOMAIN INVALID_KEY
  assert_output ""
}

@test "(get-key) invalid execution" {
  run ./filedb get-key
  assert_failure

  run ./filedb get-key DOMAIN
  assert_failure
}

@test "(set-key-to-value) a-ok" {
  run ./filedb set-key-to-value DOMAIN KEY NEW-VALUE
  assert_output ""

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/KEY | grep NEW-VALUE"
  assert_output "NEW-VALUE"

  run ./filedb set-key-to-value DOMAIN NEW_KEY SOME-VALUE
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/NEW_KEY | grep SOME-VALUE"
  assert_output "SOME-VALUE"

  run ./filedb set-key-to-value DOMAIN INVALID_KEY VALUE
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/INVALID_KEY | grep VALUE"
  assert_output "VALUE"
}

@test "(set-key-to-value) invalid execution" {
  run ./filedb set-key-to-value
  assert_failure

  run ./filedb set-key-to-value DOMAIN
  assert_failure
}

@test "(set-key-to-value-from-file) a-ok" {
}

@test "(drop-domain) a-ok" {
  run ./filedb drop-domain INVALID_DOMAIN
  assert_success

  run ./filedb drop-domain DOMAIN
  assert_success

  run test -d "$FILEDB_ROOT/DOMAIN"
  assert_success

  run /bin/bash -c "ls $FILEDB_ROOT/DOMAIN | wc -l"
  assert_output "0"
}

@test "(drop-domain) invalid execution" {
  run ./filedb drop-domain
  assert_failure
}

# test functions
flunk() {
  { if [[ "$#" -eq 0 ]]; then cat -
    else echo "$*"
    fi
  }
  return 1
}

# ShellCheck doesn't know about $status from Bats
# shellcheck disable=SC2154
# shellcheck disable=SC2120
assert_success() {
  if [[ "$status" -ne 0 ]]; then
    flunk "command failed with exit status $status"
  elif [[ "$#" -gt 0 ]]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [[ "$status" -eq 0 ]]; then
    flunk "expected failed exit status"
  elif [[ "$#" -gt 0 ]]; then
    assert_output "$1"
  fi
}

assert_equal() {
  if [[ "$1" != "$2" ]]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

# ShellCheck doesn't know about $output from Bats
# shellcheck disable=SC2154
assert_output() {
  local expected
  if [[ $# -eq 0 ]]; then
    expected="$(cat -)"
  else
    expected="$1"
  fi
  assert_equal "$expected" "$output"
}

# ShellCheck doesn't know about $output from Bats
# shellcheck disable=SC2154
assert_output_contains() {
  local input="$output"; local expected="$1"; local count="${2:-1}"; local found=0
  until [ "${input/$expected/}" = "$input" ]; do
    input="${input/$expected/}"
    let found+=1
  done
  assert_equal "$count" "$found"
}

# ShellCheck doesn't know about $lines from Bats
# shellcheck disable=SC2154
assert_line() {
  if [[ "$1" -ge 0 ]] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      [[ "$line" = "$1" ]] && return 0
    done
    flunk "expected line \`$1'"
  fi
}

refute_line() {
  if [[ "$1" -ge 0 ]] 2>/dev/null; then
    local num_lines="${#lines[@]}"
    if [[ "$1" -lt "$num_lines" ]]; then
      flunk "output has $num_lines lines"
    fi
  else
    local line
    for line in "${lines[@]}"; do
      if [[ "$line" = "$1" ]]; then
        flunk "expected to not find line \`$line'"
      fi
    done
  fi
}

assert() {
  if ! "$*"; then
    flunk "failed: $*"
  fi
}

assert_exit_status() {
  assert_equal "$status" "$1"
}
