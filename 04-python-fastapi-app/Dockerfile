# Multi-stage build for optimized FastAPI application
FROM python:3.11-alpine AS base

# Install build dependencies
RUN apk add --no-cache gcc musl-dev

# Create virtual environment
RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

# Copy and install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


############ FINAL Stage - image ############
FROM python:3.11-alpine

# Copy virtual environment from base stage
COPY --from=base /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

# Set working directory
WORKDIR /app

# Create non-root user
RUN adduser --disabled-password --no-create-home appuser

# Copy application code
COPY --chown=appuser:appuser main.py .

# Switch to non-root user
USER appuser

# Set environment variables for security & enable bytecode compilation
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=80

# Expose port
EXPOSE $PORT

# Health check using wget (available in alpine)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD pgrep -f uvicorn || exit 1

# Run the application
CMD uvicorn main:app --host 0.0.0.0 --port $PORT
