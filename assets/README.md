# Assets

This directory is copied to `/usr/local/share/nightwire/` when no `--assets-url` is supplied.

For a public repo, publish heavier assets such as PNG wallpapers, icon packs, and terminal themes through GitHub Releases. The installer supports two remote layouts:

- `--assets-url https://host/path/assets.tar.gz`, optionally with `assets.tar.gz.sha256`.
- `--assets-url https://host/path/assets`, where the URL contains `manifest.sha256` plus each file listed in that manifest.

Manifest entries must use this format:

```text
<sha256>  <relative/path>
```
