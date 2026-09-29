'use strict';

const test = require('node:test');
const assert = require('node:assert');
const { createServer } = require('../src/app');

async function withServer(fn) {
  const server = createServer().listen(0);
  await new Promise((resolve) => server.once('listening', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;
  try {
    await fn(base);
  } finally {
    server.close();
  }
}

test('GET /health returns ok', async () => {
  await withServer(async (base) => {
    const res = await fetch(`${base}/health`);
    assert.strictEqual(res.status, 200);
    assert.strictEqual((await res.json()).status, 'ok');
  });
});

test('GET /api/greeting uses the name parameter', async () => {
  await withServer(async (base) => {
    const res = await fetch(`${base}/api/greeting?name=Raj`);
    assert.strictEqual(res.status, 200);
    assert.strictEqual((await res.json()).message, 'Hello, Raj!');
  });
});

test('unknown route returns 404', async () => {
  await withServer(async (base) => {
    const res = await fetch(`${base}/nope`);
    assert.strictEqual(res.status, 404);
  });
});
