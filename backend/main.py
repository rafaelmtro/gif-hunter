import os
import httpx
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from typing import Optional, List
from dotenv import load_dotenv

load_dotenv()

GIPHY_API_KEY = os.getenv("GIPHY_API_KEY")
GIPHY_BASE_URL = "https://api.giphy.com/v1"

app = FastAPI(title="Gif Hunter Backend", version="1.0.0")

# Enable CORS for the frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

async def proxy_giphy(endpoint: str, params: dict):
    if not GIPHY_API_KEY:
        raise HTTPException(status_code=500, detail="GIPHY_API_KEY not configured")
    
    params["api_key"] = GIPHY_API_KEY
    
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(f"{GIPHY_BASE_URL}/{endpoint}", params=params)
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as exc:
            raise HTTPException(status_code=exc.response.status_code, detail=exc.response.text)
        except Exception as exc:
            raise HTTPException(status_code=500, detail=str(exc))

@app.get("/", response_class=HTMLResponse)
async def root():
    return """
    <html>
        <head>
            <title>Gif Hunter API</title>
            <style>
                body { font-family: sans-serif; background: #000; color: #ff8c00; text-align: center; padding: 50px; }
                a { color: #fff; text-decoration: none; border: 1px solid #ff8c00; padding: 10px 20px; border-radius: 5px; }
                a:hover { background: #ff8c00; color: #000; }
            </style>
        </head>
        <body>
            <h1>Gif Hunter Backend API</h1>
            <p>This is the proxy service for the Giphy API.</p>
            <p>The main application is typically available at <a href="http://localhost:8000">localhost:8000</a>.</p>
            <br/>
            <a href="/docs">View API Documentation</a>
        </body>
    </html>
    """

@app.get("/gifs/trending")
async def get_trending(
    limit: int = 20, 
    offset: int = 0, 
    rating: str = "g"
):
    return await proxy_giphy("gifs/trending", {
        "limit": limit,
        "offset": offset,
        "rating": rating
    })

@app.get("/gifs/search")
async def search_gifs(
    q: str, 
    limit: int = 20, 
    offset: int = 0, 
    rating: str = "g", 
    lang: str = "en"
):
    return await proxy_giphy("gifs/search", {
        "q": q,
        "limit": limit,
        "offset": offset,
        "rating": rating,
        "lang": lang
    })

@app.get("/trending/searches")
async def get_trending_searches():
    return await proxy_giphy("trending/searches", {})

@app.get("/health")
async def health_check():
    return {"status": "ok"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
