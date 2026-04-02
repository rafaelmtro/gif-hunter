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

## Architecture
- `Sources/GifHunter/GifHunterApp.swift`: Main entry point using `@main`. No top-level code in `main.swift` is used to avoid compiler conflicts.
- `Sources/GifHunter/ContentView.swift`: Main view implementing searching and trending functionality. Uses `JSClosure` for asynchronous callback handling.

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
1. Resolves and caches SwiftPM dependencies using `swift package resolve`.
2. Compiles and bundles the Swift code into an optimized `.wasm` binary using `swift run carton bundle --release`.
3. Serves the static assets via a lightweight `nginx:alpine` image.
