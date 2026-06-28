# Asset Hosting

Use GitHub Releases for large or binary assets. Keep small defaults in `assets/`.

Recommended release layout:

```text
assets.tar.gz
assets.tar.gz.sha256
```

Archive contents should be relative paths such as:

```text
wallpapers/ctf-grid.png
terminal/xfce-terminalrc
themes/example-theme/
```

For raw hosting, publish:

```text
manifest.sha256
wallpapers/ctf-grid.png
terminal/xfce-terminalrc
```

Then run:

```bash
./install.sh --assets-url https://raw.githubusercontent.com/WelbourneSecurity/nightwire/main/assets
```
