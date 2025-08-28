# WASI Preview1 (current workspace configuration)

This repository currently uses WASI Preview1 adapters to componentize core WebAssembly modules and run them via component-aware tooling.

Summary

- The workspace builds Rust crates (`adder`, `calculate`, `run-me`) as core WebAssembly modules and composes components using `wasm-tools` and `wac`/`jco` tooling.

- Adapter binaries for `wasi_snapshot_preview1` are stored under `third_party/wasi_adapters/` and exported by `third_party/BUILD.bazel`.

- Component genrules use `wasm-tools component new --adapt wasi_snapshot_preview1=...` with the `*.command.wasm` adapter when building command-style components.

Why preview1

- A canonical WASIp2 adapter binary was not available at the time of the migration. Wasmtime publishes preview1 adapter binaries that are stable and suitable for composition and runtime testing.

How to build and run (local)

1. Ensure the following CLI tools are available in your PATH: `wasm-tools`, `wac`, `jco`, `wasmtime`.

1. From the workspace root run Bazel build targets. Example:

```bash
bazel build //run-me:run-with-jco
```

1. To compose components or inspect WIT produced by components, use `wasm-tools`:

```bash
wasm-tools component wit bazel-bin/run-me/hello.wasm
```

Local adapter files

- `third_party/wasi_adapters/wasi_snapshot_preview1.command.wasm` — used for command-style adaptation

- `third_party/wasi_adapters/wasi_snapshot_preview1.reactor.wasm` — reactor-style adapter (if needed)

Migration notes (how to move to WASIp2 later)

1. Obtain or build a WASIp2 adapter binary (for example, `wasip2.command.wasm`).

2. Add the adapter under `third_party/wasi_adapters/` and update `third_party/BUILD.bazel` to export it.

3. Update component genrules in `adder/BUILD.bazel`, `calculate/BUILD.bazel`, etc. to call `wasm-tools component new --adapt wasip2=//third_party:wasi_adapters/wasip2.command.wasm`.

4. Optionally add a wasm32-wasip2 rust toolchain/platform in `MODULE.bazel` and adjust `rust_shared_library` rules to target that platform.

Contact / references

- Wasmtime releases (adapter binaries): <https://github.com/bytecodealliance/wasmtime/releases>

- WASI Preview 2 docs: <https://github.com/WebAssembly/WASI/tree/main/wasip2>
