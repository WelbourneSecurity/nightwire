# Browser Helpers

`nightwire browser-proxy` creates a Firefox profile directory with proxy settings for Burp Suite or OWASP ZAP on `127.0.0.1:8080`.

The helper does not install a CA certificate automatically. Export the CA certificate from Burp/ZAP and import it into the `nightwire-proxy` Firefox profile when you need TLS interception for authorized lab targets.

Helpers:

```bash
nightwire browser-ca burp-ca.der
nightwire browser-import /usr/local/share/nightwire/browser/foxyproxy-burp-zap.json
```
