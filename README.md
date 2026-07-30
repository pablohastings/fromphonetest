# FTP test project

Minimal static site to verify FTP upload to a web server.

## Files

| Path | Purpose |
|------|---------|
| `index.html` | Landing page |
| `css/style.css` | Styles |
| `js/app.js` | Shows load time + build stamp |
| `ftp.config.example.json` | Credential template |
| `upload.ps1` | Windows FTP upload script |

## Setup

1. Copy the config template:

```bash
cp ftp.config.example.json ftp.config.json
```

2. Edit `ftp.config.json` with your host, user, password, and remote directory (often `/public_html` or `/www`).

3. Upload:

```powershell
powershell -ExecutionPolicy Bypass -File .\upload.ps1
```

4. Visit the site URL. You should see **Upload successful** and a build stamp matching the script output.

## Notes

- `ftp.config.json` is local-only — do not commit real passwords.
- Windows `ftp.exe` is used; passive mode is requested via `PASV`.
- If mkdir fails because folders already exist, that is usually fine; check the FTP transcript.
