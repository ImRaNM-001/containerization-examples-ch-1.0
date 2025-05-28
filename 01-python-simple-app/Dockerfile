###############################################
# GO BUILD STAGE
###############################################
FROM golang:1.21-alpine AS go-build

# Install the Go binary package
RUN go install github.com/signorrayan/helloworld-go@latest


###############################################
# PYTHON BUILD STAGE
###############################################
FROM python:3.11-alpine AS python-build

# Install build dependencies
RUN apk add --no-cache gcc musl-dev postgresql-dev

WORKDIR /app

# Copy requirements first for better caching
COPY webapp/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

    
###############################################
# FINAL STAGE
###############################################
FROM python:3.11-alpine

# Install runtime dependencies only
RUN apk add --no-cache postgresql-libs netcat-openbsd && \
    addgroup -S appgroup && \
    adduser -S appuser -G appgroup

WORKDIR /usr/src/devops_hobbies

# Copy Python dependencies from build stage
COPY --from=python-build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=python-build /usr/local/bin /usr/local/bin

# Copy Go binary from go-build stage
COPY --from=go-build /go/bin/helloworld-go /usr/local/bin/

# Copy application code
COPY . .

# Fix line endings and set permissions
RUN sed -i 's/\r$//g' /usr/src/devops_hobbies/entrypoint.sh && \
    chmod +x /usr/src/devops_hobbies/entrypoint.sh && \
    chown -R appuser:appgroup /usr/src/devops_hobbies

# Switch to non-root user
USER appuser

# Expose the application port
EXPOSE 8088

ENTRYPOINT ["/usr/src/devops_hobbies/entrypoint.sh"]

CMD ["python", "/usr/src/devops_hobbies/webapp/app.py"]
