# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy project file
COPY ["AICodeAPI.csproj", "./"]

# Restore dependencies
RUN dotnet restore "AICodeAPI.csproj"

# Copy source code
COPY . .

# Build the application
RUN dotnet build "AICodeAPI.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "AICodeAPI.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy published application from publish stage
COPY --from=publish /app/publish .

# Expose port 8080 (default for cloud platforms)
EXPOSE 8080

# Set environment for production
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
	CMD curl -f http://localhost:8080/weatherforecast || exit 1

# Start the application
ENTRYPOINT ["dotnet", "AICodeAPI.dll"]
