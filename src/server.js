const http = require('http');
const bunyan = require('bunyan');
const readLine = require('readline');

const name = 'hello-stage';
const log = bunyan.createLogger({ name });
const port = 8124;

const app = new http.Server();

app.on('request', (req, res) => {
  log.info(`received ${req.method} request.`);
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.write('hello, world');
  res.end('\n');
});

// https://stackoverflow.com/questions/10021373/what-is-the-windows-equivalent-of-process-onsigint-in-node-js
if (process.platform === 'win32') {
  const rl = readLine.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  rl.on('SIGINT', () => {
    process.emit('SIGINT');
  });
}

process.on('SIGINT', () => {
  log.info('SIGINT signal received.');
});

app.listen(port, () => {
  log.info(`${name} listening on port ${port}.`);
});
