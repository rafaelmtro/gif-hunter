# Build Stage
FROM ghcr.io/swiftwasm/swift:5.10-jammy AS builder

WORKDIR /app
COPY . .

# Build and bundle the release Wasm application using the Carton plugin
RUN swift run carton bundle --release

# Runtime Stage
FROM nginx:alpine
# Copy the bundled assets from the build stage (usually in Bundle directory)
COPY --from=builder /app/Bundle /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
