# Gif Hunter

**Gif Hunter** is a high-performance, full-stack application designed for searching, viewing, and sharing animated GIFs. 
It is organized as a monorepo consisting of a SwiftWasm web frontend and a FastAPI-based backend proxying the Giphy API.

## Monorepo Architecture

This repository is split into two main services:

### [Frontend (Swift Web)](./frontend/README.md)
The web application providing the user interface, built using SwiftWasm and Tokamak.
- Component-based architecture with declarative state management.
- Uses Nginx as a reverse proxy to communicate with the backend.
- Powered by `Carton` for local development.

### [Backend (FastAPI)](./backend/README.md)
A Python FastAPI application acting as a proxy to the Giphy API.
- Securely handles Giphy API authentication.
- Exposes clean endpoints for trending GIFs, search, and trending tags.
- Fully tested with `pytest`.

## Core Technologies
- **Frontend**: Swift (SwiftWasm), Tokamak, Nginx.
- **Backend**: Python (FastAPI), HTTPX.
- **Infrastructure**: Docker & Docker Compose.

## Building and Running (Docker Compose)

The easiest way to run the entire stack is with Docker Compose.

1. Create a `.env` file at the root or within the `/backend` folder and add your Giphy API key:
```env
GIPHY_API_KEY=your_key_here
```
2. Run Docker Compose:

```bash
docker-compose up --build
```

- **Frontend:** Available at `http://localhost:8000`
- **Backend API:** Available at `http://localhost:8080`
- **API Documentation:** Available at `http://localhost:8080/docs`

## Development Conventions
- **Versioning**: Strict Semantic Versioning.
- **Branching**: `develop` for integration, `master` for production, `feature/*` for features.
- **Commits**: Follow Conventional Commits format.

For service-specific development instructions, please refer to the README files in the respective directories.
