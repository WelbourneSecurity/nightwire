# Tooling

Beyond the distro security metapackages, Nightwire layers in modern, actively
maintained tooling. Every apt name is checked with `apt-cache show` first, so a
package that is missing on a given distro is skipped rather than failing the run.
Tools are pulled from apt where available and otherwise from pipx / Go / Cargo.

## Modern additions

### Privesc & pivoting (standard profile)

| Tool | What | Channel |
| --- | --- | --- |
| peass-ng (linpeas/winpeas) | Privilege-escalation enumeration | apt (Kali) |
| pspy | Watch processes/cron without root | Go |
| chisel | TCP/UDP tunneling & port-forwarding | apt (Kali) |
| ligolo-ng | Modern subnet-routing pivot | apt (Kali) |
| pwncat-cs | Post-exploitation shell handler | pipx |
| sshuttle | VPN-like routing over SSH | apt |

### Modern recon / web (`--extras web`)

| Tool | What | Channel |
| --- | --- | --- |
| gowitness | Web screenshotting | Go |
| gospider | Fast crawler | Go |
| gf | Saved grep patterns (see note) | Go |
| unfurl | URL parsing/normalizing | Go |
| puredns + massdns | Fast resolve/bruteforce | Go + apt |
| x8 | Hidden parameter discovery | Cargo |
| kr (kiterunner) | API route discovery | Go |

`gf` needs pattern files. After install:

```bash
mkdir -p ~/.gf
git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf-tmp && cp ~/.gf-tmp/*.json ~/.gf && rm -rf ~/.gf-tmp
```

### CTF crypto / stego / rev (`--extras rev`, plus stego in standard)

| Tool | What | Channel |
| --- | --- | --- |
| stegseek | Very fast steghide cracker | release .deb |
| RsaCtfTool | Automated RSA attacks | pipx (git) |
| name-that-hash | Modern hash identifier (`nth`) | pipx |
| jwt-tool | JWT tampering/attacks | apt (Kali) |

ImHex (hex editor) is intentionally not auto-installed — its release `.deb` is
distro/version specific. Install it manually or via Flatpak if you want it.

### Modern Active Directory (`--extras ad`)

| Tool | What | Channel |
| --- | --- | --- |
| bloodyAD | Fast AD object abuse | pipx |
| Coercer | Authentication coercion | pipx |
| ldeep | Deep LDAP dumping | pipx |
| adidnsdump | AD-integrated DNS dump | pipx |
| sliver | Modern C2 (authorized use only) | apt (Kali) |

## Notes

- Several apt names above are Kali-specific (`peass-ng`, `chisel`, `ligolo-ng`,
  `jwt-tool`, `sliver`). On Debian/Ubuntu they are simply skipped.
- Add a category with `--extras`, e.g. `./install.sh --profile standard --extras web,ad`.
- `nightwire doctor` reports the core tools; `nightwire update` refreshes the
  pipx/Go/Cargo/gem tools and zsh plugins.
