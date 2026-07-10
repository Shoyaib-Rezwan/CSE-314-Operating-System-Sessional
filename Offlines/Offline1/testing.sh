#!/usr/bin/bash

shopt -s expand_aliases
# Define the path to your BVCS script
alias bvcs='"/home/shoyaib/Desktop/Level3 Term1/Course Materials/Sessional/CSE 314/Offlines/Offline1/2205014.sh"'

# Setup a clean testing directory
TEST_DIR="/tmp/bvcs_testing"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

echo "=== TASK 1: Testing Repository Initialization ==="
bvcs init
# Check if directory structure exists
if [[ -d .bvcs/objects && -f .bvcs/staging && -f .bvcs/log && -f .bvcs/HEAD ]]; then
    echo "SUCCESS: Repository initialized correctly."
else
    echo "FAIL: Missing repository structural files."
fi

echo -e "\n=== TASK 2: Testing Status & Staging ==="
echo "Content A" > fileA.txt
echo "Content B" > fileB.txt
mkdir -p subfolder
echo "Content C" > subfolder/fileC.txt

echo "--- Initial Status (Should be Untracked) ---"
bvcs status

echo "--- Staging Files ---"
bvcs add fileA.txt subfolder/fileC.txt

echo "--- Status Post-Staging (Should show Staged and Untracked) ---"
bvcs status

echo -e "\n=== TASK 3: Testing Commits ==="
bvcs commit -m "Initial baseline commit"

echo "--- Status Post-Commit (Should show Untracked only) ---"
bvcs status

echo -e "\n=== TASK 4: Testing Modifications & Diffs ==="
echo "Modified Content A" > fileA.txt
echo "--- Status with Modifications (Should show Modified) ---"
bvcs status

echo "--- Diff Verification ---"
bvcs diff fileA.txt

echo -e "\n=== TASK 5: Testing History Logs ==="
bvcs add fileA.txt
bvcs commit -m "Updated fileA content"
bvcs log

echo -e "\n=== TASK 6: Testing Manual Interventions (Restore) ==="
echo "Malicious structural overwrite" > fileA.txt
echo "--- Before Restore ---"
cat fileA.txt

echo "--- Triggering Restore (Type 'y' when prompted manually) ---"
bvcs restore fileA.txt

echo "--- After Restore (Should show 'Modified Content A') ---"
cat fileA.txt