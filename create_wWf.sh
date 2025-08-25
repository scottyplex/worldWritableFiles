#!/bin/bash

TEST_DIR="/tmp/ansible_wwf_test"
NUM_FILES=20
WWF_FILES_LOG="$TEST_DIR/world_writable_files.log"

# Ensure the test directory exists and the log file is cleared
mkdir -p "$TEST_DIR"
rm -f "$WWF_FILES_LOG"

echo "Creating test directory: $TEST_DIR"
cd "$TEST_DIR"

echo "Generating $NUM_FILES empty files..."
for i in $(seq 1 "$NUM_FILES"); do
  touch test_file_$i
done

echo "Randomly making some files world-writable..."
for file in test_file_*; do
  random=$((RANDOM % 3)) # Increased chance of not being wwf
  if [ $random -eq 0 ]; then
    chmod 777 "$file"
    echo "Made $file world-writable"
    echo "$TEST_DIR/$file" >> "$WWF_FILES_LOG" # Log the WWF file
  fi
done

echo "Creating subdirectories..."
mkdir -p subdir_a/subdir_b

echo "Randomly moving some world-writable files into subdirectories..."
find . -type f -perm -o=w -print0 | shuf -z | xargs -0 -n 1 mv -t subdir_a
find . -type f -perm -o=w -print0 | shuf -z | xargs -0 -n 1 mv -t subdir_a/subdir_b

# Update the log file with the new locations after moving
echo "" > "$WWF_FILES_LOG" # Clear the log to avoid duplicates

find "$TEST_DIR" -type f -perm -o=w -print0 | while IFS= read -r -d $'\0' file; do
  echo "$file" >> "$WWF_FILES_LOG"
done

echo "World-writable file generation complete."
echo "A list of created world-writable files can be found at: $WWF_FILES_LOG"
echo "You can now run your Ansible script against the system."