#!/bin/bash

# Function to process and extract content from files
process_file() {
  local file="$1"
  local include_binary="$2"
  local output_file="$3"
  local preserve_encoded="$4"

  # Check MIME type
  mime_type=$(file --mime-type -b "$file")
  if [[ "$include_binary" == "false" && ! "$mime_type" =~ text/* ]]; then
    echo -e "\n===== Skipping Binary File: $file (MIME: $mime_type) =====" >> "$output_file"
    return
  fi

  echo -e "\n===== File: $file =====" >> "$output_file"

  # Handle `man` pages
  if file "$file" | grep -q "troff"; then
    man -P cat "$file" >> "$output_file" 2>/dev/null || echo "[Failed to read man page: $file]" >> "$output_file"
  else
    if [[ "$preserve_encoded" == "false" ]]; then
      # Replace encoded/compressed-like strings
      sed -E -e '
        # Replace overly long base64-like strings
        s/([A-Za-z0-9+/]{50,}=*)/<[base64-encoded data]>/g;

        # Replace overly long sequences of numbers or JSON-like arrays
        s/(\[?([-+]?[0-9]+,?\s*){20,}\]?)/<[numeric array data]>/g;

        # Replace extremely long repetitive strings
        s/([A-Za-z0-9]{100,})/<[compressed or obfuscated data]>/g;

        # Replace quoted strings that are excessively long
        s/(["'"'"']{1}[A-Za-z0-9+/=]{100,}["'"'"'])/<[long encoded string]>/g;
      ' "$file" >> "$output_file" 2>/dev/null || echo "[Error reading file: $file]" >> "$output_file"
    else
      cat "$file" >> "$output_file" 2>/dev/null || echo "[Error reading file: $file]" >> "$output_file"
    fi
  fi
}

# Recursive processing of directories
process_directory() {
  local dir="$1"
  local include_binary="$2"
  local output_file="$3"
  local preserve_encoded="$4"
  local base_dir="$5"

  find "$dir" -type d | while read -r subdir; do
    # Write the tree structure for the directory
    indent=$(realpath --relative-to="$base_dir" "$subdir" | sed 's|[^/]||g' | sed 's|/|    |g')
    echo -e "$indent├── $(basename "$subdir")" >> "$output_file"

    # Process files in the current directory
    find "$subdir" -maxdepth 1 -type f | while read -r file; do
      indent=$(realpath --relative-to="$base_dir" "$file" | sed 's|[^/]||g' | sed 's|/|    |g')
      echo -e "$indent├── $(basename "$file")" >> "$output_file"
      process_file "$file" "$include_binary" "$output_file" "$preserve_encoded"
    done
  done
}

# Main script
include_binary="false"
preserve_encoded="false"
while getopts "xr" opt; do
  case $opt in
    x)
      include_binary="true"
      ;;
    r)
      preserve_encoded="true"
      ;;
    *)
      echo "Invalid option: -$OPTARG"
      echo "Usage: $0 [-x] [-r] <directory_path>"
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

if [ $# -lt 1 ]; then
  echo "Usage: $0 [-x] [-r] <directory_path>"
  exit 1
fi

input_dir="$1"
output_file="${input_dir##*/}_output.txt"

# Validate input directory
if [[ ! -d "$input_dir" ]]; then
  echo "Error: Directory $input_dir does not exist."
  exit 1
fi

# Clear or create the output file
> "$output_file"

echo "Processing directory: $input_dir"
echo "Output will be saved to: $output_file"

# Generate the tree structure and extract file contents
echo -e "===== Directory Structure of $input_dir =====\n" >> "$output_file"
echo -e "$(basename "$input_dir")" >> "$output_file"
process_directory "$input_dir" "$include_binary" "$output_file" "$preserve_encoded" "$input_dir"

echo "Processing complete. Output written to $output_file."
