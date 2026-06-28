# Tool Manifest

`tools.jsonl` is a JSON Lines manifest. Each line is one installable tool:

```json
{"profile":"bugbounty","kind":"go","value":"dnsx|github.com/projectdiscovery/dnsx/cmd/dnsx@latest"}
```

Fields:

- `profile`: `light`, `standard`, `full`, or an extra profile such as `web`, `ad`, or `malware`.
- `kind`: `apt`, `pipx`, `cargo`, `go`, or `gem`.
- `value`: package name, or `binary|module` for Go/Cargo entries.

The Bash arrays remain as compatibility defaults, while this manifest is loaded during profile resolution and deduplicated before install.
