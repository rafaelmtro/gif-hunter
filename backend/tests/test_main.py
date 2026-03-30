from fastapi.testclient import TestClient
import httpx
import respx
import pytest
from backend.main import app

client = TestClient(app)

@pytest.mark.asyncio
@respx.mock
async def test_get_trending():
    # Mock the Giphy API response
    respx.get("https://api.giphy.com/v1/gifs/trending").mock(
        return_value=httpx.Response(200, json={"data": [{"id": "1", "title": "Gif 1"}]})
    )
    
    # We need to set GIPHY_API_KEY for the app to work, or mock proxy_giphy
    import os
    os.environ["GIPHY_API_KEY"] = "test_key"
    
    response = client.get("/gifs/trending?limit=10&offset=0")
    assert response.status_code == 200
    assert response.json()["data"][0]["id"] == "1"

@pytest.mark.asyncio
@respx.mock
async def test_search_gifs():
    respx.get("https://api.giphy.com/v1/gifs/search").mock(
        return_value=httpx.Response(200, json={"data": [{"id": "2", "title": "Gif 2"}]})
    )
    
    import os
    os.environ["GIPHY_API_KEY"] = "test_key"
    
    response = client.get("/gifs/search?q=funny&limit=10&offset=0")
    assert response.status_code == 200
    assert response.json()["data"][0]["id"] == "2"

@pytest.mark.asyncio
@respx.mock
async def test_get_trending_searches():
    respx.get("https://api.giphy.com/v1/trending/searches").mock(
        return_value=httpx.Response(200, json={"data": ["funny", "cats"]})
    )
    
    import os
    os.environ["GIPHY_API_KEY"] = "test_key"
    
    response = client.get("/trending/searches")
    assert response.status_code == 200
    assert "funny" in response.json()["data"]

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
