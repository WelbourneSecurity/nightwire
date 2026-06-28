# Profiles

The installer uses runtime package filtering with `apt-cache show`, so unavailable packages are skipped and recorded in the install report.

## light

Core workstation setup: build tools, shells, tmux, editors, Python/pipx, archive tools, networking tools, Docker packages where available, Alacritty/Rofi/clipboard helpers, fonts, and desktop theme packages.

## standard

Adds broad CTF coverage for web, password cracking, enumeration, reversing, pwn, forensics, stego, containers, browsers, and language toolchains.

The standard profile includes apt packages for RustScan and feroxbuster where available, plus fallback user-level installs:

- Cargo: `rustscan`, `feroxbuster`
- Go: `subfinder`, `httpx`, `nuclei`, `katana`, `naabu`, `anew`, `gau`, `waybackurls`
- Ruby Gem: `wpscan`
- pipx: `frida-tools`, `ropper`, `updog`, `ciphey`

## extras

Use `--extras` for category-specific additions:

- `web`: web fuzzing, parameter discovery, proxy/browser tooling, and Go web helpers.
- `pwn`: pwntools, GDB helpers, pwninit, one_gadget, seccomp tools, and angr.
- `rev`: Ghidra, Cutter, radare/rizin, Android reversing, and binary inspection.
- `forensics`: Autopsy, SleuthKit, Plaso, Volatility, YARA, stego, and file recovery.
- `osint`: theHarvester, Sherlock, proxy helpers, Maigret, Holehe, and socialscan.
- `wireless`: aircrack-ng, reaver, bully, hcxtools, hcxdumptool, wifite, and Kismet.
- `bugbounty`: ProjectDiscovery tooling, RustScan, feroxbuster, SecLists, and browsers.
- `cloud`: native repo cloud/kubernetes tooling where available.
- `ad`: Active Directory and Windows CTF tooling such as BloodHound, Impacket, NetExec, Certipy, Kerbrute, and Evil-WinRM where available.
- `malware`: isolated malware-analysis and reverse-engineering tooling inspired by REMnux-style workflows, including YARA, INetSim, oletools, FLOSS, Vivisect, and Malduck where available.
- `all`: applies every extra profile.

## full

Adds distro-native security metapackages only on Kali or Parrot. Ubuntu and Debian receive an expanded native package set instead; the installer never adds Kali repositories to Ubuntu or Debian.
