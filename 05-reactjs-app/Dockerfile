# syntax=docker/dockerfile:1.4

#############################################
# Development stage
#############################################
FROM node:20-alpine AS development

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Set working directory
WORKDIR /app

# Copy package files with proper ownership
COPY --chown=nextjs:nodejs package*.json ./

# Install dependencies
RUN npm ci && npm cache clean --force

# Copy source code with proper ownership
COPY --chown=nextjs:nodejs . .

# Set ownership of /app (important for build output)
RUN chown -R nextjs:nodejs /app

# Switch to non-root user
USER nextjs

# Set environment variables
ENV CI=true \
    PORT=3000 \
    NODE_ENV=development

EXPOSE $PORT

CMD ["npm", "start"]

#############################################
# Build stage
#############################################
FROM development AS build

# Build the application
RUN npm run build

#############################################
# FINAL-Production stage with Nginx
#############################################
FROM nginx:1.24-alpine

# Install security updates
RUN apk upgrade --no-cache

# Copy custom nginx configuration
COPY .nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Remove default nginx content to ensure no conflicting files are served by Nginx
# Set security headers to prevent information disclosure and disable server tokens (before switching to non-root)
# Adjust ownership of nginx configuration files to ensure the nginx process can access and modify them securely
RUN rm -rf /usr/share/nginx/html/* \
    && echo 'server_tokens off;' > /etc/nginx/conf.d/security.conf \
    && chown -R nginx:nginx /etc/nginx/conf.d \
    && mkdir -p /var/cache/nginx \
    && chown -R nginx:nginx /var/cache/nginx \
    && mkdir -p /var/run \
    && chown -R nginx:nginx /var/run \
    && chown -R nginx:nginx /var/log/nginx

# Copy built React app from build stage
COPY --from=build --chown=nginx:nginx /app/build /usr/share/nginx/html

# Switch to non-root user
USER nginx

ENV PORT=80

# Expose port
EXPOSE $PORT

# Health check for the nginx server
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:$PORT || exit 1

# Start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
