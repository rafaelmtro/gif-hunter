# GEMINI.md

## Project Overview
**Gif Hunter** is a high-performance, full-stack application for searching, viewing, and sharing animated GIFs. It is built as a single **Next.js** application, combining a React frontend with server-side API routes to proxy the **Giphy API**.

- **Repository:** `gif-hunter`
- **Version:** `3.1.0` (Strictly follows **Semantic Versioning**)

### Core Technologies
- **Framework:** Next.js (TypeScript + App Router)
- **State Management:** React Hooks & Local Storage
- **Containerization:** Docker Compose

---

## Architecture

### Single Application Structure
- **Frontend:** React components located in `src/components`.
- **Backend (API):** Next.js API routes located in `src/app/api`. These proxy the Giphy API to keep the `GIPHY_API_KEY` secure on the server.
- **Styling:** CSS-in-JS (inline styles) and `src/app/globals.css`.
- **Features:** 
    - Search-as-you-type (500ms debounce).
    - Infinite scroll with pre-fetching.
    - Local Storage persistence for Favorites.
    - Responsive Grid layout.

---

## Building and Running

### Docker Compose
```bash
docker-compose up --build
```
- **Site:** `http://localhost:3000`

### Local Development
1. Set `GIPHY_API_KEY` in your `.env` file at the root.
2. Run `npm install`.
3. Run `npm run dev`.
