# Bazel + Rust Training

## Build & Test
- Build: `bazel build //src/hello:hello`
- Run:   `bazel run //src/hello:hello`
- Test:  `bazel test //lib/utils:utils_test`

## Milestones
1) Hello world + unit tests  
2) Multi-crate workspace (bin + lib)  
3) External Rust deps (crates)  
4) FFI with C/C++ via `cc_library`  
5) Protobuf/FlatBuffers codegen  
6) Cross-compile (Linux ↔ macOS ↔ Windows)  
7) Remote cache/exec  
8) CI with Bazelisk

