#!/usr/bin/env bats
load test_helper

export FILEDB_ROOT="$PWD/data"

setup() {
  mkdir -p "$FILEDB_ROOT/DOMAIN"
  cat << EOF > "$FILEDB_ROOT/DOMAIN/LISTS"
FIRST_LINE
SECOND_LINE
THIRD_LINE
FOURTH_LINE
FIFTH_LINE
EOF
}

teardown() {
  rm -rf "$FILEDB_ROOT"
}

@test "[lists] (lindex) a-ok" {
  run ./filedb lindex DOMAIN LISTS 0
  assert_output "FIRST_LINE"
  run ./filedb lindex DOMAIN LISTS 1
  assert_output "SECOND_LINE"
  run ./filedb lindex DOMAIN LISTS 2
  assert_output "THIRD_LINE"
  run ./filedb lindex DOMAIN LISTS 3
  assert_output "FOURTH_LINE"
  run ./filedb lindex DOMAIN LISTS 4
  assert_output "FIFTH_LINE"

  run ./filedb lindex DOMAIN LISTS -1
  assert_output "FIFTH_LINE"
  run ./filedb lindex DOMAIN LISTS -2
  assert_output "FOURTH_LINE"
  run ./filedb lindex DOMAIN LISTS -3
  assert_output "THIRD_LINE"
  run ./filedb lindex DOMAIN LISTS -4
  assert_output "SECOND_LINE"
  run ./filedb lindex DOMAIN LISTS -5
  assert_output "FIRST_LINE"

  run ./filedb lindex DOMAIN LISTS 5
  assert_output ""
  run ./filedb lindex DOMAIN LISTS -7
  assert_output ""
}

@test "[lists] (lindex) invalid execution" {
  run ./filedb lindex
  assert_failure

  run ./filedb lindex DOMAIN
  assert_failure
}

@test "[lists] (linsert) a-ok" {
  skip "unimplemented"
}

@test "[lists] (linsert) invalid execution" {
  skip "unimplemented"
}

@test "[lists] (llen) a-ok" {
  skip "untested"
}

@test "[lists] (llen) invalid execution" {
  run ./filedb llen
  assert_failure

  run ./filedb llen DOMAIN
  assert_failure
}

@test "[lists] (lpop) a-ok" {
  skip "untested"
}

@test "[lists] (lpop) invalid execution" {
  run ./filedb lpop
  assert_failure

  run ./filedb lpop DOMAIN
  assert_failure
}

@test "[lists] (lpush) a-ok" {
  skip "untested"
}

@test "[lists] (lpush) invalid execution" {
  run ./filedb lpush
  assert_failure

  run ./filedb lpush DOMAIN
  assert_failure
}

@test "[lists] (lrem) a-ok" {
  skip "unimplemented"
}

@test "[lists] (lrem) invalid execution" {
  skip "unimplemented"
}

@test "[lists] (lset) a-ok" {
  skip "untested"
}

@test "[lists] (lset) invalid execution" {
  run ./filedb lset
  assert_failure

  run ./filedb lset DOMAIN
  assert_failure

  run ./filedb lset DOMAIN INVALID_KEY
}

@test "[lists] (rpop) a-ok" {
  skip "untested"
}

@test "[lists] (rpop) invalid execution" {
  run ./filedb rpop
  assert_failure

  run ./filedb rpop DOMAIN
  assert_failure
}

@test "[lists] (rpush) a-ok" {
  skip "untested"
}

@test "[lists] (rpush) invalid execution" {
  run ./filedb rpush
  assert_failure

  run ./filedb rpush DOMAIN
  assert_failure
}

