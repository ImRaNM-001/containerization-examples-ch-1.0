# Containerized a simple Rust TODO Application

This project demonstrates a simple command-line TODO application written in Rust and dockerized.

## Features

- Basic TODO functionality: add, list, complete, and delete tasks
- Persistent JSON storage for tasks
- Containerized using Docker
- Kubernetes deployment using Helm charts

## Local Development

### Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) (1.70 or newer)
- [Docker](https://docs.docker.com/get-docker/) (optional, for containerization)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (optional, for Kubernetes deployment)
- [Helm](https://helm.sh/docs/intro/install/) (optional, for Kubernetes deployment)

### Building the Application

1. Build the application:
```bash
cargo build --release
```

2. Run the application locally:
```bash
./target/release/rust-todo list
```

3. The application supports the following commands:

```bash
# Add a new task
./target/release/rust-todo add "Buy groceries"

# List all tasks
./target/release/rust-todo list

# Mark a task as completed (where 1 is the task number)
./target/release/rust-todo complete 1

# Delete a task (where 1 is the task number)
./target/release/rust-todo delete 1
```

### Running Tests

```bash
cargo test
```

### Running Static Analysis

```bash
# Check formatting
cargo fmt --check

# Run clippy
cargo clippy -- -D warnings
```

### Docker Build & usage:

To build the application (as a multi-stage build) and run as Docker container:

```bash
# (a) Build the Docker image
docker build -t rust-todo-app:latest .
```

```bash
# (b) Create a volume so that data persist between runs
docker volume create todo-list-volm
```

```bash
# (c) See list of available volumes
docker volume ls
```

```bash
# (d) Mount the created volume while creating a container to persist data between runs
docker run --rm --name todo-app --mount source=todo-list-volm,target=/app/data <image-id> add "Buy groceries"

Task added successfully!

or,     

# if -v flag is used
docker run --rm --name todo-app -v $(pwd)/data:/app/data <image-id> add "Read a Rust book"
```

```bash
# (e) List the tasks created by the container i.e, run the container with the list command
docker run --rm --mount source=todo-list-volm,target=/app/data <image-id> list

Task marked as completed!

or,

# if -v flag is used
docker run --rm -v $(pwd)/data:/app/data <image-id> list
```

```bash
# (f) Complete the tasks
docker run --rm --mount source=todo-list-volm,target=/app/data <image-id> complete 1

Task marked as completed!

or,

# if -v flag is used
docker run --rm -v $(pwd)/data:/app/data <image-id> complete 1
```

```bash
# (g) Delete the task
docker run --rm --mount source=todo-list-volm,target=/app/data <image-id> delete 1

Task marked as completed!

or,

# if -v flag is used
docker run --rm -v $(pwd)/data:/app/data <image-id> delete 1
```


**Key points**:
- Docker images are pushed to GitHub Container Registry (GHCR).
- The image tag is generated using the commit SHA.
- Helm values are updated automatically after a successful Docker push.

## Helm Chart

The application includes a Helm chart for deployment to Kubernetes clusters. The chart is located in the `helm/rust-todo` directory.

### Deploying with Helm

```bash
# Add your GitHub Container Registry credentials to Kubernetes
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<YOUR_GITHUB_USERNAME> \
  --docker-password=<YOUR_GITHUB_TOKEN> \
  --docker-email=<YOUR_EMAIL>

# Install the chart
helm install rust-todo ./helm/rust-todo \
  --set imagePullSecrets[0].name=ghcr-secret \
  --set image.repository=ghcr.io/<YOUR_GITHUB_USERNAME>/rust-todo
```

## License

[MIT License](LICENSE)
