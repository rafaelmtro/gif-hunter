# Gif Hunter Backend

A FastAPI-based proxy for the Giphy API, providing a secure backend layer for the Gif Hunter frontend.

## Features
- Proxy for Giphy Trending GIFs.
- Proxy for Giphy Search.
- Proxy for Giphy Trending Searches.
- CORS enabled for seamless frontend integration.
- Health check endpoint.

## Tech Stack
- **Python 3.11**
- **FastAPI**
- **HTTPX** (Async client)
- **Pytest** & **RESPX** (Testing)

## Getting Started

### Prerequisites
- Python 3.11+
- GIPHY API Key

### Installation
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create a virtual environment and activate it:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Create a `.env` file and add your GIPHY API key:
   ```env
   GIPHY_API_KEY=your_giphy_api_key_here
   ```

### Running the server
```bash
uvicorn main:app --reload
```
The server will be available at `http://localhost:8000`.

### Running Tests
```bash
pytest
```

## API Endpoints
- `GET /`: API welcome message.
- `GET /gifs/trending`: Get trending GIFs.
- `GET /gifs/search`: Search for GIFs.
- `GET /trending/searches`: Get trending search terms.
- `GET /health`: Backend health status.
