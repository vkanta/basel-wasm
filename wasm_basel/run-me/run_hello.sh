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
if [[ -z "${HELLO_PATH}" && -d "${TEST_SRCDIR}" ]]; then
  HELLO_PATH="$(find "${TEST_SRCDIR}" -maxdepth 3 -type f -path '*/run-me/hello.wasm' -print -quit || true)"
fi
if [[ -z "${HELLO_PATH}" && -d "${RUNFILES_DIR}" ]]; then
  HELLO_PATH="$(find "${RUNFILES_DIR}" -maxdepth 3 -type f -path '*/run-me/hello.wasm' -print -quit || true)"
fi
if [[ -z "${HELLO_PATH}" && -f "bazel-bin/run-me/hello.wasm" ]]; then
  HELLO_PATH="bazel-bin/run-me/hello.wasm"
fi
if [[ -z "${HELLO_PATH}" || ! -f "${HELLO_PATH}" ]]; then
  echo "ERROR: Could not locate hello.wasm in runfiles (TEST_SRCDIR/RUNFILES_DIR) or bazel-bin." >&2
  exit 1
fi

# ---------- locate wasmtime ----------
WASMTIME_BIN="${WASMTIME:-}"
if [[ -z "${WASMTIME_BIN}" ]]; then
  if command -v wasmtime >/dev/null 2>&1; then
    WASMTIME_BIN="$(command -v wasmtime)"
  elif [[ -x "${HOME}/.cargo/bin/wasmtime" ]]; then
    WASMTIME_BIN="${HOME}/.cargo/bin/wasmtime"
  fi
fi
if [[ -z "${WASMTIME_BIN}" ]]; then
  echo "ERROR: 'wasmtime' not found. Install with: cargo install wasmtime-cli --force --locked" >&2
  exit 127
fi

# ---------- check component support ----------
if "${WASMTIME_BIN}" component --help >/dev/null 2>&1 || "${WASMTIME_BIN}" help component >/dev/null 2>&1; then
  : # supported
else
  echo "Your wasmtime does not support 'component' subcommand." >&2
  echo "Using wasmtime at: ${WASMTIME_BIN}" >&2
  "${WASMTIME_BIN}" --version >&2 || true
  echo "Upgrade with: cargo install wasmtime-cli --force --locked" >&2
  exit 2
fi

# ---------- invoke function ----------
RUN_FUNC="${RUN_FUNC:-run}"
exec "${WASMTIME_BIN}" component call "${HELLO_PATH}" "${RUN_FUNC}" "$@"
