# Migration & Build History

This file records the concrete steps taken while attempting to migrate this Bazel/Rust workspace toward componentized WebAssembly and a WASIp2 toolchain. It is a chronological log of commands, edits, and decisions.


2025-08-20 — Initial attempt and discovery

- Ran Bazel builds and found failures caused by non-executable shell scripts under `run-me/`.

2025-08-21 — Convert runtime scripts to Bazel targets

- Replaced ad-hoc scripts in `run-me/` with Bazel `genrule` targets that call `wasm-tools`, `wac`, `jco`, and `wasmtime` as appropriate.

- Removed original shell scripts from the repository.

2025-08-22 — Adapter fetch attempt

- Attempted to fetch a WASIp2 adapter via `MODULE.bazel` (http_file) but encountered a 404 for the requested remote artifact.

- Reverted the module edits that attempted to download a wasip2 adapter.

2025-08-23 — Use Preview1 adapters locally

- Decided to use Wasmtime preview1 adapters stored under `third_party/wasi_adapters/` rather than a remote wasip2 adapter.

- Downloaded `wasi_snapshot_preview1.reactor.wasm` and `wasi_snapshot_preview1.command.wasm` from Wasmtime releases and added them to `third_party/wasi_adapters`.

- Updated `third_party/BUILD.bazel` to export the adapter files.

2025-08-24 — Genrule and component fixes

- Updated `adder/BUILD.bazel` and `calculate/BUILD.bazel` to adapt with `--adapt wasi_snapshot_preview1=...` and to use the `.command.wasm` adapter for command-style components.

- Observed wasm-tools errors: command adapter wrapping requires a `_start` export on core modules.

2025-08-25 — Add `_start` shim exports

- Added small no-op `_start` exports to `adder/src/lib.rs` and `calculate/src/lib.rs` to satisfy command adapter validation.

2025-08-26 — Rebuild and test

- Re-ran Bazel builds. Component genrules completed successfully.

- Built run targets: `//run-me:run_hello`, `//run-me:run-with-wac`, `//run-me:run-with-jco` — all succeeded.

2025-08-27 — Push changes

- Committed and pushed all changes to the `main` branch of the repository.

2025-08-28 — WASIp2 research

- Searched upstream for prebuilt WASIp2 adapter binaries. Found no canonical `wasip2.command.wasm` artifacts in Wasmtime releases or other upstream repos.

- Confirmed `third_party/BUILD.bazel` and `MODULE.bazel` note that WASIp2 is not configured and `third_party/wasi_adapters` stores preview1 adapters.

- Decision: keep Preview1 adapters for now and do not switch to WASIp2.

Notes / next steps

- To move to WASIp2 later, either obtain an official wasip2 adapter binary or build one from source (adapter sources or component toolchain). Then add it under `third_party/wasi_adapters` and update `third_party/BUILD.bazel` and component genrules to `--adapt wasip2=...`.

- Optionally add a `wasm32-wasip2` Rust toolchain in `MODULE.bazel` and update `rust_shared_library` `platform` attributes accordingly.

This HISTORY.md is intentionally verbose so future contributors can follow the decisions and reproduce the steps.
