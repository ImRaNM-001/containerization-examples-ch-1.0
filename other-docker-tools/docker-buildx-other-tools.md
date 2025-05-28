# Docker CLI Tools and BuildX Documentation

## Docker Stats - Container Monitoring

### Live Container Statistics
Monitor real-time container resource usage with streaming output:

```bash
docker stats
```

**Sample Output:**
```
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O   PIDS 
64f75b8e1045   cont2     0.01%     20.52MiB / 957.4MiB   2.14%     14.9kB / 8.84kB   0B / 0B     2 
```

### Multi-Container Environment Example
Example output with multiple services running (FastAPI, React, Redis, PostgreSQL):

```
CONTAINER ID   NAME             CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
a1b2c3d4e5f6   fastapi_app      2.35%     120.5MiB / 2.0GiB     6.00%     1.2MB / 800kB     10MB / 5MB        15
b2c3d4e5f6g7   react_server     1.10%     95.3MiB / 2.0GiB      4.65%     1.5MB / 1.1MB     8MB / 4MB         10
c3d4e5f6g7h8   redis            0.65%     50.2MiB / 2.0GiB      2.51%     500kB / 600kB     3MB / 1MB         5
d4e5f6g7h8i9   postgres         3.80%     200.7MiB / 2.0GiB     10.04%    2.0MB / 1.8MB     12MB / 6MB        20
```

This output provides real-time metrics for each container, including CPU usage, memory consumption, network I/O, block I/O, and the number of processes (PIDs). The actual values will vary based on your system's workload and resource allocation.

### Static Output
Display one-time snapshot without continuous streaming:

```bash
docker stats --no-stream
```

---

## Docker BuildX - Multi-Platform Builds

### Overview
Docker BuildX is an advanced build command that extends Docker's native build capabilities with support for multiple architectures, advanced caching, and build optimization features.

**Documentation:** [Docker Buildx Official Docs](https://docs.docker.com/reference/cli/docker/buildx/)

### Creating and Managing Builders

#### Create New Builder Instance
```bash
docker buildx create --name flash --use
```
**Output:**
```
flash
```

#### List Available Builders
```bash
docker buildx ls
```
**Sample Output:**
```
NAME/NODE     DRIVER/ENDPOINT                   STATUS     BUILDKIT   PLATFORMS
flash*        docker-container                                        
 \_ flash0     \_ unix:///var/run/docker.sock   inactive              
default       docker                                                  
 \_ default    \_ default                       running    v0.21.0    linux/amd64 (+3), linux/386
```

**Legend:**
- `*` indicates the currently active builder
- `flash` uses docker-container driver (supports multi-platform)
- `default` uses docker driver (limited platform support)

### Multi-Platform Build Commands

#### Build for Multiple Architectures
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t <image-id> .
```

**Example with Image ID:**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t cb61cd51a319 .
```

**Example with Registry Image:**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t my-app .
```

#### Important Build Warnings
When using docker-container driver without output specification:

```
WARNING: No output specified with docker-container driver. Build result will only remain in the build cache. To push result image into registry use --push or to load image into docker use --load
```

**Solutions:**
- Use `--push` to push directly to registry
- Use `--load` to load image into local Docker daemon
- Use `--output type=docker` for local storage

### BuildX Performance Benefits

#### First Build vs Subsequent Builds
- **Initial build**: Takes several minutes (downloading base images, dependencies)
- **Subsequent builds**: Reduced to seconds due to advanced caching
- **Caching advantage**: BuildX provides superior caching mechanisms compared to regular docker build

#### Build Cache Optimization
BuildX uses advanced caching strategies:
- Layer-based caching
- Registry cache support
- Local cache persistence
- Cross-platform cache sharing

### Builder Management and Cleanup

#### Remove BuildX Resources

**Step 1: Remove BuildX Container firstly**
```bash
docker rm -f <buildx-container-id>
```

**Step 2: Then remove BuildKit Image**
```bash
# Using image ID
docker rmi <buildkit-image-id>

# Using image name and tag
docker rmi moby/buildkit:buildx-stable-1
```

### Builder Inspection and Verification

#### Check Active Builder Information
```bash
docker buildx inspect --bootstrap
```

**Sample Output:**
```
Name:          flash
Driver:        docker-container
Last Activity: 2025-05-28 08:29:47 +0000 UTC

Nodes:
Name:                  flash0
Endpoint:              unix:///var/run/docker.sock
Status:                running
BuildKit daemon flags: --allow-insecure-entitlement=network.host
BuildKit version:      v0.21.1
Platforms:             linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/386
Labels:
 org.mobyproject.buildkit.worker.executor:         oci
 org.mobyproject.buildkit.worker.hostname:         987c3ce94e0c
 org.mobyproject.buildkit.worker.network:          host
 org.mobyproject.buildkit.worker.oci.process-mode: sandbox
 org.mobyproject.buildkit.worker.selinux.enabled:  false
 org.mobyproject.buildkit.worker.snapshotter:      overlayfs
GC Policy rule#0:
 All:            false
 Filters:        type==source.local,type==exec.cachemount,type==source.git.checkout
 Keep Duration:  48h0m0s
 Max Used Space: 488.3MiB
GC Policy rule#1:
 All:            false
 Keep Duration:  1440h0m0s
 Reserved Space: 953.7MiB
 Max Used Space: 5.588GiB
 Min Free Space: 1.863GiB
GC Policy rule#2:
 All:            false
 Reserved Space: 953.7MiB
 Max Used Space: 5.588GiB
 Min Free Space: 1.863GiB
GC Policy rule#3:
 All:            true
 Reserved Space: 953.7MiB
 Max Used Space: 5.588GiB
 Min Free Space: 1.863GiB
```

### Best Practices

1. **Builder Selection**: Use docker-container driver for multi-platform builds
2. **Cache Management**: Leverage registry cache for team collaboration
3. **Resource Cleanup**: Regularly clean up unused builders and cache
4. **Platform Targeting**: Specify exact platforms needed to optimize build time
5. **Output Strategy**: Choose appropriate output method (push, load, or registry)

