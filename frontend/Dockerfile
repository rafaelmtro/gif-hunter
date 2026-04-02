# Build Stage
FROM ghcr.io/swiftwasm/swift:5.10-jammy AS builder

# Install Node/NPM for Carton (if needed by carton plugin for dev server/bundling)
RUN apt-get update && apt-get install -y \
    curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Package.swift .
# Resolve dependencies early to cache them
RUN swift package resolve 

COPY . .
# Use the carton SwiftPM plugin to bundle the release
RUN swift run carton bundle --release

# Runtime Stage
FROM nginx:alpine
COPY --from=builder /app/Bundle /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
