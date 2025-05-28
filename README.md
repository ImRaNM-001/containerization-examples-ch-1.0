# Containerization Examples

A comprehensive collection of Docker containerization examples for different programming languages and application types, demonstrating best practices for production-ready deployments.

## Project Structure

### Core Examples

**01-python-simple-app**
- Multi-stage Python Flask application with PostgreSQL integration
- Demonstrates Go binary execution within Python container
- Features database health checks and proper entrypoint scripts

**02-go-app**
- Go CLI calculator application with multi-stage build
- Uses scratch base image for minimal footprint
- Demonstrates static compilation and distroless deployment

**03-rust-app**
- Rust CLI TODO application with JSON persistence
- Multi-stage build with scratch final image
- Includes both CLI and web UI components

**04-python-fastapi-app**
- FastAPI application with optimized Alpine builds
- Multiple Dockerfile variants (standard, distroless)
- Non-root user execution and security hardening

**05-reactjs-app**
- Production-ready React application with Nginx
- Three-stage build: development, build, production
- Security headers, asset caching, and health checks

### Monitoring & Utilities

**healthcheck-monitoring**
- Docker health check implementation examples
- Demonstrates container health monitoring patterns
- Alpine-based Go application with curl health checks

## Key Features Demonstrated

### Multi-Stage Builds
- Separate build and runtime environments
- Minimal production image sizes
- Dependency isolation and optimization

### Security Best Practices
- Non-root user execution
- Security headers and token hiding
- Minimal attack surface with distroless/scratch images

### Performance Optimizations
- Layer caching strategies
- Asset compression and caching
- Build context optimization with .dockerignore

### Production Readiness
- Health check implementations
- Proper logging and monitoring
- Environment variable management
- Volume mounting for data persistence

## Build Examples

### Standard Build
```bash
# Build any application
cd <app-directory>
docker build -t <app-name> .
```

### Multi-Platform Build
```bash
# Build for multiple architectures
docker buildx build --platform linux/amd64,linux/arm64 -t <app-name> .
```

### Development vs Production
```bash
# Development build (with debugging tools)
docker build --target development -t <app-name>:dev .

# Production build (optimized)
docker build --target production -t <app-name>:prod .
```

## Image Size Comparisons

| Application | Standard Build | Optimized Build | Reduction |
|-------------|----------------|-----------------|-----------|
| Go Calculator | ~300MB | ~2MB | 99% |
| Rust TODO | ~500MB | ~5MB | 99% |
| Python FastAPI | ~175MB | ~50MB | 71% |
| React App | ~200MB | ~25MB | 87% |

## Technologies Covered

**Languages**: Python, Go, Rust, JavaScript/React
**Frameworks**: Flask, FastAPI, React, Nginx
**Databases**: PostgreSQL
**Tools**: Docker, Docker Compose, Health Checks
**Base Images**: Alpine, Scratch, Distroless

## Usage Patterns

### Single Container
```bash
docker run -d --name <container-name> -p <host-port>:<container-port> <image-name>
```

### Multi-Container with Compose
```bash
docker compose up -d --build
```

### With Volume Persistence
```bash
docker run -d -v <host-path>:<container-path> <image-name>
```

## Security Considerations

- All examples use non-root users where applicable
- Security headers implemented for web applications
- Secrets management through environment variables
- Minimal base images to reduce attack surface

## Best Practices Implemented

1. **Layer Optimization**: Proper ordering of Dockerfile instructions
2. **Cache Efficiency**: Strategic use of COPY commands and .dockerignore
3. **Security Hardening**: Non-root execution and minimal privileges
4. **Health Monitoring**: Built-in health checks for service reliability
5. **Environment Separation**: Clear development vs production configurations

## Contributing

Each example includes detailed README files with specific build instructions, architecture explanations, and usage examples. Review individual project documentation for detailed implementation details.
