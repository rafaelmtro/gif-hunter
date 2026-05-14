# 🎯 Gif Hunter v3.0.0

**Gif Hunter** is a high-performance web application for searching, viewing, and sharing animated GIFs. It leverages a React frontend and a Next.js backend API proxy for robust and secure integration with the Giphy API.

---

## 🛠 Tech Stack

- **Frontend:** React (Vite, TypeScript)
- **Backend:** Next.js (TypeScript)

---

## 🚀 Getting Started

### Prerequisites
- Node.js
- Docker (optional but recommended)
- A [Giphy API Key](https://developers.giphy.com/dashboard/)

### Installation & Running (Docker Compose)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rafaelmtro/gif-hunter.git
   cd gif-hunter
   ```

2. **Setup Environment:**
   Create a `.env` file in the `backend` directory and add your Giphy API Key:
   ```env
   GIPHY_API_KEY=your_api_key_here
   ```

3. **Run the Stack:**
   ```bash
   docker-compose up --build
   ```

- Frontend accessible at `http://localhost:5173`
- Backend API accessible at `http://localhost:3000`

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
