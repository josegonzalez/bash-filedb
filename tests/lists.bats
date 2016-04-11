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

  cat << EOF > "$FILEDB_ROOT/DOMAIN/LISTS-TWO"
FIRST_LINE
SECOND_LINE
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
  run ./filedb llen DOMAIN LISTS
  assert_output "5"

  run ./filedb llen DOMAIN LISTS-TWO
  assert_output "2"
}

@test "[lists] (llen) invalid execution" {
  run ./filedb llen
  assert_failure

  run ./filedb llen DOMAIN
  assert_failure
}

@test "[lists] (lpop) a-ok" {
  run ./filedb lpop DOMAIN LISTS
  assert_output "FIRST_LINE"

  run ./filedb lpop DOMAIN LISTS
  assert_output "SECOND_LINE"

  run ./filedb lpop DOMAIN LISTS
  assert_output "THIRD_LINE"

  run ./filedb lpop DOMAIN LISTS
  assert_output "FOURTH_LINE"

  run ./filedb lpop DOMAIN LISTS
  assert_output "FIFTH_LINE"

  run ./filedb lpop DOMAIN LISTS
  assert_output ""
}

@test "[lists] (lpop) invalid execution" {
  run ./filedb lpop
  assert_failure

  run ./filedb lpop DOMAIN
  assert_failure
}

@test "[lists] (lpush) a-ok" {
  run ./filedb lpush DOMAIN NEW_LISTS SIXTH_LINE
  assert_output "1"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/NEW_LISTS | wc -l"
  assert_output "1"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/NEW_LISTS | grep SIXTH_LINE"
  assert_output "SIXTH_LINE"

  run ./filedb lpush DOMAIN LISTS SIXTH_LINE
  assert_output "6"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "6"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep SIXTH_LINE"
  assert_output "SIXTH_LINE"

  run ./filedb lpush DOMAIN LISTS SEVENTH_LINE
  assert_output "7"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "7"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep SEVENTH_LINE"
  assert_output "SEVENTH_LINE"

  run ./filedb lpush DOMAIN LISTS EIGTH_LINE
  assert_output "8"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "8"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep EIGTH_LINE"
  assert_output "EIGTH_LINE"

  run ./filedb lpush DOMAIN LISTS NINTH_LINE
  assert_output "9"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "9"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep NINTH_LINE"
  assert_output "NINTH_LINE"

  run ./filedb lpush DOMAIN LISTS TENTH_LINE
  assert_output "10"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "10"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep TENTH_LINE"
  assert_output "TENTH_LINE"
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
  run ./filedb lset DOMAIN LISTS 1 1-line
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep 1-line"
  assert_output "1-line"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep FIRST_LINE"
  assert_failure

  run ./filedb lset DOMAIN LISTS 2 2-line
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep 2-line"
  assert_output "2-line"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep SECOND_LINE"
  assert_failure

  run ./filedb lset DOMAIN LISTS 3 3-line
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep 3-line"
  assert_output "3-line"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep THIRD_LINE"
  assert_failure

  run ./filedb lset DOMAIN LISTS 4 4-line
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep 4-line"
  assert_output "4-line"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep FOURTH_LINE"
  assert_failure

  run ./filedb lset DOMAIN LISTS 5 5-line
  assert_success

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep 5-line"
  assert_output "5-line"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep FIFTH_LINE"
  assert_failure
}

@test "[lists] (lset) invalid execution" {
  run ./filedb lset
  assert_failure

  run ./filedb lset DOMAIN
  assert_failure

  run ./filedb lset DOMAIN INVALID_KEY
}

@test "[lists] (rpop) a-ok" {
  run ./filedb rpop DOMAIN LISTS
  assert_output "FIFTH_LINE"

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "4"

  run ./filedb rpop DOMAIN LISTS
  assert_output "FOURTH_LINE"

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "3"

  run ./filedb rpop DOMAIN LISTS
  assert_output "THIRD_LINE"

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "2"

  run ./filedb rpop DOMAIN LISTS
  assert_output "SECOND_LINE"

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "1"

  run ./filedb rpop DOMAIN LISTS
  assert_output "FIRST_LINE"

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "0"

  run ./filedb rpop DOMAIN LISTS
  assert_output ""

  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "0"
}

@test "[lists] (rpop) invalid execution" {
  run ./filedb rpop
  assert_failure

  run ./filedb rpop DOMAIN
  assert_failure
}

@test "[lists] (rpush) a-ok" {
  run ./filedb rpush DOMAIN NEW_LISTS SIXTH_LINE
  assert_output "1"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/NEW_LISTS | wc -l"
  assert_output "1"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/NEW_LISTS | grep SIXTH_LINE"
  assert_output "SIXTH_LINE"

  run ./filedb rpush DOMAIN LISTS SIXTH_LINE
  assert_output "6"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "6"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep SIXTH_LINE"
  assert_output "SIXTH_LINE"

  run ./filedb rpush DOMAIN LISTS SEVENTH_LINE
  assert_output "7"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "7"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep SEVENTH_LINE"
  assert_output "SEVENTH_LINE"

  run ./filedb rpush DOMAIN LISTS EIGTH_LINE
  assert_output "8"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "8"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep EIGTH_LINE"
  assert_output "EIGTH_LINE"

  run ./filedb rpush DOMAIN LISTS NINTH_LINE
  assert_output "9"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "9"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep NINTH_LINE"
  assert_output "NINTH_LINE"

  run ./filedb rpush DOMAIN LISTS TENTH_LINE
  assert_output "10"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | wc -l"
  assert_output "10"
  run /bin/bash -c "cat $FILEDB_ROOT/DOMAIN/LISTS | grep TENTH_LINE"
  assert_output "TENTH_LINE"
}

@test "[lists] (rpush) invalid execution" {
  run ./filedb rpush
  assert_failure

  run ./filedb rpush DOMAIN
  assert_failure
}

