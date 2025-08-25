# Bazel + Wasm Example Build

This project demonstrates how to **compile multiple Rust crates to Wasm components** and **compose them into a single Wasm artifact** using Bazel.  

It includes:
- `adder` → a simple addition component  
- `calculate` → a second component that uses `adder`  
- `run-me` → a composition step producing `hello.wasm`  

Multiple runtime wrappers are provided (`wasmtime`, `wac-cli`, `jco`).

---

## Prerequisites

- [Bazel](https://bazel.build/) (8.x+ recommended)
- Rust + Cargo (for local builds and wac-cli)
- Node.js (optional, for jco runner)

### Install runtimes

```bash
# Wasmtime
cargo install wasmtime-cli --force --locked

# wac-cli
cargo install wac-cli --force --locked

# jco (Node-based)
npm i -g jco   # or rely on `npx --yes jco`
````

---

## Build all components

To clean and rebuild everything, run:

```bash
./rebuild_all.sh
```

This script will:

1. `bazel clean`
2. Rebuild all core components (`adder`, `calculate`)
3. Rebuild the composed component (`run-me/hello.wasm.pure`)
4. Rebuild all runtime wrapper targets

---

## Run targets

### 1. Wasmtime runner (reactor style)

```bash
# Default export (app.add)
bazel run //run-me:eval-expression -- 2 3

# Or explicitly set the function name
RUN_FUNC=add bazel run //run-me:eval-expression -- 2 3
```

### 2. Wac runner (auto-detects `interp` or `run`)

```bash
bazel run //run-me:run-with-wac -- 2 3
```

You can force a specific binary with:

```bash
WAC="$HOME/.cargo/bin/wac" bazel run //run-me:run-with-wac -- 2 3
```

### 3. Jco runner (Node-based)

```bash
bazel run //run-me:run-with-jco -- 2 3
```

Uses global `jco` if available, else falls back to `npx --yes jco`.

---

## Scripts

### `rebuild_all.sh`

Convenience script to clean and rebuild all targets:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo ">>> Cleaning Bazel outputs..."
bazel clean

echo ">>> Rebuilding core components..."
bazel build //adder:adder.component.wasm.pure
bazel build //calculate:calculate.component.wasm.pure

echo ">>> Rebuilding composition..."
bazel build //run-me:hello.wasm.pure

echo ">>> Rebuilding runtime wrappers..."
bazel build //run-me:run_hello
bazel build //run-me:eval-expression
bazel build //run-me:run-with-wac
bazel build //run-me:run-with-jco

echo ">>> All targets rebuilt successfully!"
```

---

## Notes

* This example currently builds and composes correctly.
* Runtime integration still needs polish:

  * Some runtimes expect a **reactor-style export** (`component call`)
  * Others expect a **command-world** export (`wasi:cli/run@0.2.0`)

Future improvements will include pinned runtime binaries and a `hello_cmd.wasm` target for CLI-style invocation.



