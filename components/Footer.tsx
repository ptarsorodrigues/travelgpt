export default function Footer() {
  return (
    <footer className="footer">
      <div className="footer-inner">
        <div className="footer-logo">
          <span className="gradient-text">TravelGPT</span>
        </div>
        <div className="footer-text">
          © {new Date().getFullYear()} TravelGPT. Descubra o mundo ao seu redor.
        </div>
      </div>
    </footer>
  );
}
