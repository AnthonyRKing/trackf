#!/bin/bash

# Utility to monitor changes to text files
# (c) A.R.King 2024

# Function to compare file contents, display changes with timestamps and colorization
function compare_file() {
  local file="$1"  # Assign filename to a local variable

  # Get current timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Read entire file into a process substitution
    file_content="$(cat "${file}")" || {
      echo "${PROGNAME}: Failed to read file '$file': $?"
      exit 1
    }

  # Compare the current content with the previous snapshot
  diff_output=$(diff --color=always <(echo "$previous_content") <(echo "$file_content"))
  if [ -n "$diff_output" ]; then
    # Process the diff output with sed and display
    echo "$diff_output" | sed "s/^/> $timestamp /" | sed "s/^-/  $timestamp /"

    # Use awk to find the length of the longest line (inc. timestamp)
    line_span=$(echo "$diff_output" | awk '{if (length > max) max = length} END {print max}')
    line_span=$((line_span + 13))

    # Determine line length, taking terminal width into account
    terminal_width=$(tput cols)
    if [ $line_span -gt $terminal_width ]; then
      line_span=$terminal_width
    fi

    # Build a line of hyphens
    hyphens=""
    for ((i=0; i<$line_span; i++)); do
      hyphens+="-"
    done

    # Display delimiter hyphens
    echo -e "${BOLDYEL}${hyphens}${NC}"
  fi

  # Update the previous content for the next comparison
  previous_content="$file_content"
}


#
# Start of program
#

# Program info
PROGNAME='trackfile'

# Bash colours
YELLOW='\033[0;33m'
BOLDYEL='\033[1;33m'
NC='\033[0m' # No Color

# Check if a filename is provided as an argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Get the filename from the command-line argument
file="$1"

# Check if file exists and is readable
if [ ! -r "$file" ]; then
  echo "${PROGNAME}: File '$file' does not exist or is not readable."
  exit 1
fi

# Initialize the previous content with the initial file contents
previous_content="$(cat "$file")"

# Initial message
echo -e "${BOLDYEL}Monitoring:${NC} $1"

# Continuously monitor the file for changes
while true; do
  compare_file "$file"
  sleep 1  # Sleep interval
done

