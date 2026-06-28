# UI Customization

The installer applies a dark translucent workstation look where the detected desktop supports it.

For the interactive shell experience (Exegol-style autocomplete, autosuggestions, syntax highlighting, fzf, Starship), see [SHELL.md](SHELL.md).

## Terminal

- Alacritty: writes a new translucent `~/.config/alacritty/alacritty.toml` when no config exists.
- Xfce Terminal: appends managed color, font, geometry, and transparency settings.
- GNOME Terminal: best-effort profile update with dark colors and transparency if the installed GNOME Terminal schema still supports it.
- Konsole: writes a `CTF-Translucent` profile and color scheme.
- MATE Terminal: best-effort profile update with transparent background settings.

Existing user-owned Alacritty and Rofi configs are preserved.

## Desktop

- Sets the bundled wallpaper when a graphical session exposes a supported settings API.
- Installs the **Nordic** GTK theme + Papirus-Dark icons + Nordzy cursors and applies them on GNOME, Xfce, and MATE (dark color-scheme, GTK theme, cursor, and a Nerd Font UI font). If the Nordic download did not land, it falls back to the stock dark theme (Adwaita-dark / Arc-Dark).
- On GNOME, the installer also installs `gnome-shell-extensions`, enables the **user-themes** extension, and applies the Nordic **GNOME Shell** theme (top bar / overview). This takes effect on the next logout — under Wayland the shell cannot be reloaded live. GTK app theme + dark color-scheme apply immediately.
- Applies KDE Breeze Dark when `lookandfeeltool` is present.
- Adds a translucent Rofi launcher theme and sets Alacritty as Rofi's terminal.

## Browser

`--browser proxy` installs helper assets and runs:

```bash
nightwire browser-proxy
```

This creates a Firefox profile helper configured for `127.0.0.1:8080`, matching the default Burp Suite and OWASP ZAP proxy port.
