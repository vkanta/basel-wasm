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

