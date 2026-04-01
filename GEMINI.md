# GEMINI.md

## Project Overview
**Gif Hunter** is a high-performance, full-stack application designed for searching, viewing, and sharing animated GIFs. It is organized as a **monorepo** consisting of a SwiftWasm-based web frontend and a FastAPI-based backend proxying the **Giphy API**.

- **Repository:** `gif-hunter`
- **Version:** `3.0.0` (Strictly follows **Semantic Versioning**: MAJOR.MINOR.PATCH)

### Core Technologies
- **Frontend:** Swift (SwiftWasm) with Tokamak - targeting Web.
- **Backend:** Python (FastAPI) - acts as a proxy to the Giphy API.
- **HTTP Client:** `URLSession` via `JavaScriptKit` (Frontend) and `httpx` (Backend).
- **State Management:** Swift `@StateObject`, `@Published`, and `@EnvironmentObject` on the frontend.
- **Containerization:** **Docker Compose** for orchestrating frontend and backend services.
- **CI/CD:** GitHub Actions for automated builds and deployment.

---

## Monorepo Architecture

The project is divided into two main service directories:

### 1. Frontend (`/frontend`)
The SwiftWasm web application providing the user interface.
- Built using Swift Package Manager (`Package.swift`).
- Communicates with the internal FastAPI backend instead of Giphy directly.
- **Environment:** Configured to point to the FastAPI service (e.g., via backend URL).

### 2. Backend (`/backend`)
A Python FastAPI application that handles Giphy API interactions.
- `main.py`: Contains proxy endpoints for trending GIFs, searches, and trending tags.
- `tests/`: Comprehensive test suite using `pytest` and `respx`.
- **Environment:** Requires `GIPHY_API_KEY` to communicate with Giphy.

---

## Environment Configuration & Security

- **Secrets Management:** 
    - `GIPHY_API_KEY`: Stored in the backend's environment. Never exposed to the frontend.
    - `BACKEND_URL`: Used by the frontend to locate the proxy service.
- **Local Development:** Use a `.env` file at the root or within respective service folders. `docker-compose` handles passing these variables to the containers.
- **Security Rule:** NEVER commit `.env` files to version control.

---

## UI/UX & Design Guidelines
*(Design guidelines focus on a minimalist Orange and Black theme, responsive grid, and smooth transitions, now implemented via Tokamak and CSS injection.)*

---

## Building and Running

### Docker Compose (Recommended)
To run the entire stack (frontend and backend) simultaneously:

```bash
# From the project root
docker-compose up --build
```
- **Frontend:** Available at `http://localhost:8080`
- **Backend:** Available at `http://localhost:8000`
- **API Documentation:** Available at `http://localhost:8000/docs`

### Individual Services

**Backend:**
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

**Frontend:**
```bash
cd frontend
swift run carton dev
```

---

## Development Conventions

### Version Control & Git Strategy
- **Branching:** `master` for production, `develop` for integration.
- **Features:** `feature/<name>` branched from `develop`.
- **Commit Messages:** Follow **Conventional Commits** (e.g., `feat(frontend): port to SwiftWasm`).

### Testing
- **Backend Tests:** Run `pytest` in the `/backend` directory.
- **Frontend Tests:** Run `swift test` in the `/frontend` directory.
