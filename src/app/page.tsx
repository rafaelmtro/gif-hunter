"use client";

import { useState, useEffect, useCallback } from 'react';
import { Header } from '../components/Header';
import { GifGrid } from '../components/GifGrid';
import { Sidebar } from '../components/Sidebar';
import { DetailModal } from '../components/DetailModal';
import { Gif } from '../types';
import { giphyService } from '../services/giphy';

export default function Home() {
  const [gifs, setGifs] = useState<Gif[]>([]);
  const [tags, setTags] = useState<string[]>([]);
  const [favorites, setFavorites] = useState<Gif[]>([]);
  const [selectedGif, setSelectedGif] = useState<Gif | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isFavoritesOnly, setIsFavoritesOnly] = useState(false);
  const [offset, setOffset] = useState(0);
  const [query, setQuery] = useState('');

  // Load favorites from localStorage
  useEffect(() => {
    const saved = localStorage.getItem('favorites');
    if (saved) {
      setFavorites(JSON.parse(saved));
    }
  }, []);

  // Save favorites to localStorage
  useEffect(() => {
    localStorage.setItem('favorites', JSON.stringify(favorites));
  }, [favorites]);

  // Fetch initial data
  useEffect(() => {
    const fetchTags = async () => {
      try {
        const res = await giphyService.getTrendingTags();
        setTags(res.data || []);
      } catch (e) {
        console.error('Failed to fetch tags', e);
      }
    };
    fetchTags();
  }, []);

  const fetchGifs = useCallback(async (searchQuery: string, currentOffset: number, append = false) => {
    setIsLoading(true);
    try {
      let res;
      if (searchQuery) {
        res = await giphyService.search(searchQuery, currentOffset);
      } else {
        res = await giphyService.getTrending(currentOffset);
      }
      
      if (append) {
        setGifs(prev => [...prev, ...res.data]);
      } else {
        setGifs(res.data);
      }
    } catch (e) {
      console.error('Failed to fetch gifs', e);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!isFavoritesOnly) {
      fetchGifs(query, 0, false);
      setOffset(0);
    }
  }, [query, isFavoritesOnly, fetchGifs]);

  const handleSearch = (q: string) => {
    setQuery(q);
    setIsFavoritesOnly(false);
  };

  const handleTagClick = (tag: string) => {
    setQuery(tag);
    setIsFavoritesOnly(false);
  };

  const toggleFavorite = (gif: Gif) => {
    setFavorites(prev => {
      const isFav = prev.find(f => f.id === gif.id);
      if (isFav) {
        return prev.filter(f => f.id !== gif.id);
      } else {
        return [...prev, gif];
      }
    });
  };

  const handleScroll = useCallback(() => {
    if (isFavoritesOnly || isLoading) return;
    
    if (window.innerHeight + document.documentElement.scrollTop + 100 >= document.documentElement.offsetHeight) {
      const nextOffset = offset + 20;
      setOffset(nextOffset);
      fetchGifs(query, nextOffset, true);
    }
  }, [offset, query, isFavoritesOnly, isLoading, fetchGifs]);

  useEffect(() => {
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, [handleScroll]);

  const favoriteIds = favorites.map(f => f.id);

  return (
    <div style={styles.app}>
      <Header onSearch={handleSearch} />
      <div style={styles.main}>
        <div style={styles.content}>
          <h1 style={styles.title}>
            {isFavoritesOnly ? 'Your Favorites' : query ? `Search results for "${query}"` : 'Trending GIFs'}
          </h1>
          <GifGrid
            gifs={isFavoritesOnly ? favorites : gifs}
            onSelect={setSelectedGif}
            favorites={favoriteIds}
            onToggleFavorite={toggleFavorite}
            isLoading={isLoading}
          />
        </div>
        <Sidebar
          tags={tags}
          onTagClick={handleTagClick}
          favoritesCount={favorites.length}
          onOpenFavorites={() => setIsFavoritesOnly(!isFavoritesOnly)}
        />
      </div>
      <DetailModal
        gif={selectedGif}
        onClose={() => setSelectedGif(null)}
        isFavorite={selectedGif ? favoriteIds.includes(selectedGif.id) : false}
        onToggleFavorite={toggleFavorite}
      />
    </div>
  );
}

const styles: { [key: string]: React.CSSProperties } = {
  app: {
    minHeight: '100vh',
    display: 'flex',
    flexDirection: 'column',
  },
  main: {
    display: 'flex',
    flex: 1,
  },
  content: {
    flex: 1,
    padding: '20px 40px',
  },
  title: {
    fontSize: '24px',
    margin: '0 0 20px 20px',
    color: 'white',
  },
};
