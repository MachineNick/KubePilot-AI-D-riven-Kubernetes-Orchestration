const express = require('express');
const os = require('os');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('KubePilot example app - healthy');
});

app.get('/health', (req, res) => {
  res.json({status: 'ok', host: os.hostname()});
});

app.get('/info', (req, res) => {
  res.json({
    service: 'kube-pilot-example',
    version: '0.1.0',
    node: os.hostname()
  });
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
