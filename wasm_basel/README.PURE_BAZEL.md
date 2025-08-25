# Pure Bazel build (no cargo-component)

This path uses:
- `rules_rust` to compile each crate to **core wasm** (`wasm32-wasi`)
- `wasm-tools component new` to **componentize** using the WASI preview1 adapter
- `wac plug` to **compose** components

## Prerequisites
- Bazel or Bazelisk
- Rust toolchain installed (rules_rust downloads toolchains, but you may want `rustup target add wasm32-wasip1` locally)
- `wasm-tools` CLI
- `wac` CLI
- **Adapter file**: download `wasi_snapshot_preview1.command.wasm` from Wasmtime releases and place it at:
  `third_party/wasi_adapters/wasi_snapshot_preview1.command.wasm`

## Build

```bash
# Build core wasm and componentize for adder & calculate
bazel build //adder:adder.component.wasm.pure --platforms=@rules_rust//rust/platform:wasi
bazel build //calculate:calculate.component.wasm.pure --platforms=@rules_rust//rust/platform:wasi

# Compose (pure Bazel, no cargo)
bazel build //run-me:hello.wasm.pure
```

Artifacts:
- `bazel-bin/adder/adder.component.wasm`
- `bazel-bin/calculate/calculate.component.wasm`
- `bazel-bin/run-me/hello.wasm`

### Notes

- If your worlds are named differently from `adder` / `app`, edit the `--world` in the per-crate genrules.
- If a crate is **reactor-style**, switch the adapter to `wasi_snapshot_preview1.reactor.wasm` and update the genrule `srcs` accordingly.
- Use `--platforms=@rules_rust//rust/platform:wasi` to target `wasm32-wasi` per rules_rust docs.
