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

## Automatic Deployment with GitHub Actions

The repository includes a GitHub Actions workflow that automatically deploys to FTP on every push to `main`.

### Setup GitHub Actions:

1. Go to your repository **Settings** → **Secrets and variables** → **Actions**
2. Add these secrets:
   - `FTP_HOST` - Your FTP server hostname or IP
   - `FTP_USER` - Your FTP username
   - `FTP_PASSWORD` - Your FTP password
   - `FTP_REMOTE_DIR` - Remote directory path (e.g., `/public_html/yoursite`)

Once configured, every push to `main` will automatically deploy your site!

You can also manually trigger deployment from the **Actions** tab.

## Notes

- `ftp.config.json` is local-only — do not commit real passwords.
- Windows `ftp.exe` is used; passive mode is requested via `PASV`.
- If mkdir fails because folders already exist, that is usually fine; check the FTP transcript.
- GitHub Actions provides automatic deployment without needing local FTP tools.
