![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)

# Dockerfile for Beginners

This exercise contains a simple and practical example of a Dockerfile to help developers learn how to work with a minimalistic Docker image.

## Prerequisites

- Docker installed on your OS. [Docker Installation](https://docs.docker.com/engine/install/)
- Basic knowledge of the Linux command line.

## Each Line Explanation in Dockerfile

### Builder Stage
- `FROM python:3.11-alpine AS base`: Use a lightweight Python Alpine image as the builder stage for installing dependencies.

- `RUN apk add --no-cache gcc musl-dev`: Install build dependencies (compiler tools) needed to compile Python packages.

- `RUN python -m venv /opt/venv`: Create a virtual environment to isolate Python dependencies.

- `ENV PATH="/opt/venv/bin:$PATH"`: Set environment variable so the virtual environment's Python and pip are used.

- `COPY requirements.txt .`: Copy the requirements file to the builder stage.

- `RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt`: Upgrade pip and install all Python dependencies in the virtual environment.

### Final Stage
- `FROM python:3.11-alpine`: Start a fresh Alpine image for the final runtime stage (smaller, no build tools).

- `COPY --from=base /opt/venv /opt/venv`: Copy the virtual environment from the builder stage to the final image.

- `ENV PATH="/opt/venv/bin:$PATH"`: Set environment variable to use the copied virtual environment.

- `WORKDIR /app`: Set the working directory in the container to `/app`.

- `RUN adduser --disabled-password --no-create-home appuser`: Create a non-root user for security (no password, no home directory).

- `COPY --chown=appuser:appuser main.py .`: Copy the application code and set ownership to the non-root user.

- `USER appuser`: Switch to the non-root user for running the application.

- `ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PORT=80`: Set security and performance environment variables.

- `EXPOSE $PORT`: Expose the port that the application will listen on.

- `HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD pgrep -f uvicorn || exit 1`: Configure health check to monitor if the application is running.

- `CMD uvicorn main:app --host 0.0.0.0 --port $PORT`: Set the command to start the FastAPI application using Uvicorn server.

## Usage

1. Build the Docker image:

    ```sh
    cd 04-python-fastapi-app
    docker build -t hello-fastapi .
    ```

3. Run the Docker container:

    ```sh
    docker container run --detach --publish 8080:80 hello-fastapi
    ```
   > -d,--detach &emsp;&emsp;&emsp;&emsp; Run container in background and print container ID </br>
   > -p, --publish list &emsp;&emsp; Publish a container's port(s) to the host
