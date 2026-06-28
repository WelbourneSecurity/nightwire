# Shell & Autocomplete

Nightwire configures an Exegol-style interactive console for both Bash and Zsh.
The goal is a fast, modern prompt with rich autocomplete: inline suggestions as
you type, fuzzy completion menus, and syntax highlighting.

Select the target with `--shell bash|zsh|both` (default `both`).

## What you get

| Feature | Zsh | Bash |
| --- | --- | --- |
| Inline "ghost text" autosuggestions from history | zsh-autosuggestions | ble.sh |
| Command syntax highlighting as you type | zsh-syntax-highlighting | ble.sh |
| Fuzzy completion menu on `Tab` | fzf-tab | readline menu-complete + fzf |
| Extra completion definitions | zsh-completions | bash-completion |
| Case-insensitive, colored completion | compinit + zstyle | `~/.inputrc` |
| Fuzzy history (`Ctrl-R`), files (`Ctrl-T`), dirs (`Alt-C`) | fzf | fzf |
| Smart `cd` / jumping | zoxide (`z`) | zoxide (`z`) |
| Icon-rich `ls` | eza | eza |
| Prompt (with live VPN indicator) | Starship | Starship |

The prompt uses **Nerd Font** glyphs (a pinned Hack Nerd Font is installed and
the managed terminals are pointed at it). `eza`, `zoxide`, and `tldr` are
installed when packaged for the distro; the shell config only activates them when
present, so nothing breaks if a distro lacks them.

### Keys

- `Tab` — completion menu (fzf-driven in Zsh).
- `→` / `End` / `Ctrl-Space` — accept the current inline autosuggestion (Zsh).
- `↑` / `↓` — history search by the prefix already typed.
- `Ctrl-R` — fuzzy history search (fzf).
- `Ctrl-T` — fuzzy file picker (fzf).
- `Alt-C` — fuzzy `cd` (fzf).

## How it is installed

### Zsh

1. Oh My Zsh is installed unattended (`KEEP_ZSHRC=yes`, no shell change, no auto-run).
2. The plugin set is installed from apt where available
   (`zsh-autosuggestions`, `zsh-syntax-highlighting`) and otherwise cloned into
   `~/.oh-my-zsh/custom/plugins`. `zsh-completions` and `fzf-tab` are always
   cloned there.
3. A managed block in `~/.zshrc` sets up `compinit`, completion styling, fzf,
   fzf-tab, autosuggestions, and (last, as required) syntax highlighting.

The block guards every plugin with a "already loaded?" check, so it is safe on
Kali/Parrot images whose default `~/.zshrc` already sources some of these.

### Bash

1. [`ble.sh`](https://github.com/akinomyoga/ble.sh) is built from source into
   `~/.local/share/blesh` (best-effort; a build failure never aborts the
   install). It provides the fish-style autosuggestions and syntax highlighting.
2. A tuned `~/.inputrc` gives plain Bash sessions case-insensitive, colored,
   menu-style completion plus prefix history search on the arrow keys.
3. A managed block in `~/.bashrc` wires up `bash-completion`, fzf, Starship, and
   attaches `ble.sh` last.

## tmux

The managed `~/.tmux.conf` enables truecolor, vi copy-mode, mouse, and pane
navigation, and installs the tmux plugin manager (tpm) with
`tmux-resurrect` + `tmux-continuum` so sessions are saved and **auto-restored
across reboots and VMware snapshots**. The status bar shows the live `tun0` VPN
address and pinned target (`nightwire _tmux-status`).

## Nerd Font

A pinned `Hack` Nerd Font (`NERD_FONT_VERSION`, default `v3.2.1`) is downloaded
to `~/.local/share/fonts`. The archive is integrity-checked, and if you export
`NERD_FONT_SHA256` it is checksum-verified. The managed Alacritty / Xfce / GNOME
/ KDE / MATE terminal configs are set to `Hack Nerd Font`. If you use a different
terminal, set its font to `Hack Nerd Font` (or delete `~/.config/starship.toml`
to fall back to text symbols).

## fd / bat names

Debian, Kali, Ubuntu, and Parrot ship `fd` as `fdfind` and `bat` as `batcat`.
Nightwire symlinks the short names into `~/.local/bin` so `fd`, `bat`, and
fzf's `FZF_DEFAULT_COMMAND` all work as expected.

## Verifying

```bash
nightwire doctor          # includes a "Shell experience (autocomplete)" section
nightwire doctor --json   # adds a "shell" object with per-feature booleans
```

Open a new terminal (or `exec $SHELL -l`) after install to load the changes.

## Updating the config

The managed blocks carry a content hash in their start marker, so re-running the
installer refreshes them in place only when the shipped config changed — your own
edits elsewhere in the file are preserved. To pull in newer console config
without a full re-run:

```bash
nightwire update        # refresh tools + zsh plugins
nightwire reconfigure   # re-apply the managed shell/desktop/tmux blocks
```

## Reverting

Every managed file (`~/.bashrc`, `~/.zshrc`, `~/.inputrc`, `~/.tmux.conf`) is
backed up once as `*.nightwire.bak` before the managed block is added.
`nightwire uninstall` restores those backups. Cloned plugins, `ble.sh`, and apt
packages are left in place, like other installed tooling.
