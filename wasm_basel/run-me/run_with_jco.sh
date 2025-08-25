#!/usr/bin/env bash
set -euo pipefail

# ---------- locate hello.wasm ----------
: "${RUNFILES_DIR:=${0}.runfiles}"
: "${TEST_SRCDIR:=${RUNFILES_DIR}}"

HELLO_PATH=""
if [[ -n "${RUNFILES_MANIFEST_FILE:-}" && -f "${RUNFILES_MANIFEST_FILE}" ]]; then
  HELLO_PATH="$(grep -m1 '/run-me/hello.wasm$' "${RUNFILES_MANIFEST_FILE}" | awk '{print $2}' || true)"
fi
if [[ -z "${HELLO_PATH}" ]]; then
  for root in "${TEST_SRCDIR}" "${RUNFILES_DIR}"; do
    if [[ -d "${root}" ]]; then
      for ws in "${root}"/*; do
        if [[ -f "${ws}/run-me/hello.wasm" ]]; then
          HELLO_PATH="${ws}/run-me/hello.wasm"
          break 2
        fi
      done
    fi
  done
fi
if [[ -z "${HELLO_PATH}" && -f "bazel-bin/run-me/hello.wasm" ]]; then
  HELLO_PATH="bazel-bin/run-me/hello.wasm"
fi
if [[ -z "${HELLO_PATH}" || ! -f "${HELLO_PATH}}" ]]; then
  echo "ERROR: Could not locate hello.wasm in runfiles or bazel-bin." >&2
  exit 1
fi

RUN_FUNC="${RUN_FUNC:-app.add}"

# ---------- locate jco ----------
JCO_BIN="${JCO:-}"
if [[ -z "${JCO_BIN}" ]]; then
  if command -v jco >/dev/null 2>&1; then
    JCO_BIN="$(command -v jco)"
  elif command -v npx >/dev/null 2>&1; then
    JCO_BIN="npx --yes jco"
  fi
fi
if [[ -z "${JCO_BIN}" ]]; then
  echo "ERROR: 'jco' (or 'npx') not found. Install Node.js and run: npm i -g jco" >&2
  exit 127
fi

# jco run supports component model; pass function via --invoke
# If JCO_BIN contains spaces (like 'npx --yes jco'), eval is safe here since args are controlled above.
eval "${JCO_BIN} run "${HELLO_PATH}" --invoke "${RUN_FUNC}" "$@""
