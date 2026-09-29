'use strict';

const http = require('node:http');

const VERSION = process.env.APP_VERSION || '1.0.0';

function handler(req, res) {
  const url = new URL(req.url, 'http://localhost');

  if (req.method === 'GET' && url.pathname === '/health') {
    return send(res, 200, { status: 'ok', version: VERSION });
  }

  if (req.method === 'GET' && url.pathname === '/api/greeting') {
    const name = (url.searchParams.get('name') || 'world').slice(0, 50);
    return send(res, 200, { message: `Hello, ${name}!` });
  }

  return send(res, 404, { error: 'Not found' });
}

function send(res, status, body) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(body));
}

function createServer() {
  return http.createServer(handler);
}

module.exports = { createServer, VERSION };
