import React, { useState } from 'react';
import { Gif } from '../types';

interface GifItemProps {
  gif: Gif;
  onSelect: (gif: Gif) => void;
  isFavorite: boolean;
  onToggleFavorite: (gif: Gif) => void;
}

export const GifItem: React.FC<GifItemProps> = ({ gif, onSelect, isFavorite, onToggleFavorite }) => {
  const [isHovered, setIsHovered] = useState(false);

  return (
    <div
      style={styles.container}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={() => onSelect(gif)}
    >
      <img
        src={isHovered ? gif.images.fixed_height.url : gif.images.fixed_height_still.url}
        alt={gif.title}
        style={styles.image}
      />
      {isHovered && (
        <div style={styles.overlay}>
          <button
            onClick={(e) => {
              e.stopPropagation();
              onToggleFavorite(gif);
            }}
            style={styles.favoriteButton}
          >
            {isFavorite ? '❤️' : '🤍'}
          </button>
          <div style={styles.title}>{gif.title}</div>
        </div>
      )}
    </div>
  );
};

const styles: { [key: string]: React.CSSProperties } = {
  container: {
    position: 'relative',
    borderRadius: '8px',
    overflow: 'hidden',
    backgroundColor: '#1a1a1a',
    cursor: 'pointer',
    width: '100%',
    aspectRatio: '1',
  },
  image: {
    width: '100%',
    height: '100%',
    objectFit: 'cover',
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.4)',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'space-between',
    padding: '10px',
  },
  favoriteButton: {
    alignSelf: 'flex-end',
    background: 'none',
    border: 'none',
    fontSize: '20px',
    cursor: 'pointer',
    padding: '5px',
  },
  title: {
    fontSize: '12px',
    color: 'white',
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
  },
};
