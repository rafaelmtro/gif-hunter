# Gif Hunter Frontend (SwiftWasm)

A WebAssembly frontend built with Swift and Tokamak. This replaces the legacy Flutter frontend, delivering a declarative component-based UI directly to the web.

## Tech Stack
- **Swift 5.10**
- **SwiftWasm**
- **Tokamak** (Declarative UI framework)
- **Carton** (Development and Build tool)
- **Nginx** (Reverse Proxy & Web Server)

## Architecture
- `Sources/GifHunter/GifHunterApp.swift`: Main entry point using `@main`.
- `Sources/GifHunter/ContentView.swift`: Main view implementing searching and trending functionality. Uses `JSClosure` for asynchronous callback bridging and `Task { @MainActor in }` for UI state updates.
- **API Proxy**: Communicates with the backend via relative `/api/` paths, proxied by Nginx.

## Setup

1. Build and run locally using the Carton SwiftPM plugin:
   ```bash
   cd frontend
   swift run carton dev
   ```
   The development server will run at `http://127.0.0.1:8080`.

## Testing
Run unit tests using the standard Swift package manager:
```bash
swift run carton test
```

## Docker Deployment
The `Dockerfile` employs a multi-stage build:
1. Uses the official `ghcr.io/swiftwasm/carton` image to bundle the WASM application.
2. Compiles and bundles the Swift code into an optimized `.wasm` binary using `carton bundle`.
3. Serves the static assets via `nginx:alpine` and proxies API requests to the `backend` service.
