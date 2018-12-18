#!/bin/bash

set -e

rm -rf build_logs/*
# not beautiful but deleting all dot-files is uglier than it should be
# Could delete and recreate the build_logs directory in the Makefile, but
# this script would then be dependent on it
rm -rf build_logs/.nyc_output

echo "Running Linter..."
npm run --silent lint | tee build_logs/lint.log

echo "Running Unit Tests..."
npm run --silent test | tee build_logs/unit_test.log
mv .nyc_output build_logs
mv coverage build_logs
