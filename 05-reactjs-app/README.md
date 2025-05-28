## Optimized React Application with Nginx

### Production-Ready Multi-Stage Docker Build

This project demonstrates a production-optimized React application deployment using a multi-stage Docker build with Nginx, security hardening, and performance optimizations.

### Project Structure

```
├── compose.yaml
├── Dockerfile
├── .dockerignore
├── .nginx
│   └── nginx.conf
├── package.json
├── public
│   ├── ...
│   └── robots.txt
├── README.md
├── src
│   ├── ...
│   └── App.js
└── .gitignore
```

### Multi-Stage Dockerfile Architecture

The Dockerfile uses three optimized stages:

1. **Development Stage**: Node.js environment for dependency installation
2. **Build Stage**: Compiles React application for production
3. **Production Stage**: Minimal Nginx Alpine image serving static files

### Key Features

- **Multi-stage build** for minimal production image size
- **Non-root user execution** for enhanced security
- **Security headers** (XSS protection, content type sniffing prevention)
- **React Router support** with fallback routing
- **Asset caching** with 1-year expiration for static files
- **Health checks** for container monitoring
- **Optimized dependencies** with npm ci for faster, reproducible builds

### Build and Deploy

#### Using Docker CLI

```bash
# Build the image
docker build -t react-nginx-app .

# Run the container
docker run -d --name react-app -p 8080:80 react-nginx-app

# Check container status
docker ps

# View logs
docker logs react-app
```

#### Using Docker Compose

[_compose.yaml_](compose.yaml)

```yaml
services:
  frontend:
    build:
      context: .
    container_name: frontend
    ports:
      - "80:80"
```

Deploy with docker compose:

```bash
docker compose up -d --build
```

### Build Process Example

```
Step 1/21 : FROM node:20-alpine AS development
 ---> 9153ee3e2ced
Step 2/21 : RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
 ---> Running in abc123def456
Step 3/21 : WORKDIR /app
 ---> Running in def456ghi789
...
Step 18/21 : COPY --from=build --chown=nginx:nginx /app/build /usr/share/nginx/html
 ---> Using cache
Step 19/21 : USER nginx
 ---> Using cache
Step 20/21 : HEALTHCHECK --interval=30s --timeout=3s CMD wget --spider http://127.0.0.1:80
 ---> Using cache
Step 21/21 : ENTRYPOINT ["nginx", "-g", "daemon off;"]
 ---> Using cache
Successfully built 6372a67cf86f
Successfully tagged react-nginx-app:latest
```

### Expected Result

After successful deployment, containers should show:

```bash
$ docker ps

CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS                    PORTS                 NAMES
b6d00a4974ce   react-nginx-app   "nginx -g 'daemon of…"   2 minutes ago    Up 2 minutes (healthy)   0.0.0.0:80->80/tcp   frontend
```

Navigate to http://localhost (or http://localhost:8080 if using custom port mapping) to view the application.

### Security Features

- **Non-root execution**: Application runs as nginx user (not root)
- **Security headers**: X-Frame-Options, X-Content-Type-Options, X-XSS-Protection
- **Server tokens disabled**: Nginx version information hidden
- **Minimal attack surface**: Alpine Linux base with only required packages

### Performance Optimizations

- **Static asset caching**: 1-year cache headers for CSS, JS, images
- **Gzip compression**: Automatic compression for text-based assets
- **Optimized layers**: Proper layer ordering for Docker build cache efficiency
- **Health checks**: Built-in container health monitoring

### Cleanup

Stop and remove containers:

```bash
# Using Docker CLI
docker stop react-app
docker rm react-app

# Using Docker Compose
docker compose down
```

Remove images:

```bash
docker rmi react-nginx-app
```

### Production Considerations

- Configure reverse proxy (e.g., Traefik, HAProxy) for SSL termination
- Use registry for image storage in production environments
- Implement log aggregation for container logs
- Consider using multi-platform builds for ARM64/AMD64 compatibility
