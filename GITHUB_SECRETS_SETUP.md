# GitHub Secrets Configuration Guide

## Why GitHub Secrets?

GitHub Secrets allow you to store sensitive credentials (API keys, tokens) securely in GitHub Actions without exposing them in code or logs.

## Setting Up GitHub Secrets for Render Deployment

### Step 1: Create Render API Key

1. Go to https://render.com/account/api-tokens
2. Click **"Create API Token"**
3. Enter a name: `GitHub-Deployment`
4. Copy the generated token (save it temporarily)
5. This is your `RENDER_API_KEY`

### Step 2: Get Your Service ID

1. Go to your Render dashboard
2. Click your `aicode-api` service
3. Look at the page URL: `https://dashboard.render.com/web/srv_xxxxxxxxxxxxxxx`
4. Copy the service ID: `srv_xxxxxxxxxxxxxxx`

### Step 3: Add Secrets to GitHub

1. Go to your GitHub repository: https://github.com/Dev200Aashish/AICodes
2. Click **Settings** (top tab)
3. Click **"Secrets and variables"** (left sidebar)
4. Click **"Actions"**
5. Click **"New repository secret"**

**Add Secret 1: RENDER_API_KEY**
- Name: `RENDER_API_KEY`
- Value: (Paste the API token from Step 1)
- Click **"Add secret"**

**Add Secret 2: RENDER_SERVICE_ID**
- Name: `RENDER_SERVICE_ID`
- Value: `srv_xxxxxxxxxxxxxxx` (from Step 2)
- Click **"Add secret"**

### Step 4: Verify Secrets in GitHub Actions

Once added, your secrets appear in Settings → Secrets and variables → Actions

✅ They're now available to your GitHub Actions workflow!

## Using Secrets in GitHub Actions Workflow

The `.github/workflows/deploy.yml` file uses secrets like this:

```yaml
- name: Deploy to Render
  run: |
	curl -X POST https://api.render.com/deploy/srv-${{ secrets.RENDER_SERVICE_ID }}?key=${{ secrets.RENDER_API_KEY }}
```

The `${{ secrets.SECRET_NAME }}` syntax replaces the secret value at runtime, keeping credentials out of logs.

## Important Security Notes

⚠️ **Never commit secrets to GitHub!**
- Secrets are masked in GitHub Actions logs (appear as `***`)
- Only visible to repository maintainers in Settings
- Actions cannot read each other's secrets
- Secrets are never exposed in workflow files

✅ **Best Practices:**
- Use unique API keys per service/environment
- Rotate API keys periodically
- Delete old/unused secrets
- Don't share secrets via email/chat
- Use branch protection to prevent accidental leaks

## Checking if Setup is Correct

### Via GitHub:

1. Go to your repository → Settings → Secrets and variables → Actions
2. You should see:
   - ✅ `RENDER_API_KEY`
   - ✅ `RENDER_SERVICE_ID`

### Via GitHub Actions:

1. Go to your repository → Actions tab
2. Click the latest "Build and Deploy" workflow
3. Click the "Deploy" job
4. If secrets are configured correctly, you'll see:
   ```
   Deploy to Render (Option 1)
   Run curl -X POST https://api.render.com/deploy/srv-***?key=***
   ✅ Deployment initiated
   ```

The `***` indicates secrets are being masked (expected behavior).

## If Deployment Fails

### Check the workflow logs:

1. Repository → Actions → "Build and Deploy" workflow
2. Click the failed run
3. Expand "Deploy" job
4. Look for errors like:
   - `401 Unauthorized` → Wrong API key
   - `404 Not Found` → Wrong service ID
   - `422 Unprocessable Entity` → Invalid service ID format

### Fix and retry:

1. Go back to GitHub Settings → Secrets
2. Verify the correct values
3. Update if needed
4. Re-run the workflow: Actions → "Build and Deploy" → "Re-run jobs"

## Environment-Specific Secrets (Advanced)

You can have different secrets per environment:

```yaml
# For develop branch
env:
  RENDER_API_KEY: ${{ secrets.RENDER_API_KEY_DEV }}
  RENDER_SERVICE_ID: ${{ secrets.RENDER_SERVICE_ID_DEV }}
```

For now, we use single secrets for simplicity.

## Next Steps

1. ✅ Add secrets to GitHub (this guide)
2. ✅ Verify secrets appear in Settings
3. Uncomment Render deployment lines in `.github/workflows/deploy.yml` (optional - auto-deploy works fine)
4. Push a test commit to trigger the workflow
5. Watch GitHub Actions → Actions tab for real-time deployment

## Troubleshooting

**Q: I don't see my secrets in Settings**
- A: Wait a few seconds and refresh the page

**Q: My GitHub Actions shows "Deployment initiated" but nothing happens in Render**
- A: Render auto-detects GitHub pushes and redeploys automatically
- You may not need manual GitHub Actions deployment
- Check Render dashboard → Deploys tab for status

**Q: Can I test the secrets?**
- A: Yes, but be careful not to expose them!
- GitHub masks secrets in logs automatically
- If a secret appears in plain text in logs, rotate it immediately!

---

With secrets configured, your GitHub Actions workflow can now securely deploy to Render! 🔐
