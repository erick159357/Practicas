import express from 'express';
import os from 'os';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// Variables de entorno que diferenciarán cada servidor
const SERVER_ID = process.env.SERVER_ID || 'Servidor Local';
const SERVER_COLOR = process.env.SERVER_COLOR || '#6c757d';

app.use(express.static(path.join(__dirname, 'public')));

// Endpoint que regresa la info del servidor
app.get('/info', (req, res) => {
  res.json({
    server_id: SERVER_ID,
    hostname: os.hostname(),
    color: SERVER_COLOR,
    timestamp: new Date().toISOString()
  });
});

// Endpoint de health check (lo usará el load balancer)
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', server: SERVER_ID });
});

app.listen(PORT, () => {
  console.log(`🚀 ${SERVER_ID} corriendo en puerto ${PORT}`);
});