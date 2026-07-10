#!/usr/bin/bash

shopt -s expand_aliases
# Define the absolute path to your BVCS implementation
alias bvcs='"/home/shoyaib/Desktop/Level3 Term1/Course Materials/Sessional/CSE 314/Offlines/Offline1/2205014.sh"'

# Setup a clean test workspace
WORKSPACE="tmp/bvcs_ultimate_test"
rm -rf "$WORKSPACE"
mkdir -p "$WORKSPACE"
cd "$WORKSPACE" || exit 1

echo "=========================================================="
echo "EDGE CASE SUITE 1: Pre-initialization Guard Checks"
echo "=========================================================="
# Testing commands before running 'init'
bvcs status
bvcs log
bvcs add file.txt
bvcs commit -m "Should fail"
bvcs diff
bvcs restore file.txt
bvcs unknown_cmd

echo -e "\n=========================================================="
echo "EDGE CASE SUITE 2: Repository Initialization"
echo "=========================================================="
bvcs init
# Check structural instantiation
ls -a .bvcs/
# Duplicate initialization error check
bvcs init

echo -e "\n=========================================================="
echo "EDGE CASE SUITE 3: Empty History Controls & Help"
echo "=========================================================="
bvcs status
bvcs log
bvcs diff

echo -e "\n=========================================================="
echo "EDGE CASE SUITE 4: Advanced Staging Options"
echo "=========================================================="
# No args given
bvcs add 

# Prepare mixed valid, missing, and duplicate items
echo "alpha-content" > alpha.txt
echo "beta-content" > beta.txt
mkdir -p sub
echo "gamma-content" > sub/gamma.txt

# Phase 1 staging
bvcs add alpha.txt sub/gamma.txt

# Phase 2 staging with duplicate and non-existent tracking metrics
bvcs add alpha.txt ghost.txt beta.txt

echo -e "\n=========================================================="
echo "EDGE CASE SUITE 5: Status Ordering & Blank Line Assertions"
echo "=========================================================="
# Create an untracked file that sorts alphabetically earlier/later
echo "untracked-content" > delta.txt
echo "abc-untracked" > abc.txt

# Check current category separation
bvcs status

echo -e "\n=========================================================="
echo "EDGE CASE SUITE 6: Fail-safe Commits"
echo "=========================================================="
# Missing flag/message errors
bvcs commit
bvcs commit -m

# Successful initial baseline commit
bvcs commit -m "Initial commit snapshot"

# Immediate empty commit prevention evaluation
bvcs commit -m "Empty tracking validation"

echo -e "\n=========================================================="
echo "EDGE CASE SUITE 7: Tracking Progress, Logs, and Diffs"
echo "=========================================================="
# Modify staged baseline
echo "alpha-content-mutated" > alpha.txt
# Stage change
bvcs add alpha.txt
# Commit commit #2
bvcs commit -m "Updated alpha source structural configurations"

# Mutate workspace tracking without staging
echo "alpha-content-double-mutated" > alpha.txt

echo "--- Status Output ---"
bvcs status

echo "--- History Log Verification ---"
bvcs log

echo "--- Single File Diff Output ---"
bvcs diff alpha.txt

echo "--- Clean Single File Diff Output ---"
bvcs diff beta.txt

echo "--- Untracked File Diff Exception Handling ---"
bvcs diff ghost.txt

echo -e "\n=========================================================="
echo "EDGE CASE SUITE 8: Interactive Content Restorations"
echo "=========================================================="
# Missing target argument
bvcs restore

# Untracked file target selection
bvcs restore ghost.txt

# Case 8A: User abort configuration check (Simulating 'n')
echo "--- Testing Restore Abort ---"
echo "n" | bvcs restore alpha.txt
cat alpha.txt

# Case 8B: User acceptance validation (Simulating 'y')
echo "--- Testing Restore Acceptance ---"
echo "y" | bvcs restore alpha.txt
cat alpha.txt