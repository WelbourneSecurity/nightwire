# Local CTF Labs

These labs bind to `127.0.0.1` only.

```bash
nightwire labs list
nightwire labs catalog
nightwire labs up
nightwire labs ps
nightwire labs logs
nightwire labs down
```

Default URLs:

- Juice Shop: `http://127.0.0.1:3000`
- DVWA: `http://127.0.0.1:8081`
- WebGoat: `http://127.0.0.1:8082/WebGoat`
- Mutillidae/NOWASP: `http://127.0.0.1:8083`

Additional catalog compose files live under `/usr/local/share/nightwire/labs/catalog/`. Start them explicitly:

```bash
docker compose -p nightwire-api-labs -f /usr/local/share/nightwire/labs/catalog/api-graphql.yml up -d
```
