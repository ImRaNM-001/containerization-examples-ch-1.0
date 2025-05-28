###########################################
# BUILDER STAGE
###########################################
# Using a specific Go version on Alpine for a smaller builder image
FROM golang:1.22-alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY . .

# Build the Go app statically
# CGO_ENABLED=0 is good for scratch/minimal images.
# -ldflags="-w -s" can further reduce binary size by stripping debug info.
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags="-w -s" -o /app calculator.go


############################################
# FINAL STAGE
############################################
# scratch image is a choice if the app needs no OS features, it's the smallest.
FROM scratch 

WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app /app

# Set the entrypoint for the container to run the binary
ENTRYPOINT ["/app"]
