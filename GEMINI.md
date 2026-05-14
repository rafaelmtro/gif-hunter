# GEMINI.md

## Project Overview
**Gif Hunter** is a high-performance, full-stack application for searching, viewing, and sharing animated GIFs. It is organized as a **monorepo** consisting of a React-based web frontend and a Next.js-based backend proxying the **Giphy API**.

- **Repository:** `gif-hunter`
- **Version:** `3.0.0` (Strictly follows **Semantic Versioning**)

### Core Technologies
- **Frontend:** React (Vite + TypeScript)
- **Backend:** Next.js (TypeScript) - App Router
- **State Management:** React Hooks & Local Storage
- **Containerization:** Docker Compose

---

## Architecture

### 1. Frontend (`/frontend`)
- **React (Vite):** Fast dev server and optimized builds.
- **Service Layer:** `giphyService` handles communication with the backend.
- **Components:** Modular UI with `Header`, `GifGrid`, `Sidebar`, and `DetailModal`.
- **Styling:** CSS-in-JS (inline styles for simplicity) and `index.css` for globals.
- **Features:** 
    - Search-as-you-type (500ms debounce).
    - Infinite scroll with pre-fetching.
    - Local Storage persistence for Favorites.
    - Responsive Grid layout.

### 2. Backend (`/backend`)
- **Next.js:** API Routes proxy the Giphy API to keep secrets safe.
- **Endpoints:**
    - `GET /api/gifs/trending`: Fetch trending GIFs.
    - `GET /api/gifs/search`: Search GIFs by query.
    - `GET /api/tags/trending`: Fetch trending search terms.
- **Security:** `GIPHY_API_KEY` is kept server-side. CORS enabled for local development.

---

## Building and Running

### Docker Compose
```bash
docker-compose up --build
```
- **Frontend:** `http://localhost:5173`
- **Backend:** `http://localhost:3000`

### Local Development
1. Set `GIPHY_API_KEY` in `backend/.env`.
2. Run `npm install` in both folders.
3. Run `npm run dev` in both folders.
