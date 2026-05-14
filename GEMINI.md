# GEMINI.md

## Project Overview
**Gif Hunter** is a full-stack application designed for searching, viewing, and sharing animated GIFs. It is organized as a **monorepo** consisting of a React-based web frontend and a Next.js-based backend proxying the **Giphy API**.

- **Repository:** `gif-hunter`
- **Version:** `3.0.0` (Strictly follows **Semantic Versioning**: MAJOR.MINOR.PATCH)

### Core Technologies
- **Frontend:** React (Vite + TypeScript) - providing the user interface.
- **Backend:** Next.js (TypeScript) - acts as an API proxy to the Giphy API.
- **Containerization:** **Docker Compose** for orchestrating frontend and backend services.

---

## Monorepo Architecture

The project is divided into two main service directories:

### 1. Frontend (`/frontend`)
The React web application providing the user interface.
- Built using Vite.
- Implemented with TypeScript and React hooks.
- **Environment**: Configured to point to the Next.js backend service.

### 2. Backend (`/backend`)
A Next.js application that provides API routes handling Giphy API interactions.
- Provides a proxy to securely access the Giphy API.
- Implemented with TypeScript and Next.js App Router (or API routes).
- **Environment:** Requires `GIPHY_API_KEY` to communicate with Giphy.

---

## Environment Configuration & Security

- **Secrets Management:**
    - `GIPHY_API_KEY`: Stored in the backend's environment. Never exposed to the frontend.
- **Local Development:** Use a `.env` file at the root or within respective service folders. `docker-compose` handles passing these variables to the containers.
- **Security Rule:** NEVER commit `.env` files to version control.

---

## Building and Running

### Docker Compose (Recommended)
To run the entire stack (frontend and backend) simultaneously:

```bash
# From the project root
docker-compose up --build
```
- **Frontend:** Available at `http://localhost:5173`
- **Backend API:** Available at `http://localhost:3000`

---

## Development Conventions

### Version Control & Git Strategy
- **Branching:** `master` for production, `develop` for integration.
- **Features:** `feature/<name>` branched from `develop`.
- **Commit Messages:** Follow **Conventional Commits** (e.g., `feat(frontend): add search`).
