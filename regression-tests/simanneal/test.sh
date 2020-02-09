#!/bin/bash
die() { echo "$@" >&2; exit 1; }

echo "Testing simulated annealing"

TEST_DIR=./regression-tests/simanneal
[ -d "$TEST_DIR" ] || die "Must run from the repository's root directory!"

# create the test output and debug dirs if they don't exist
mkdir -p $TEST_DIR/output
rm -f $TEST_DIR/output/*
mkdir -p $TEST_DIR/debug
rm -f $TEST_DIR/debug/*

if python3 "./main.py" \
    --start 0 \
    --finish 13 \
    --debug "$TEST_DIR/debug" \
    --input "./input/frame%03d.png" \
    --output "$TEST_DIR/output" \
    --config "./config.json" \
    --initial "./cells.0.csv" \
    --temp 10 \
    --endtemp 0.01; then
    :
else
    die "Python quit unexpectedly!"
fi

python3 "$TEST_DIR/compare.py" "$TEST_DIR/expected_lineage.csv" "$TEST_DIR/output/lineage.csv" || die "compare failed"

echo "Done testing simulated annealing."
