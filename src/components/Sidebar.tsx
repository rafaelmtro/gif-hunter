import React from 'react';

interface SidebarProps {
  tags: string[];
  onTagClick: (tag: string) => void;
  favoritesCount: number;
  onOpenFavorites: () => void;
}

export const Sidebar: React.FC<SidebarProps> = ({ tags, onTagClick, favoritesCount, onOpenFavorites }) => {
  return (
    <aside style={styles.aside}>
      <div style={styles.section} onClick={onOpenFavorites}>
        <h2 style={styles.sectionTitle}>FAVORITES ({favoritesCount})</h2>
      </div>
      <div style={styles.section}>
        <h2 style={styles.sectionTitle}>TRENDING TAGS</h2>
        <div style={styles.tagList}>
          {tags.map((tag) => (
            <div
              key={tag}
              style={styles.tag}
              onClick={() => onTagClick(tag)}
            >
              # {tag}
            </div>
          ))}
        </div>
      </div>
    </aside>
  );
};

const styles: { [key: string]: React.CSSProperties } = {
  aside: {
    width: '300px',
    padding: '20px',
    borderLeft: '1px solid #222',
    backgroundColor: '#0a0a0a',
    height: 'calc(100vh - 85px)',
    position: 'sticky',
    top: '85px',
    overflowY: 'auto',
  },
  section: {
    marginBottom: '30px',
  },
  sectionTitle: {
    fontSize: '14px',
    color: '#ff8c00',
    letterSpacing: '1px',
    marginBottom: '15px',
    cursor: 'pointer',
  },
  tagList: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
  },
  tag: {
    fontSize: '14px',
    color: '#a0a0a0',
    cursor: 'pointer',
    transition: 'color 0.2s',
  },
};
