# Infrastructure & Architecture Overview

## Complete Deployment Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                     LOCAL DEVELOPMENT                                │
│                                                                       │
│  Visual Studio / VSCode                                             │
│  ├─ Edit code                                                        │
│  ├─ Test locally                                                     │
│  ├─ Build & debug                                                    │
│  └─ Commit to Git                                                    │
└──────────────────────────┬──────────────────────────────────────────┘
						   │
						   │ git push
						   ↓
┌─────────────────────────────────────────────────────────────────────┐
│                   GITHUB REPOSITORY                                  │
│  https://github.com/Dev200Aashish/AICodes                          │
│                                                                       │
│  Branches:                                                            │
│  ├─ develop (active)                                                 │
│  └─ main                                                             │
│                                                                       │
│  Files:                                                              │
│  ├─ AICodeAPI/Program.cs (Your API code)                            │
│  ├─ AICodeAPI/Dockerfile (Container config)                         │
│  ├─ .github/workflows/deploy.yml (CI/CD pipeline)                   │
│  └─ .gitignore (Exclude build artifacts)                            │
└──────────────────────────┬──────────────────────────────────────────┘
						   │
						   │ Webhook trigger
						   ↓
┌─────────────────────────────────────────────────────────────────────┐
│              GITHUB ACTIONS (CI/CD Pipeline)                         │
│  https://github.com/Dev200Aashish/AICodes/actions                  │
│                                                                       │
│  Runs on: ubuntu-latest                                              │
│                                                                       │
│  Step 1: Checkout Code                                              │
│  └─ Clone repository                                                │
│                                                                       │
│  Step 2: Setup .NET 9                                               │
│  └─ Install .NET SDK                                                │
│                                                                       │
│  Step 3: Restore Dependencies                                       │
│  └─ Download NuGet packages                                         │
│                                                                       │
│  Step 4: Build                                                       │
│  └─ Compile C# code to IL                                           │
│                                                                       │
│  Step 5: Test                                                        │
│  └─ Run unit tests (if any)                                         │
│                                                                       │
│  Step 6: Publish                                                     │
│  └─ Create release build                                            │
│                                                                       │
│  Step 7: Build Docker Image                                         │
│  └─ Multi-stage build:                                              │
│     ├─ Stage 1: SDK 9.0 (compile)                                   │
│     ├─ Stage 2: Publish (create release)                            │
│     └─ Stage 3: Runtime 9.0 (minimal image)                         │
│                                                                       │
│  Output: Docker image ready for deployment                          │
└──────────────────────────┬──────────────────────────────────────────┘
						   │
						   │ Repository changed
						   ↓
┌─────────────────────────────────────────────────────────────────────┐
│                   RENDER.COM DASHBOARD                               │
│  https://dashboard.render.com                                       │
│                                                                       │
│  Detects:                                                            │
│  ├─ New commit in GitHub repo                                       │
│  ├─ Webhook notification                                            │
│  └─ Triggers automatic deployment                                   │
│                                                                       │
│  Builds:                                                             │
│  ├─ Pulls Dockerfile from GitHub                                    │
│  ├─ Runs multi-stage build                                          │
│  ├─ Creates optimized Docker image                                  │
│  └─ Pushes to Render registry                                       │
│                                                                       │
│  Deploys:                                                            │
│  ├─ Spins up new container instance                                │
│  ├─ Configures network (port 8080)                                  │
│  ├─ Starts application                                              │
│  ├─ Runs health checks                                              │
│  └─ Terminates old container                                        │
│                                                                       │
│  Provides:                                                           │
│  ├─ Public URL (e.g., https://aicode-api.onrender.com)             │
│  ├─ SSL/TLS certificate (automatic)                                │
│  ├─ Load balancing                                                  │
│  └─ Auto-scaling (if configured)                                    │
└──────────────────────────┬──────────────────────────────────────────┘
						   │
						   ↓
┌─────────────────────────────────────────────────────────────────────┐
│              🌐 PUBLIC API (Internet Accessible)                    │
│                                                                       │
│  URL: https://aicode-api.onrender.com                              │
│                                                                       │
│  Endpoints:                                                          │
│  ├─ GET /weatherforecast                                            │
│  └─ (Add more endpoints in Program.cs)                              │
│                                                                       │
│  Features:                                                           │
│  ├─ Global CDN                                                       │
│  ├─ Automatic SSL/TLS                                               │
│  ├─ Health monitoring                                               │
│  ├─ Auto-restart on failure                                         │
│  └─ Logs & metrics                                                  │
│                                                                       │
│  Access from:                                                        │
│  ├─ Frontend applications (React, Vue, etc.)                        │
│  ├─ Mobile apps (iOS, Android)                                      │
│  ├─ Desktop applications                                            │
│  ├─ Other backend services                                          │
│  ├─ CLI tools (curl, wget)                                          │
│  └─ Browser (for GET endpoints)                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Deployment Flow

```
┌─────────────────────────┐
│  You Push Code to Git   │
│   git push origin       │
│      develop            │
└────────────┬────────────┘
			 │
			 ↓ (1 sec delay)
┌─────────────────────────────────────────────┐
│  GitHub Webhook Triggered                   │
│  - Notification sent to Render              │
│  - GitHub Actions triggered                 │
│  - Workflow starts building                 │
└────────────┬────────────────────────────────┘
			 │
			 ↓ (5-10 seconds)
┌──────────────────────────────────────────────────────┐
│  GitHub Actions: Build Job                          │
│  ├─ Restore NuGet packages        (~30 sec)         │
│  ├─ Compile .NET code             (~1-2 min)        │
│  ├─ Run tests                      (~30 sec)        │
│  ├─ Publish release                (~30 sec)        │
│  └─ Build Docker image             (~2-3 min)       │
│                                                      │
│  Total: 2-5 minutes (first time takes longer)      │
└────────────┬─────────────────────────────────────────┘
			 │
			 ↓ (when Build completes)
┌──────────────────────────────────────────────────────┐
│  Render.com: Deploy Job                             │
│  ├─ Pull Docker image              (~30 sec)        │
│  ├─ Start container                (~15 sec)        │
│  ├─ Run health checks              (~10 sec)        │
│  ├─ Attach to load balancer        (~10 sec)        │
│  └─ Stop old container             (~5 sec)         │
│                                                      │
│  Total: 1-2 minutes                                 │
└────────────┬─────────────────────────────────────────┘
			 │
			 ↓
┌──────────────────────────────────────────────────────┐
│  ✅ API LIVE & UPDATED                              │
│                                                      │
│  Timeline from push to live:                        │
│  └─ 5-10 minutes total                              │
│                                                      │
│  New code accessible at:                            │
│  └─ https://aicode-api.onrender.com               │
└──────────────────────────────────────────────────────┘
```

## Data Flow

```
CLIENT REQUEST
	│
	↓
https://aicode-api.onrender.com/weatherforecast
	│
	↓ (over internet)
┌──────────────────────┐
│ Render CDN/LB        │
│ (SSL/TLS)            │
└──────┬───────────────┘
	   │
	   ↓ (route to container)
┌──────────────────────────────────────┐
│ Docker Container                     │
│                                      │
│ ├─ ASP.NET Core 9 Runtime            │
│ │  ├─ Program.cs                     │
│ │  ├─ Controllers                    │
│ │  └─ Services                       │
│ │                                    │
│ └─ Listening on port 8080            │
│    (mapped from 443 via reverse proxy)│
└──────┬───────────────────────────────┘
	   │
	   ↓ (HTTP on localhost:8080)
┌──────────────────────────────────┐
│ GET /weatherforecast Handler     │
│                                  │
│ ├─ Receive request               │
│ ├─ Generate weather data         │
│ ├─ Serialize to JSON             │
│ └─ Return HTTP 200 OK            │
└──────┬──────────────────────────┘
	   │
	   ↓ (response JSON)
┌──────────────────────────────────────────────┐
│ HTTP Response (200 OK)                       │
│                                              │
│ Content-Type: application/json               │
│                                              │
│ [                                            │
│   {"date":"2025-01-15","temperatureC":25}, │
│   {...},                                     │
│   {...}                                      │
│ ]                                            │
└──────┬───────────────────────────────────────┘
	   │
	   ↓ (over internet)
┌──────────────────────┐
│ Client Application   │
│ (Browser/App)        │
│                      │
│ Receives response    │
│ Displays data        │
└──────────────────────┘
```

## Component Dependencies

```
Visual Studio
	│
	├─→ .NET 9 SDK
	│   └─→ C# compiler
	│   └─→ NuGet packages
	│
	└─→ Git Client
		└─→ GitHub repository

GitHub Repository
	│
	├─→ .github/workflows/deploy.yml
	│   └─→ GitHub Actions Runner
	│       ├─→ .NET 9 SDK (installed in workflow)
	│       ├─→ Docker CLI (installed in runner)
	│       └─→ Ubuntu OS (ubuntu-latest)
	│
	├─→ AICodeAPI/Dockerfile
	│   ├─→ mcr.microsoft.com/dotnet/sdk:9.0 (build stage)
	│   ├─→ mcr.microsoft.com/dotnet/aspnet:9.0 (runtime)
	│   └─→ Source code (AICodeAPI folder)
	│
	└─→ .gitignore
		└─→ Excludes: bin/, obj/, .vs/, .env, etc.

Render.com
	│
	├─→ GitHub Webhook
	│   └─→ Auto-deploy on push
	│
	├─→ Docker Registry
	│   └─→ Stores built images
	│
	├─→ Container Runtime
	│   └─→ Runs Docker container
	│
	├─→ Load Balancer
	│   └─→ HTTPS/SSL termination
	│       └─→ Routes to port 8080
	│
	└─→ Networking
		└─→ Public IP/DNS
			└─→ https://aicode-api.onrender.com
```

## Environment Layers

```
┌─────────────────────────────────────────────────────┐
│           DEVELOPMENT (Your Machine)               │
│                                                    │
│  - Local Visual Studio                            │
│  - Local Git repo                                 │
│  - Debug configuration                           │
│  - launchSettings.json (not committed)            │
│  - HTTPS on localhost:5001                        │
│  - HTTP on localhost:5000                         │
└─────────────────────────────────────────────────────┘
						│
						│ Push to GitHub
						↓
┌─────────────────────────────────────────────────────┐
│         BUILD ENVIRONMENT (GitHub Actions)          │
│                                                    │
│  - Ubuntu Linux runner                            │
│  - .NET 9 SDK (installed by workflow)              │
│  - Docker CLI (pre-installed)                      │
│  - Temporary file system                          │
│  - Compilation mode: Release                      │
│  - Framework: net9.0                              │
└─────────────────────────────────────────────────────┘
						│
						│ Build succeeds
						↓
┌─────────────────────────────────────────────────────┐
│       PRODUCTION ENVIRONMENT (Render.com)           │
│                                                    │
│  - Docker container (based on aspnet:9.0)         │
│  - ASP.NET Core Runtime only (SDK not included)   │
│  - Configuration: Release                         │
│  - Framework: net9.0                              │
│  - Port: 8080 (internal)                          │
│  - Environment variables: Production              │
│  - Health checks enabled                          │
│  - Auto-restart on failure                        │
│  - HTTPS/SSL via Render proxy                     │
└─────────────────────────────────────────────────────┘
						│
						│ Container running
						↓
┌─────────────────────────────────────────────────────┐
│        PUBLIC INTERNET (Client Access)              │
│                                                    │
│  - HTTPS only (TLS 1.2+)                          │
│  - Custom domain or Render subdomain              │
│  - CDN acceleration                               │
│  - DDoS protection                                │
│  - Global accessibility                           │
│  - Rate limiting (per Render plan)                │
└─────────────────────────────────────────────────────┘
```

## Docker Image Layers

```
┌─────────────────────────────────────────────────────┐
│         FINAL DOCKER IMAGE (runtime stage)          │
│                                                     │
│  Layer 1: Base Image                               │
│  ├─ mcr.microsoft.com/dotnet/aspnet:9.0           │
│  ├─ Debian Linux                                   │
│  ├─ .NET 9 Runtime                                │
│  └─ ~200 MB                                        │
│                                                    │
│  Layer 2: System Package                          │
│  ├─ curl (for health checks)                      │
│  └─ ~5 MB                                         │
│                                                    │
│  Layer 3: Application Files                       │
│  ├─ AICodeAPI.dll                                 │
│  ├─ appsettings.json                              │
│  ├─ All .NET assemblies                           │
│  └─ ~50 MB                                        │
│                                                    │
│  Total Image Size: ~250-300 MB                    │
│                                                    │
│  (SDK stage not included = much smaller than if   │
│   we shipped entire SDK!)                         │
└─────────────────────────────────────────────────────┘
```

## Scaling Considerations

### Current Free Tier Setup

```
┌──────────────────────────────────┐
│  Single Container Instance       │
│                                  │
│  - 0.5 CPU cores                │
│  - 512 MB RAM                    │
│  - 100 GB/month bandwidth        │
│  - Auto-stops after 15 min idle  │
│  - Good for: Development, demos  │
│                                  │
│  Max requests/minute: ~100-500   │
│  (depending on endpoint logic)    │
└──────────────────────────────────┘
```

### Upgrade to Standard Plan ($7/month)

```
┌──────────────────────────────────┐
│  Single Container Instance       │
│                                  │
│  - 1 CPU core                    │
│  - 512 MB RAM                    │
│  - 100 GB/month bandwidth        │
│  - 24/7 uptime                   │
│  - Good for: Small production     │
│                                  │
│  Max requests/minute: ~1000+     │
│  (better performance)            │
└──────────────────────────────────┘
```

### For High Traffic

```
┌──────────────────────────────────────────┐
│  Multiple Container Instances            │
│  (via Render Professional)               │
│                                          │
│  - Multiple instances                    │
│  - Load balancer                         │
│  - Auto-scaling                          │
│  - Dedicated database                    │
│  - Custom monitoring                     │
│                                          │
│  Cost: ~$25-100+/month                   │
│  Performance: Enterprise-grade           │
└──────────────────────────────────────────┘
```

---

## Security Architecture

```
┌─────────────────────────────────────────────────────┐
│                 SECURITY LAYERS                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Layer 1: Transport Security                       │
│  └─ HTTPS/TLS 1.2+ enforced by Render             │
│                                                    │
│  Layer 2: Container Isolation                      │
│  └─ Docker container isolated from host OS        │
│  └─ Read-only filesystem where possible           │
│  └─ Limited capabilities                          │
│                                                    │
│  Layer 3: Network Isolation                        │
│  └─ Private network for database (if added)       │
│  └─ Public API endpoint only for HTTP/HTTPS       │
│  └─ No SSH or direct container access             │
│                                                    │
│  Layer 4: Secret Management                        │
│  └─ GitHub Secrets for API keys/tokens            │
│  └─ Render environment variables encrypted        │
│  └─ Never committed to Git (via .gitignore)      │
│                                                    │
│  Layer 5: Access Control                          │
│  └─ GitHub branch protection (optional)           │
│  └─ Required reviews before merge                 │
│  └─ Audit logs for all deployments                │
│                                                    │
│  Layer 6: Monitoring & Logging                     │
│  └─ GitHub Actions logs (6 months retention)      │
│  └─ Render application logs                       │
│  └─ Render resource monitoring                    │
│                                                    │
└─────────────────────────────────────────────────────┘
```

---

This architecture ensures:
- ✅ Automatic updates on code push
- ✅ Isolated, containerized environment
- ✅ Scalable from free to enterprise
- ✅ Secure credential management
- ✅ Full visibility and monitoring
- ✅ Fast, reliable deployments
