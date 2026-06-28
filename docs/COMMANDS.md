# nightwire Command

`nightwire` is installed to `/usr/local/bin/nightwire`.

## Core

```bash
nightwire doctor
nightwire doctor --json
nightwire update
nightwire update --upgrade
nightwire paths
nightwire uninstall --yes
```

- `doctor` checks key commands, wordlists, Docker, VMware tools, templates, lab assets, and the shell autocomplete stack.
- `update` updates apt metadata, pipx tools, Cargo tools, Go tools, Ruby gems, zsh plugins, and nuclei templates.
- `update --upgrade` also runs apt package upgrades.
- `reconfigure` re-applies the managed shell and desktop config from the installer staged on the box — run it after `update` to pull in newer console config (the managed blocks are version-hashed, so this only rewrites what changed).

## Workflow

```bash
nightwire enum 10.10.11.42      # nmap all-ports + service scan into the workspace
nightwire enum                 # uses the pinned target if no IP is given
nightwire web http://10.10.11.42       # feroxbuster/ffuf content discovery
nightwire revshell             # reverse-shell one-liners; LHOST defaults to tun0
nightwire revshell 10.10.14.7 9001
```

Output lands under `~/ctf/<target>/scans`. These touch remote systems — use only
where you are explicitly authorized.

## CTF context (VPN & target)

```bash
nightwire vpn up htb.ovpn      # connect a lab VPN in the background
nightwire vpn status           # show the tun0 address
nightwire vpn down             # disconnect
nightwire target 10.10.11.42 box.htb   # pin the box; adds box.htb to /etc/hosts
nightwire target               # show the pinned box
nightwire target clear         # unset it
nightwire ip                   # local + VPN (tun0) + target addresses
nightwire banner               # workstation context banner
```

The live `tun0` VPN address and pinned target appear in the tmux status bar and
the Starship prompt, and the banner is shown on interactive login shells. Pull
the target into your shell with `export IP=$(nightwire _target-ip)`.

Only connect to VPNs and engage targets you are explicitly authorized to use.

## Workspace

```bash
nightwire new blue-team-lab
```

Creates:

```text
recon/
scans/
loot/
notes/
screenshots/
exploit/
files/
writeup/
```

## Labs

```bash
nightwire labs list
nightwire labs up
nightwire labs ps
nightwire labs logs
nightwire labs down
```

Labs bind to `127.0.0.1` only.

## Helpers

```bash
nightwire browser-proxy
nightwire browser-ca burp-ca.der
nightwire browser-import /usr/local/share/nightwire/browser/foxyproxy-burp-zap.json
nightwire wordlists raft
nightwire serve 8000
nightwire listen 4444
nightwire scan 10.10.10.10
nightwire snapshot-note pre-lab
nightwire pwn-debuggers install
nightwire pwn-debuggers switch pwndbg
```

Only use scan/listener helpers on authorized CTF, lab, owned, or explicitly permitted systems.

## Secrets

```bash
nightwire secrets set SHODAN_API_KEY value
nightwire secrets list
nightwire secrets get SHODAN_API_KEY
nightwire secrets remove SHODAN_API_KEY
```

Secrets are stored in `~/.config/nightwire/secrets.env` with `0600` permissions.

## Reports and Cache

```bash
nightwire report box-name
nightwire cache prepare ~/nightwire-cache
nightwire cache list ~/nightwire-cache
```
