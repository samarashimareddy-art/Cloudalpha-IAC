'use strict';

const { createServer } = require('./app');

const PORT = Number(process.env.PORT) || 3000;

createServer().listen(PORT, () => {
  console.log(`cloudalpha-demo-app listening on port ${PORT}`);
});
