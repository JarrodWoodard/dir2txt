### **README: dir2txt**

This README provides detailed instructions on how to use the `dir2txt` script to traverse directories, extract file contents, and generate an organized tree structure of the directory. It also describes the script's functionality, usage, and options, as well as examples for running it.

---

## **Project Overview**

`dir2txt` is a lightweight, bash-based tool designed to:
1. **Generate Directory Tree:** Create a tree-like hierarchy of directories and files in a specified directory.
2. **Extract File Content:** Append the content of text-based files to the output, preserving their context.
3. **Encoded Data Handling:** Replace large blocks of encoded or compressed data with descriptive placeholders by default.
4. **Binary File Exclusion:** Exclude binary files unless explicitly included via a flag.
5. **Flexible Options:** Enable or disable specific behaviors like including binary files or preserving encoded data using flags.

---

## **Requirements and Dependencies**

### **Requirements**
- A Unix-like operating system with a terminal (Linux, macOS, etc.).
- `bash` (Bourne Again Shell) installed.

### **Dependencies**
`dir2txt` relies on standard Unix utilities, all typically pre-installed:
- `file`: Determines the MIME type of a file.
- `find`: Recursively searches directories.
- `sed`: A stream editor for text transformations.

---

## **Installation**

### Step 1: Copy the Script
Copy the entire `dir2txt` script from its source into your clipboard. Be sure to include everything from `#!/bin/bash` to the end.

### Step 2: Create and Open a File in `vim`
Run the following command to create a new script file and open it in `vim`:
```bash
vim dir2txt.sh
```

### Step 3: Paste the Script into `vim`
In `vim`:
1. Press `i` to enter **Insert Mode**.
2. Paste the script by pressing `Ctrl+Shift+V` (or `Cmd+V` on macOS).
3. Press `Esc` to exit Insert Mode.

### Step 4: Save and Exit `vim`
To save and exit:
1. Type `:wq` and press `Enter`.

### Step 5: Make the Script Executable
Run the following command to make the script executable:
```bash
chmod +x dir2txt.sh
```

---

## **Usage**

The script requires one argument: the path to the directory you want to process. Optional flags let you customize its behavior.

### **Basic Syntax**
```bash
./dir2txt.sh [OPTIONS] <directory_path>
```

### **Options**
- **Default Behavior (No Flags):**
  - Skips binary files.
  - Replaces encoded/compressed data blocks with descriptive placeholders.

- **Flags:**
  - `-x`: **Disable Binary File Exclusion**
    - Includes binary files in the output.
  - `-r`: **Disable Encoded Data Replacement**
    - Preserves encoded or compressed-like data in file content.

### **Examples**

#### 1. **Default Usage**
Generate a directory tree with content extraction. Skips binary files and replaces encoded data:
```bash
./dir2txt.sh /path/to/directory
```

#### 2. **Include Binary Files**
Include binary files in the directory tree output:
```bash
./dir2txt.sh -x /path/to/directory
```

#### 3. **Preserve Encoded Data**
Preserve all encoded/compressed-like data:
```bash
./dir2txt.sh -r /path/to/directory
```

#### 4. **Combine Both Flags**
Include binary files and preserve encoded data:
```bash
./dir2txt.sh -x -r /path/to/directory
```

### **Output**
The script generates a file named `<directory_name>_output.txt` in the current working directory. This file includes:
1. A tree-like structure of the directory.
2. The content of each file processed, inserted after the corresponding file path.

---

## **Examples in Action**

### **Directory Structure**
Assume the following directory:
```
example-dir
├── file1.txt
├── file2.log
├── folder1
│   ├── binary1.bin
│   └── file3.json
└── folder2
    ├── encoded_data.txt
    └── script.js
```

### **Running dir2txt**
To process `example-dir`:
```bash
./dir2txt.sh example-dir
```

### **Output Example**
The generated `example-dir_output.txt`:
```
===== Directory Structure of example-dir =====

example-dir
├── file1.txt
├── file2.log
├── folder1
│   ├── binary1.bin
│   └── file3.json
└── folder2
    ├── encoded_data.txt
    └── script.js

===== File: file1.txt =====
[File content]

===== File: file2.log =====
[File content]

===== File: folder1/binary1.bin =====
<[binary file content omitted]>

===== File: folder2/encoded_data.txt =====
<[encoded or compressed data detected]>

===== File: folder2/script.js =====
[JavaScript content]
```

---

## **Notes**
- This content is AI generated as was the code.
- I could not get the inital tree directory structure of the output working and got tired of messing with the AI to get it.
- Large directories may take longer to process depending on file size and count.
- Ensure you have the necessary permissions to access all directories and files.
- Review the output file to verify content is processed as expected.

Enjoy using **dir2txt**!
