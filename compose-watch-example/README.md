# Docker Compose Watch Mode Guide

## Standard Development Workflow

### Build and Run (Production Mode)
```bash
# Build and start all services
docker compose up -d --build
```
**Benefits:**
- Rebuilds if Dockerfile changed
- Uses cache if nothing changed
- One command does everything

### Alternative: Separate Build Step
```bash
# Build first, then run (less preferred)
docker compose up -d
```
**Note:** Requires images to be available or manual build first

## Development with Watch Mode

### Switch to Watch Mode
```bash
# Activate file watching for live rebuilds
docker compose watch
```
**Features:**
- Runs on top of existing containers (no downtime)
- Automatically rebuilds on file changes
- Switches seamlessly from production mode

### Start with Watch Mode
```bash
# Start services with watch enabled (attached mode)
docker compose up --watch
```

## Profile-Based Development

### Using Development Profile
```bash
# Run services with development profile
docker compose --profile dev up -d

# Start watch mode with profile
docker compose --profile dev watch
```

## Monitoring and Debugging

### View Live Service Logs
```bash
# Watch logs for specific service
docker compose logs -f <service-name>

# Example: Monitor API service
docker compose logs -f api
```

### Container Status
```bash
# Check running containers
docker compose ps

# Stop watch mode
# Press Ctrl+C in watch terminal
```

## Command Summary

| Command | Purpose | Mode |
|---------|---------|------|
| `docker compose up -d --build` | Build and run services | Production |
| `docker compose watch` | Enable file watching | Development |
| `docker compose up --watch` | Start with watch enabled | Development |
| `docker compose logs -f <service>` | Monitor service logs | Debug |
