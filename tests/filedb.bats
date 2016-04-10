#!/usr/bin/env bats

export FILEDB_ROOT="$PWD/data"

setup() {
  mkdir -p "$FILEDB_ROOT/DOMAIN"
  echo "VALUE" > "$FILEDB_ROOT/DOMAIN/KEY"
}

teardown() {
  rm -rf "$FILEDB_ROOT"
}

@test "(blank) a-ok" {
  run ./filedb blank DOMAIN KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/KEY"
  assert_success

  run ./filedb blank INVALID_DOMAIN INVALID_KEY
  assert_success

  run ./filedb blank DOMAIN INVALID_KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/INVALID_KEY"
  assert_failure
}

@test "(blank) invalid execution" {
  run ./filedb blank
  assert_failure

  run ./filedb blank DOMAIN
  assert_failure
}

@test "(del) a-ok" {
  run ./filedb del DOMAIN KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/KEY"
  assert_failure

  run ./filedb del INVALID_DOMAIN KEY
  assert_success

  run ./filedb del DOMAIN INVALID_KEY
  assert_success

  run test -f "$FILEDB_ROOT/DOMAIN/INVALID_KEY"
  assert_failure
}

@test "(del) invalid execution" {
  run ./filedb del
  assert_failure

  run ./filedb del DOMAIN
  assert_failure
}

@test "(exists) a-ok" {
  run ./filedb exists DOMAIN KEY
  assert_success

  run ./filedb exists INVALID_DOMAIN KEY
  assert_failure

  run ./filedb exists DOMAIN INVALID_KEY
  assert_failure
}

@test "(exists) invalid execution" {
  run ./filedb exists
  assert_failure

  run ./filedb exists DOMAIN
  assert_failure

  run ./filedb exists DOMAIN INVALID_KEY
  assert_failure
}

@test "(get) a-ok" {
  run ./filedb get INVALID_DOMAIN KEY
  assert_output ""

  run ./filedb get DOMAIN KEY
  assert_output "VALUE"

  run ./filedb get DOMAIN INVALID_KEY
  assert_output ""
}

@test "(get) invalid execution" {
  run ./filedb get
  assert_failure

  run ./filedb get DOMAIN
  assert_failure
}

@test "(set) a-ok" {
  run ./filedb set DOMAIN KEY NEW-VALUE
  assert_output ""

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/KEY | grep NEW-VALUE"
  assert_output "NEW-VALUE"

  run ./filedb set DOMAIN NEW_KEY SOME-VALUE
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/NEW_KEY | grep SOME-VALUE"
  assert_output "SOME-VALUE"

  run ./filedb set DOMAIN INVALID_KEY VALUE
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/INVALID_KEY | grep VALUE"
  assert_output "VALUE"
}

@test "(set) invalid execution" {
  run ./filedb set
  assert_failure

  run ./filedb set DOMAIN
  assert_failure
}

@test "(set-from-file) a-ok" {
}

@test "(flush-domain) a-ok" {
  run ./filedb flush-domain INVALID_DOMAIN
  assert_success

  run ./filedb flush-domain DOMAIN
  assert_success

  run test -d "$FILEDB_ROOT/DOMAIN"
  assert_success

  run /bin/bash -c "ls $FILEDB_ROOT/DOMAIN | wc -l"
  assert_output "0"
}

@test "(flush-domain) invalid execution" {
  run ./filedb flush-domain
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
