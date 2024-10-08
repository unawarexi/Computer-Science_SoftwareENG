export const metadata = {
  title: "Next.js",
  description: "Generated by Next.js",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        {/* Header Section */}
        <header style={headerStyle}>
          <h1>Welcome to Next.js</h1>
        </header>

        {/* Main Content */}
        <main style={mainStyle}>{children}</main>

        {/* Footer Section */}
        <footer style={footerStyle}>
          <p>&copy; 2024 Next.js Application. All rights reserved.</p>
        </footer>
      </body>
    </html>
  );
}

// Inline styles for header, main, and footer
const headerStyle: React.CSSProperties = {
  backgroundColor: "#f8f9fa",
  padding: "10px",
  textAlign: "center",
  borderBottom: "1px solid #ddd",
};

const mainStyle: React.CSSProperties = {
  padding: "20px",
  minHeight: "40vh", // Ensures main content takes up the majority of the viewport
};

const footerStyle: React.CSSProperties = {
  backgroundColor: "#f8f9fa",
  padding: "10px",
  textAlign: "center",
  borderTop: "1px solid #ddd",
};
