# Config File

Use `--config` to load a YAML-style config before CLI overrides:

```bash
./install.sh --config examples/nightwire.yml --yes
```

Supported keys:

```yaml
profile: full
extras: all
shell: both
desktop: auto
runtime: mise
browser: proxy
labs: local
workspace_dir: ~/ctf
assets_url:
cache_dir:
remote_installers: true
dry_run: false
yes: false
no_reboot: false
only:
skip:
```

- `cache_dir` — offline bundle built by `nightwire cache prepare`; the installer
  pulls plugins, Oh My Zsh, ble.sh, and the Nerd Font from it instead of the
  network. Same as `--cache-dir`.
- `remote_installers` — set `false` (or pass `--no-remote-installers`) to forbid
  `curl | sh` installers (the Starship fallback and mise); apt/git only.

The parser intentionally supports simple `key: value` lines only. Lists should be comma-separated, for example:

```yaml
extras: web,pwn,ad
```
