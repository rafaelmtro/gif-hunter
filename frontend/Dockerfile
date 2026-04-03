# Build Stage
FROM ghcr.io/swiftwasm/carton:0.20.1 AS builder

WORKDIR /app
COPY Package.swift .
# Resolve dependencies early to cache them
RUN swift package resolve 

COPY . .
# Use the global carton tool to bundle the application
# This image already contains the necessary SwiftWasm SDKs
RUN carton bundle && \
    mkdir -p Bundle && \
    touch Bundle/favicon.ico && \
    echo "// Legacy service worker cleanup" > Bundle/flutter_service_worker.js

# Runtime Stage
FROM nginx:alpine
# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copy bundled assets
COPY --from=builder /app/Bundle /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
