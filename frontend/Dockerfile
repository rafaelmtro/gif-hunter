# Build Stage
FROM swiftwasm/swift:5.9-focal as builder

WORKDIR /app
COPY . .

# Install carton
RUN npm install -g @swiftwasm/carton

# Build the release Wasm bundle
RUN carton bundle --release

# Optimize the wasm binary (optional, requires wasm-opt which might be in the image or needs installation)
# RUN apt-get update && apt-get install -y binaryen && wasm-opt -O3 Bundle/main.wasm -o Bundle/main.wasm

# Runtime Stage
FROM nginx:alpine
COPY --from=builder /app/Bundle /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
