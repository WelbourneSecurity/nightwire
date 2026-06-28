# Tool Manifests

`manifests/tools.jsonl` lets you add tools without editing Bash arrays.

Each line is JSON:

```json
{"profile":"ad","kind":"pipx","value":"certipy-ad"}
```

Kinds:

- `apt`: distro package name.
- `pipx`: Python CLI package.
- `cargo`: `binary|crate`.
- `go`: `binary|module@version`.
- `gem`: Ruby gem.

The installer loads the manifest during profile resolution, then deduplicates the final apt/pipx/cargo/go/gem lists.
