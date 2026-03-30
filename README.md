# Gif Hunter

**Gif Hunter** is a high-performance, full-stack application designed for searching, viewing, and sharing animated GIFs. 
It is organized as a monorepo consisting of a SwiftWasm web frontend and a FastAPI-based backend proxying the Giphy API.

## Monorepo Architecture

This repository is split into two main services:

### [Frontend (Swift Web)](./frontend/README.md)
The web application providing the user interface, built using SwiftWasm and Tokamak.
- Component-based architecture ported from an earlier Flutter design.
- Asynchronous image loading, declarative state management, and custom themes.
- Powered by `Carton` for local development and optimized with `wasm-opt`.

### [Backend (FastAPI)](./backend/README.md)
A Python FastAPI application acting as a proxy to the Giphy API.
- Securely stores the `GIPHY_API_KEY`.
- Exposes clean endpoints for trending GIFs, search, and trending tags.
- Tested thoroughly with `pytest`.

## Core Technologies
- **Frontend**: Swift 5.9+, SwiftWasm, Tokamak (Web), Carton.
- **Backend**: Python 3.11+, FastAPI, HTTPX, Pytest.
- **Containerization**: Docker & Docker Compose.
- **CI/CD**: GitHub Actions.

## Building and Running (Docker Compose)

The easiest way to run the entire stack is with Docker Compose.

1. Create a `.env` file at the root or within the `/backend` and `/frontend` directories containing required environment variables (e.g., `GIPHY_API_KEY`).
2. Run Docker Compose:

```bash
docker-compose up --build
```

- **Frontend:** Available at `http://localhost:8080`
- **Backend:** Available at `http://localhost:8000`
- **API Documentation:** Available at `http://localhost:8000/docs`

## Development Conventions
- **Versioning**: Strict Semantic Versioning.
- **Branching**: `develop` for integration, `master` for production, `feature/*` for features.
- **Commits**: Follow Conventional Commits format.

For service-specific development instructions, please refer to the README files in the respective directories.
