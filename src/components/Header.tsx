import React, { useState, useEffect } from 'react';

interface HeaderProps {
  onSearch: (query: string) => void;
}

export const Header: React.FC<HeaderProps> = ({ onSearch }) => {
  const [query, setQuery] = useState('');

  useEffect(() => {
    const timer = setTimeout(() => {
      onSearch(query);
    }, 500);
    return () => clearTimeout(timer);
  }, [query, onSearch]);

  return (
    <header style={styles.header}>
      <div style={styles.logo}>
        <span style={styles.logoText}>GIF HUNTER</span>
      </div>
      <div style={styles.searchContainer}>
        <input
          type="text"
          placeholder="Search all the GIFs"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          style={styles.searchInput}
        />
      </div>
    </header>
  );
};

const styles: { [key: string]: React.CSSProperties } = {
  header: {
    display: 'flex',
    alignItems: 'center',
    padding: '20px 40px',
    backgroundColor: '#0a0a0a',
    position: 'sticky',
    top: 0,
    zIndex: 100,
    borderBottom: '1px solid #222',
  },
  logo: {
    marginRight: '40px',
  },
  logoText: {
    color: '#ff8c00',
    fontSize: '24px',
    fontWeight: 'bold',
    letterSpacing: '2px',
  },
  searchContainer: {
    flex: 1,
    maxWidth: '800px',
  },
  searchInput: {
    width: '100%',
    padding: '12px 20px',
    borderRadius: '8px',
    border: 'none',
    backgroundColor: '#1a1a1a',
    color: 'white',
    fontSize: '16px',
    outline: 'none',
  },
};
