#!/usr/bin/env bats
load test_helper

export FILEDB_ROOT="$PWD/data"

setup() {
  mkdir -p "$FILEDB_ROOT/DOMAIN"
  echo "VALUE" > "$FILEDB_ROOT/DOMAIN/KEY"
}

teardown() {
  rm -rf "$FILEDB_ROOT"
}

@test "[keys] (blank) a-ok" {
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

@test "[keys] (blank) invalid execution" {
  run ./filedb blank
  assert_failure

  run ./filedb blank DOMAIN
  assert_failure
}

@test "[keys] (del) a-ok" {
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

@test "[keys] (del) invalid execution" {
  run ./filedb del
  assert_failure

  run ./filedb del DOMAIN
  assert_failure
}

@test "[keys] (exists) a-ok" {
  run ./filedb exists DOMAIN KEY
  assert_success

  run ./filedb exists INVALID_DOMAIN KEY
  assert_failure

  run ./filedb exists DOMAIN INVALID_KEY
  assert_failure
}

@test "[keys] (exists) invalid execution" {
  run ./filedb exists
  assert_failure

  run ./filedb exists DOMAIN
  assert_failure

  run ./filedb exists DOMAIN INVALID_KEY
  assert_failure
}

@test "[keys] (get) a-ok" {
  run ./filedb get INVALID_DOMAIN KEY
  assert_output ""

  run ./filedb get DOMAIN KEY
  assert_output "VALUE"

  run ./filedb get DOMAIN INVALID_KEY
  assert_output ""
}

@test "[keys] (get) invalid execution" {
  run ./filedb get
  assert_failure

  run ./filedb get DOMAIN
  assert_failure
}

@test "[keys] (set) a-ok" {
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

@test "[keys] (set) invalid execution" {
  run ./filedb set
  assert_failure

  run ./filedb set DOMAIN
  assert_failure
}

@test "[keys] (set-from-file) a-ok" {
  skip "untested"
}

@test "[keys] (set-from-file) invalid execution" {
  skip "untested"
}

@test "[keys] (flush-domain) a-ok" {
  run ./filedb flush-domain INVALID_DOMAIN
  assert_success

  run ./filedb flush-domain DOMAIN
  assert_success

  run test -d "$FILEDB_ROOT/DOMAIN"
  assert_success

  run /bin/bash -c "ls $FILEDB_ROOT/DOMAIN | wc -l"
  assert_output "0"
}

@test "[keys] (flush-domain) invalid execution" {
  run ./filedb flush-domain
  assert_failure
}

