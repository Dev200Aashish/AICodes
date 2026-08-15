# Render.com Deployment Guide

## Quick Start (5-10 minutes)

### 1. Create Render Account

1. Go to https://render.com
2. Click "Get Started" (top right)
3. Sign up with your GitHub account
   - Accept the permission prompt to connect GitHub
   - Select the GitHub account with your API repository
4. You're now in the Render dashboard

### 2. Create a New Web Service

1. In Render dashboard, click **"New +"** button (top right)
2. Select **"Web Service"**
3. Choose your GitHub repository:
   - Search for "AICodes" or your repository name
   - Click **Connect**
4. Fill in the configuration:

   **Basic Settings:**
   - Name: `aicode-api`
   - Region: `Oregon (US West)` (or your preferred region)
   - Branch: `develop` (or `main`)
   - Root Directory: `AICodeAPI` (important!)

   **Build & Deploy Settings:**
   - Runtime: `Docker`
   - Build Command: (leave empty - uses Dockerfile)
   - Start Command: (leave empty - uses Dockerfile)

5. **Choose Plan:**
   - Free ($0/month) - Perfect for testing
   - Standard ($7/month) - For small production apps

6. Click **"Create Web Service"**

### 3. Monitor Deployment

After clicking "Create Web Service":

1. Render automatically starts building your Docker image
2. Watch the deployment progress in real-time:
   - See logs as Dockerfile builds
   - View build status and any errors
3. Once "Your service is live" appears, you have a public URL!

Example: `https://aicode-api.onrender.com`

### 4. Test Your API

Once deployed, test your live API:

```bash
# Get weather forecast
curl https://aicode-api.onrender.com/weatherforecast

# Or open in browser
https://aicode-api.onrender.com/weatherforecast
```

## Automatic Deployments

With this setup, deployments happen automatically:

1. You push code to `develop` or `main` branch
2. GitHub Actions workflow triggers
3. Render detects the new commit
4. Docker image rebuilds automatically
5. Service restarts with new code

**No additional configuration needed!** Render watches your GitHub repository for changes.

## Configure GitHub Secrets (Optional)

If you want to manually trigger deployments from GitHub Actions:

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Create these secrets:
   ```
   RENDER_API_KEY=<your-render-api-key>
   RENDER_SERVICE_ID=srv_xxxxxxxxxxxxxxx
   ```

### Where to find these values:

- **RENDER_API_KEY**: 
  1. Go to Render Account Settings
  2. Click "API Keys" in left sidebar
  3. Create a new API key
  4. Copy and paste into GitHub secret

- **RENDER_SERVICE_ID**:
  1. Go to your Web Service page
  2. Look at the URL: `https://dashboard.render.com/web/srv_xxxxx`
  3. Copy the `srv_xxxxx` part

**Then uncomment the Render deployment lines in `.github/workflows/deploy.yml`**

## Monitor Logs

### In Render Dashboard:

1. Click your service (`aicode-api`)
2. Click **"Logs"** tab
3. See real-time application output
4. Helpful for debugging issues

### In GitHub Actions:

1. Go to your GitHub repository
2. Click "Actions" tab
3. Click the latest "Build and Deploy" workflow
4. Click "Build" or "Deploy" job to see logs

## Environment Variables (Optional)

To add environment variables to your running application:

1. Go to your Render Web Service
2. Click **"Environment"** tab
3. Click **"Add Environment Variable"**
4. Examples:
   ```
   ASPNETCORE_ENVIRONMENT=Production
   LOG_LEVEL=Information
   ```
5. Save - service automatically restarts

## Free Tier Limitations

Render.com Free tier includes:

- ✅ Automatic deployments
- ✅ Custom domain support
- ✅ GitHub integration
- ✅ Health checks
- ✅ Environment variables
- ✅ Logs and monitoring
- ⚠️ Auto-spins down after 15 minutes of inactivity (need to click "Wake up" or upgrade)
- ⚠️ Limited compute resources

**Recommended for**: Testing, demos, personal projects

**For production**: Upgrade to Standard ($7/month) for 24/7 uptime

## Troubleshooting

### Build fails with Docker error

1. Check the Logs in Render dashboard
2. Verify your Dockerfile uses correct paths
3. Ensure `AICodeAPI` is specified in Root Directory setting
4. Re-deploy by clicking Dashboard → "Manual Deploy" → "Deploy latest commit"

### Service shows "Deploy failed"

1. Click on the service → Logs
2. Look for error messages
3. Common issues:
   - Port configuration (must use 8080 in Dockerfile) ✅ Already configured
   - Missing dependencies (dotnet restore) ✅ Already in Dockerfile
   - Incorrect project path

### Getting 502 Bad Gateway

1. Ensure application is running on port 8080
2. Check Logs tab for crashes
3. Verify health check endpoint (`/weatherforecast` in this case)
4. Wait 2-3 minutes for deployment to fully stabilize

### Application spins down (Free tier)

- Click "Wake up" button to restart
- Or upgrade to Standard plan ($7/month)

## Next Steps

### 1. **Get Your Public URL**
   - Render provides: `https://aicode-api.onrender.com`
   - Share with anyone who needs access

### 2. **Add Custom Domain** (Optional)
   1. Go to Web Service → Settings → Custom Domain
   2. Enter your domain (e.g., `api.example.com`)
   3. Update DNS records as shown by Render
   4. Wait for SSL certificate (few minutes)

### 3. **Scale Up** (Optional)
   - Upgrade plan for more CPU/RAM
   - Configure auto-scaling if available on your plan

### 4. **Add Database** (If needed later)
   - Render offers PostgreSQL, MySQL, etc.
   - Create a new database in Render dashboard
   - Add connection string as environment variable
   - Update your .NET application to use database

## Example: Testing Live API

Once your service shows "Your service is live":

```bash
# PowerShell
$url = "https://aicode-api.onrender.com/weatherforecast"
Invoke-WebRequest -Uri $url | ConvertFrom-Json | Format-Table

# Bash
curl -s https://aicode-api.onrender.com/weatherforecast | jq .
```

## Support & Documentation

- Render Help: https://render.com/docs
- GitHub Actions: https://docs.github.com/actions
- .NET Deployment: https://learn.microsoft.com/en-us/dotnet/core/deploying/

---

**Your API is now globally accessible! 🚀**

Share your public URL with teammates, integrate with frontend apps, or expose APIs for integration.
