# Bazel + Rust + WASM (WASI) with Hermetic C/C++ toolchains

Fix for missing C++ toolchain on WASI: registers **hermetic_cc_toolchain (Zig)**,
which provides cross C/C++ toolchains including **wasm32-wasi**.
We also select **rules_rust's WASI platform** so Rust toolchains match.

## Build
bazel clean
bazel build //adder:adder.component.wasm.pure
bazel build //calculate:calculate.component.wasm.pure
