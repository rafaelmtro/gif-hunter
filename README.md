# 🎯 Gif Hunter v3.1.0

**Gif Hunter** is a high-performance web application for searching, viewing, and sharing animated GIFs. It is built with Next.js, integrating a React frontend and a backend API proxy for robust and secure integration with the Giphy API.

---

## 🛠 Tech Stack

- **Framework:** Next.js (React, TypeScript)

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
   Ensure you have a `.env` file in the root directory with your Giphy API Key:
   ```env
   GIPHY_API_KEY=your_api_key_here
   ```

3. **Run the Application:**
   ```bash
   docker-compose up --build
   ```

- Access the application at `http://localhost:3000`

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
