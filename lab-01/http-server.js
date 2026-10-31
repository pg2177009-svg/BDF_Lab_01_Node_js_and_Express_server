const http = require('http');

const PORT = 3000;

// Create HTTP server
const server = http.createServer((req, res) => {
  console.log(`[HTTP Server] Received request: ${req.method} ${req.url}`);
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello');
});

// Listen on port 3000
server.listen(PORT, () => {
  console.log(`[HTTP Server] Server is running at http://localhost:${PORT}/`);
});

