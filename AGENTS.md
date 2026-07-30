# AGENTS.md

## Cursor Cloud specific instructions

This repo is a dependency-free static site (`index.html`, `css/style.css`, `js/app.js`) used to verify FTP uploads to a web server. There is no package manager, build step, or test suite.

### Running locally (development)

Serve the static files with any HTTP server and open the page in a browser:

```bash
python3 -m http.server 8000
# then open http://localhost:8000/index.html
```

`js/app.js` populates the "Deployed" field with the current ISO timestamp on load, so a populated timestamp (not `—`) confirms the JS ran. A `favicon.ico` 404 in the console is expected and harmless.

### Deployment (not runnable here)

`upload.ps1` is a Windows-only PowerShell FTP deploy script. It requires `ftp.config.json` (copied from `ftp.config.example.json`) and a real FTP server, so it cannot be exercised in this Linux VM. It injects `window.__FTP_BUILD__` into a temp copy of `app.js` at upload time to set the "Build stamp" field; locally the stamp stays `local-dev`.

### Lint / test / build

None configured. There is nothing to lint, test, or build.
