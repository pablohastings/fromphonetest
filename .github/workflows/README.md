# GitHub Actions FTP Deployment

This workflow automatically deploys your site to your FTP server whenever you push to the `main` branch.

## Setup Instructions

You need to add your FTP credentials as GitHub Secrets:

1. Go to your GitHub repository: https://github.com/pablohastings/fromphonetest
2. Click on **Settings** tab
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click **New repository secret** and add each of these:

| Secret Name | Value |
|-------------|-------|
| `FTP_HOST` | `50.62.223.167` |
| `FTP_USER` | `phastings1972` |
| `FTP_PASSWORD` | Your FTP password |
| `FTP_REMOTE_DIR` | `/public_html/shapesstuff.com/ftptest` |

## How It Works

- Every push to `main` branch triggers automatic deployment
- You can also manually trigger deployment from the **Actions** tab → **Deploy to FTP** → **Run workflow**
- The workflow injects a build timestamp into `js/app.js` for verification
- Only relevant files are uploaded (git files, README, etc. are excluded)

## Testing

After setting up the secrets:

1. Make any change to your files
2. Commit and push to `main`
3. Go to the **Actions** tab in GitHub to watch the deployment
4. Visit your site to verify the deployment

The page should display the build timestamp showing when it was deployed.
