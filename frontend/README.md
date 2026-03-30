# Gif Hunter Frontend (SwiftWasm)

A WebAssembly frontend built with Swift and Tokamak. This replaces the legacy Flutter frontend, delivering a declarative component-based UI directly to the web.

## Tech Stack
- **Swift 5.9**
- **SwiftWasm**
- **Tokamak** (Declarative UI framework)
- **Carton** (Development and Build server)

## Prerequisites
- [Swift 5.9 Toolchain](https://www.swift.org/download/)
- [Node.js](https://nodejs.org/) (for Carton)

## Setup

1. Install Carton globally via npm:
   ```bash
   npm install -g @swiftwasm/carton
   ```

2. Build and run locally:
   ```bash
   carton dev
   ```
   The development server will run at `http://127.0.0.1:8080`.

## Testing
Run unit tests using the standard Swift package manager:
```bash
swift test
```

## Docker Deployment
The `Dockerfile` employs a multi-stage build:
1. Compiles the Swift code into an optimized `.wasm` binary using `carton bundle`.
2. Serves the static assets via a lightweight `nginx:alpine` image.
