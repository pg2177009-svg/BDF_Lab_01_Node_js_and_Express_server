const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware to log incoming requests and the outgoing status codes
app.use((req, res, next) => {
  res.on('finish', () => {
    console.log(`[Express Server] ${req.method} ${req.originalUrl} - Status: ${res.statusCode}`);
  });
  next();
});

// Route: GET / - Welcome text
app.get('/', (req, res) => {
  res.status(200).send('Welcome to the Node.js & Express Server!');
});

// Route: GET /about - JSON with name and section
app.get('/about', (req, res) => {
  res.status(200).json({
    name: 'Joel Prashanth D / Student Name',
    registrationNumber: 'REG12345678',
    section: 'CSE - Section A',
    course: 'Backend Development Fundamentals',
    term: 'Year II Term II'
  });
});

// Route: GET /time - Current date and time using new Date()
app.get('/time', (req, res) => {
  const now = new Date();
  res.status(200).json({
    iso: now.toISOString(),
    localString: now.toLocaleString(),
    timestamp: now.getTime()
  });
});

// 404 handler for any unknown path
app.use((req, res) => {
  res.status(404).json({
    error: '404 Not Found',
    message: `The requested endpoint '${req.originalUrl}' does not exist on this server.`
  });
});

// Start the Express server
app.listen(PORT, () => {
  console.log(`[Express Server] Server running at http://localhost:${PORT}/`);
  console.log(`Available routes:`);
  console.log(` - GET  /       (Welcome message)`);
  console.log(` - GET  /about  (Student JSON details)`);
  console.log(` - GET  /time   (Current date & time)`);
});

