

# 03 — Dynamic Student Database

A simple student management system built with C.

## Features

- Add students dynamically
- Display all registered students
- Search for students by ID
- Update student information
- Delete students
- Manage memory dynamically

## Technologies

- C
- GCC Compiler

## Concepts Practiced

- Structures (`struct`)
- Pointers
- Functions
- Arrays
- Dynamic memory allocation
- `malloc`, `realloc` and `free`
- Loops and conditional statements


## How to Run

### 1. Requirements

You need a C compiler:

- **Windows:** GCC (MinGW)
- **macOS:** GCC or Clang (install Xcode Command Line Tools)

### 2. Compile the program

**Windows (PowerShell):**

```powershell
gcc main.c -o student_database.exe
```

**macOS (Terminal):**

```bash
clang main.c -o student_database
```

Or, if GCC is installed:

```bash
gcc main.c -o student_database
```

### 3. Run the program

**Windows:**

```powershell
.\student_database.exe
```

**macOS:**

```bash
./student_database
```

### 4. Install a compiler on macOS

If you don't have a compiler, open Terminal and run:

```bash
xcode-select --install
```

Follow the installation instructions, then check your compiler:

```bash
clang --version
```