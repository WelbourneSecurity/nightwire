# Runtimes

The installer supports three runtime modes:

- `--runtime system`: use distro packages such as `golang-go`, `cargo`, and `ruby-dev`.
- `--runtime mise`: install `mise` for user-level Go, Rust, Node, and Ruby runtimes.
- `--runtime none`: skip runtime manager setup.

The package installer still prefers apt packages first. User-level tools are then installed through Cargo, Go, Gem, and pipx so tools can be updated independently with:

```bash
nightwire update
```

Use `--runtime mise` when your distro has older Go/Rust packages and modern tooling fails to build.
