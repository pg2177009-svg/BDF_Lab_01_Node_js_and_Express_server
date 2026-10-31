const http = require('http');
const { spawn } = require('child_process');

function makeRequest(url) {
  return new Promise((resolve, reject) => {
    http.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          headers: res.headers,
          body: data
        });
      });
    }).on('error', reject);
  });
}

async function runTests() {
  console.log('--- 1. TESTING PLAIN HTTP SERVER ---');
  const httpServer = spawn(process.execPath, ['http-server.js'], { cwd: __dirname });
  httpServer.stdout.on('data', d => process.stdout.write(`[http-server stdout] ${d}`));
  httpServer.stderr.on('data', d => process.stderr.write(`[http-server stderr] ${d}`));

  await new Promise(r => setTimeout(r, 1000));
  try {
    const res = await makeRequest('http://localhost:3000/');
    console.log(`HTTP Server -> Status: ${res.statusCode}, Body: ${res.body}`);
  } finally {
    httpServer.kill();
  }

  await new Promise(r => setTimeout(r, 1000));

  console.log('\n--- 2. TESTING EXPRESS SERVER ---');
  const expressServer = spawn(process.execPath, ['index.js'], { cwd: __dirname });
  expressServer.stdout.on('data', d => process.stdout.write(`[express-server stdout] ${d}`));
  expressServer.stderr.on('data', d => process.stderr.write(`[express-server stderr] ${d}`));

  await new Promise(r => setTimeout(r, 1000));
  try {
    const routes = ['/', '/about', '/time', '/unknown-route'];
    for (const route of routes) {
      const res = await makeRequest(`http://localhost:3000${route}`);
      console.log(`\nRoute: GET ${route}`);
      console.log(`Status Code: ${res.statusCode}`);
      console.log(`Response Body: ${res.body}`);
    }
  } finally {
    expressServer.kill();
  }

  console.log('\n--- ALL TESTS COMPLETED SUCCESSFULLY ---');
}

runTests().catch(err => {
  console.error('Test error:', err);
  process.exit(1);
});

