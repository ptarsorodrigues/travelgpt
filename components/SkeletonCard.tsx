export default function SkeletonCard() {
  return (
    <div className="listing-card skeleton">
      <div className="skeleton-image" />
      <div style={{ padding: '1.25rem' }}>
        <div className="skeleton-text" />
        <div className="skeleton-text short" />
        <div className="skeleton-text shorter" />
      </div>
    </div>
  );
}
