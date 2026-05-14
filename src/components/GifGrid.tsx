import React from 'react';
import { Gif } from '../types';
import { GifItem } from './GifItem';

interface GifGridProps {
  gifs: Gif[];
  onSelect: (gif: Gif) => void;
  favorites: string[];
  onToggleFavorite: (gif: Gif) => void;
  isLoading: boolean;
}

export const GifGrid: React.FC<GifGridProps> = ({ gifs, onSelect, favorites, onToggleFavorite, isLoading }) => {
  return (
    <div style={styles.container}>
      <div style={styles.grid}>
        {gifs.map((gif) => (
          <GifItem
            key={gif.id}
            gif={gif}
            onSelect={onSelect}
            isFavorite={favorites.includes(gif.id)}
            onToggleFavorite={onToggleFavorite}
          />
        ))}
      </div>
      {isLoading && <div style={styles.loading}>Loading...</div>}
    </div>
  );
};

const styles: { [key: string]: React.CSSProperties } = {
  container: {
    padding: '20px',
    flex: 1,
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))',
    gap: '16px',
  },
  loading: {
    textAlign: 'center',
    padding: '40px',
    color: '#ff8c00',
    fontSize: '18px',
  },
};
