# Safety Model

This project is for authorized CTF and lab machines.

The installer:

- Does not add Kali repositories to Ubuntu or Debian.
- Filters packages through the target distro's apt metadata.
- Records skipped packages and validation warnings.
- Backs up user config files once before adding managed blocks.
- Keeps shell changes idempotent with marker comments.
- Requires confirmation for the full profile unless `--yes` is passed.
- Binds bundled vulnerable labs to `127.0.0.1` only.
- Labels command helpers as authorized-use only.
- Keeps malware-analysis additions optional under `--extras malware`; do not run samples on a shared or production VM.
- `nightwire secrets` stores local API keys with file permissions only; do not commit that file.

The installer does not automate attacks against public targets, persistence, credential theft, or evasion.
