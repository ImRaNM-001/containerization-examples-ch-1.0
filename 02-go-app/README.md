# Multi Stage Docker Build

The main purpose of choosing a golang based application to demonstrate this example is that Go is a statically-typed programming language that does not require a runtime in the traditional sense. Unlike dynamically-typed languages like Python, Ruby, and JavaScript, which rely on a runtime environment to execute their code, Go compiles directly to machine code, which can then be executed directly by the operating system.

So the real advantage of multi-stage Docker builds and distroless images can be understood with a drastic decrease in the image size.

---

## Build and Run Instructions

**To Build the Image:**
```sh
docker build -t <image-name>:latest .

ex: docker build -t calc-app:latest .
```

**To List Images:**
```sh
docker images | grep <image-name>
```

**To Run the Image (with interactive input):**
```sh
docker run -it --name <container-name> <image-id>
```

---

## Dockerfile Explanation

This project uses a multi-stage Docker build to create a minimal container image for a Go CLI calculator app. The final image uses the `scratch` base, which is the smallest possible image, containing only the statically compiled Go binary and nothing else.

### Builder Stage
- Uses `golang:1.22-alpine` for a small build environment.
- Sets the working directory to `/app`.
- Copies all source files into the container.
- Builds the Go app statically with:
  - `CGO_ENABLED=0` for static linking (required for `scratch` base).
  - `-ldflags="-w -s"` to strip debug info and reduce binary size.
  - Output binary is `/app` built from `calculator.go`.

### Final Stage
- Uses `FROM scratch` for a minimal, secure image.
- Sets the working directory to `/app`.
- Copies the compiled binary from the builder stage.
- Sets the entrypoint to run the binary.

> **Note:**
> - No port is exposed, as the calculator app is a CLI tool and does not listen on a network port.
> - Running as a non-root user is not possible with `scratch` (no user management tools). If you need non-root, use `alpine` as the final stage.

---

## Application Usage

When you run the container interactively, you will see:
```
This is a simple calculator app written in Go Lang..
Enter any calculation (Example: 1 + 2 (or) 2 * 5 -> Maintain spaces as shown in example):
```
- Enter calculations in the format: `number operator number` (e.g., `3 + 4` or `10 * 5`).
- To exit, type `exit` and press Enter.
- If the input is invalid, the app will prompt you to try again.

---

## Security and Optimization Notes
- The final image is extremely small and contains only the application binary.
- No shell or package manager is present in the final image, reducing the attack surface.
- If you need to run as a non-root user, use `alpine` as the final stage and add user creation steps.
- Use a `.dockerignore` file to avoid copying unnecessary files into the build context.

---

**Docker file with detailed comments:**
```sh
###########################################
# BUILDER STAGE
###########################################
# Using a specific Go version on Alpine for a smaller builder image
FROM golang:1.22-alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Install build dependencies (if any beyond Go itself)
# For a typical Go build, Alpine base often has what's needed, ex: if you need git
# RUN apk add --no-cache git

# Copy the source code into the container
COPY . .

# Build the Go app statically
# CGO_ENABLED=0 is good for scratch/minimal images.
# -ldflags="-w -s" can further reduce binary size by stripping debug info.
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags="-w -s" -o /app calculator.go

############################################
# FINAL STAGE
############################################
# Use a minimal base image like Alpine if shell or basic utilities are needed        
# or want to run as a non-root user easily.
# scratch is a choice if the app needs no OS features, it's the smallest.
# FROM alpine:latest
FROM scratch 

# Create a non-root user and group, although this step is not applicable if using FROM scratch directly, as scratch has no user management and the binary runs as root (UID 0) by default.
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app /app

# If using alpine and created a non-root user:
# Ensure the binary is executable by the user (usually by default, but good to be aware)
# RUN chown appuser:appgroup /app
# USER appuser

# Set the entrypoint for the container to run the binary
ENTRYPOINT ["/app"]

# Optional: Expose port if application listens on one
# EXPOSE 8080

```
