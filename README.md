# AI Code API

A simple ASP.NET Core 9 Weather Forecast API with Docker support and CI/CD pipeline.

## Local Development

### Prerequisites
- .NET 9 SDK
- Visual Studio or Visual Studio Code
- Docker (optional, for containerized testing)

### Running Locally

```bash
cd AICodeAPI
dotnet run
```

The API will be available at `https://localhost:5001` (HTTPS) or `http://localhost:5000` (HTTP).

### API Endpoints

- **GET** `/weatherforecast` - Returns a 5-day weather forecast

### Example Request

```bash
curl https://localhost:5001/weatherforecast
```

Example Response:
```json
[
  {
	"date": "2025-01-15",
	"temperatureC": 25,
	"temperatureF": 77,
	"summary": "Warm"
  }
]
```

## Docker

### Build Docker Image

```bash
cd AICodeAPI
docker build -t aicode-api:latest .
```

### Run Docker Container

```bash
docker run -p 8080:8080 aicode-api:latest
```

The API will be available at `http://localhost:8080`.

### Health Check

```bash
curl http://localhost:8080/weatherforecast
```

## Deployment to Cloud

This project includes a GitHub Actions CI/CD pipeline that automatically builds, tests, and deploys your API to the cloud.

### Supported Cloud Platforms

1. **Render.com** (Free tier available)
2. **Railway.app** (Free tier available)
3. **Azure Container Instances** (Pay-as-you-go)

### Deployment Steps

#### Option 1: Deploy to Render.com

1. **Create Render Account**
   - Go to https://render.com
   - Sign up with GitHub account
   - Create a new Web Service

2. **Create Web Service**
   - Connect your GitHub repository
   - Select the repository containing this API
   - Set build command: `dotnet publish AICodeAPI/AICodeAPI.csproj -c Release -o ./publish`
   - Set start command: `./publish/AICodeAPI`
   - Choose a plan (free tier available)

3. **Configure GitHub Secrets**
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Add the following secrets:
	 - `RENDER_API_KEY`: Your Render API key (from Render dashboard)
	 - `RENDER_SERVICE_ID`: Your service ID (from Render dashboard URL)

4. **Deploy**
   - Push changes to `develop` or `main` branch
   - GitHub Actions will automatically build and deploy
   - Render provides a public URL (e.g., `https://aicode-api.onrender.com`)

#### Option 2: Deploy to Railway.app

1. **Create Railway Account**
   - Go to https://railway.app
   - Sign up with GitHub account

2. **Link Repository**
   - Go to Dashboard → New Project
   - Select "Deploy from GitHub repo"
   - Connect your GitHub repository

3. **Configure Environment**
   - Railway auto-detects .NET projects
   - No additional configuration needed for basic deployment

4. **Configure GitHub Secrets**
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Add: `RAILWAY_TOKEN`: Your Railway CLI token (from Railway dashboard)

5. **Deploy**
   - Push to `develop` or `main` branch
   - GitHub Actions automatically deploys
   - Railway provides a public URL

#### Option 3: Deploy to Azure Container Instances

1. **Create Azure Account**
   - Go to https://azure.microsoft.com
   - Create a free account (includes free credits)

2. **Create Container Registry**
   ```bash
   az acr create --resource-group myResourceGroup --name aicoderegsitry --sku Basic
   ```

3. **Configure GitHub Secrets**
   - Follow Azure documentation for GitHub Actions
   - Add: `AZURE_CREDENTIALS`: Your Azure service principal credentials

4. **Deploy**
   - Push to `develop` or `main` branch
   - GitHub Actions builds and deploys container
   - Azure provides a public URL

### Monitor Deployment

1. Go to your GitHub repository
2. Click "Actions" tab
3. Watch the workflow run in real-time
4. Once complete, visit your cloud provider's dashboard for the public API URL

### Environment Variables

The Docker container supports the following environment variables:

```bash
docker run -e ASPNETCORE_ENVIRONMENT=Production \
		   -e ASPNETCORE_URLS=http://+:8080 \
		   -p 8080:8080 aicode-api:latest
```

## Project Structure

```
AICodeAPI/
├── Controllers/          # API controllers
├── Program.cs            # Application startup
├── AICodeAPI.csproj      # Project file
├── Dockerfile            # Docker build configuration
├── .dockerignore          # Docker build exclusions
├── appsettings.json      # Configuration
└── Properties/
	└── launchSettings.json # Launch profiles
```

## GitHub Actions Workflow

The CI/CD pipeline (`.github/workflows/deploy.yml`):

1. **Trigger**: Automatically runs on push to `develop` or `main` branch
2. **Build**: Restores dependencies and builds the .NET project
3. **Test**: Runs any unit tests (if added)
4. **Publish**: Creates a release build
5. **Docker**: Builds Docker image
6. **Deploy**: Pushes to your configured cloud platform

### View Workflow Status

- GitHub Repository → Actions tab → Build and Deploy workflow

### Troubleshooting Workflow

If the workflow fails:
1. Click the failed workflow run
2. Expand "Build" or "Deploy" job to see logs
3. Common issues:
   - Missing GitHub Secrets (check cloud platform credentials)
   - Incorrect project path
   - .NET dependencies not available

## Adding Features

### Add Database Support

Update `Program.cs` to add Entity Framework Core:

```bash
cd AICodeAPI
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
```

### Add Authentication

```bash
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
```

### Add CORS

```csharp
// In Program.cs
builder.Services.AddCors(options =>
{
	options.AddPolicy("AllowAll", builder =>
	{
		builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
	});
});

app.UseCors("AllowAll");
```

## Production Considerations

- ✅ API runs on port 8080 (configurable)
- ✅ HTTPS/SSL handled by cloud platform
- ✅ Health checks configured in Docker
- ✅ Automatic rebuilds on code push via GitHub Actions
- ⚠️ Stateless design - no persistent storage (add database for persistence)
- ⚠️ Scalability - configure auto-scaling in your cloud provider

## License

MIT License - Feel free to use this template for your projects.

## Support

For issues or questions:
1. Check GitHub Actions logs
2. Review cloud provider documentation
3. Check application logs in cloud provider dashboard

---

**Public API URL**: (Will be provided by cloud platform after deployment)
