import { GiphyResponse } from '../types';

const API_BASE_URL = 'http://localhost:3000/api';

export const giphyService = {
  async getTrending(offset = 0): Promise<GiphyResponse> {
    const response = await fetch(`${API_BASE_URL}/gifs/trending?offset=${offset}`);
    return response.json();
  },

  async search(query: string, offset = 0): Promise<GiphyResponse> {
    const response = await fetch(`${API_BASE_URL}/gifs/search?q=${encodeURIComponent(query)}&offset=${offset}`);
    return response.json();
  },

  async getTrendingTags(): Promise<{ data: string[] }> {
    const response = await fetch(`${API_BASE_URL}/tags/trending`);
    return response.json();
  }
};
