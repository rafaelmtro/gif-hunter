import React from 'react';
import { Gif } from '../types';

interface DetailModalProps {
  gif: Gif | null;
  onClose: () => void;
  isFavorite: boolean;
  onToggleFavorite: (gif: Gif) => void;
}

export const DetailModal: React.FC<DetailModalProps> = ({ gif, onClose, isFavorite, onToggleFavorite }) => {
  if (!gif) return null;

  return (
    <div style={styles.overlay} onClick={onClose}>
      <div style={styles.modal} onClick={(e) => e.stopPropagation()}>
        <div style={styles.header}>
          <h2 style={styles.title}>{gif.title}</h2>
          <div style={styles.actions}>
            <button
              onClick={() => onToggleFavorite(gif)}
              style={styles.actionButton}
            >
              {isFavorite ? '❤️' : '🤍'}
            </button>
            <button onClick={onClose} style={styles.closeButton}>×</button>
          </div>
        </div>
        <div style={styles.content}>
          <img
            src={gif.images.original.url}
            alt={gif.title}
            style={styles.image}
          />
          {gif.user && (
            <div style={styles.userInfo}>
              <img src={gif.user.avatar_url} alt={gif.user.display_name} style={styles.avatar} />
              <span>{gif.user.display_name}</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

const styles: { [key: string]: React.CSSProperties } = {
  overlay: {
    position: 'fixed',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.85)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 1000,
  },
  modal: {
    backgroundColor: '#1a1a1a',
    borderRadius: '12px',
    maxWidth: '90%',
    maxHeight: '90%',
    display: 'flex',
    flexDirection: 'column',
    overflow: 'hidden',
  },
  header: {
    padding: '15px 20px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderBottom: '1px solid #333',
  },
  title: {
    margin: 0,
    fontSize: '18px',
    color: 'white',
  },
  actions: {
    display: 'flex',
    gap: '15px',
    alignItems: 'center',
  },
  actionButton: {
    background: 'none',
    border: 'none',
    fontSize: '24px',
    cursor: 'pointer',
  },
  closeButton: {
    background: 'none',
    border: 'none',
    color: '#a0a0a0',
    fontSize: '32px',
    cursor: 'pointer',
    lineHeight: 1,
  },
  content: {
    padding: '20px',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    overflowY: 'auto',
  },
  image: {
    maxWidth: '100%',
    maxHeight: '70vh',
    borderRadius: '4px',
  },
  userInfo: {
    marginTop: '20px',
    display: 'flex',
    alignItems: 'center',
    gap: '10px',
    alignSelf: 'flex-start',
    color: '#a0a0a0',
  },
  avatar: {
    width: '32px',
    height: '32px',
    borderRadius: '50%',
  },
};
