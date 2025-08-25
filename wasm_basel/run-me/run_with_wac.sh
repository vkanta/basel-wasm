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

# ---------- locate tools ----------
WAC_BIN="${WAC:-}"
if [[ -z "${WAC_BIN}" ]]; then
  if command -v wac >/dev/null 2>&1; then
    WAC_BIN="$(command -v wac)"
  elif [[ -x "${HOME}/.cargo/bin/wac" ]]; then
    WAC_BIN="${HOME}/.cargo/bin/wac"
  fi
fi

WASMTIME_BIN="${WASMTIME:-}"
if [[ -z "${WASMTIME_BIN}" ]]; then
  if command -v wasmtime >/dev/null 2>&1; then
    WASMTIME_BIN="$(command -v wasmtime)"
  elif [[ -x "${HOME}/.cargo/bin/wasmtime" ]]; then
    WASMTIME_BIN="${HOME}/.cargo/bin/wasmtime"
  fi
fi

JCO_BIN="${JCO:-}"
if [[ -z "${JCO_BIN}" ]]; then
  if command -v jco >/dev/null 2>&1; then
    JCO_BIN="$(command -v jco)"
  elif command -v npx >/dev/null 2>&1; then
    JCO_BIN="npx --yes jco"
  fi
fi

# ---------- try wac interp / run ----------
if [[ -n "${WAC_BIN}" ]]; then
  if "${WAC_BIN}" help interp >/dev/null 2>&1 || "${WAC_BIN}" interp --help >/dev/null 2>&1; then
    exec "${WAC_BIN}" interp "${HELLO_PATH}" --invoke "${RUN_FUNC}" "$@"
  elif "${WAC_BIN}" help run >/dev/null 2>&1 || "${WAC_BIN}" run --help >/dev/null 2>&1; then
    exec "${WAC_BIN}" run "${HELLO_PATH}" --invoke "${RUN_FUNC}" "$@"
  fi
fi

# ---------- fall back to wasmtime component call ----------
if [[ -n "${WASMTIME_BIN}" ]]; then
  if "${WASMTIME_BIN}" help component >/dev/null 2>&1 || "${WASMTIME_BIN}" component --help >/dev/null 2>&1; then
    echo "Note: falling back to wasmtime component call (wac missing suitable subcommand)." >&2
    exec "${WASMTIME_BIN}" component call "${HELLO_PATH}" "${RUN_FUNC}" "$@"
  fi
fi

# ---------- fall back to jco ----------
if [[ -n "${JCO_BIN}" ]]; then
  echo "Note: falling back to jco (wac/wasmtime not suitable)." >&2
  # If JCO_BIN contains spaces (like 'npx --yes jco'), eval is required.
  eval "${JCO_BIN} run "${HELLO_PATH}" --invoke "${RUN_FUNC}" "$@""
  exit $?
fi

echo "ERROR: Could not find a suitable runtime. Options:" >&2
echo "  - Install/upgrade wac:      cargo install wac-cli --force --locked" >&2
echo "  - Install/upgrade wasmtime: cargo install wasmtime-cli --force --locked" >&2
echo "  - Install Node+jco:         npm i -g jco   (or rely on: npx --yes jco)" >&2
exit 127
