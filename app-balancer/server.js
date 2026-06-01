import express from 'express';
import http from 'http';
import os from 'os';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

function peticionMetadatos(metodo, ruta, cabeceras = {}) {
  return new Promise((resolver, rechazar) => {
    const req = http.request(
      {
        host: '169.254.169.254',
        port: 80,
        path: ruta,
        method: metodo,
        headers: cabeceras,
        timeout: 1000
      },
      (res) => {
        let datos = '';
        res.on('data', (parte) => (datos += parte));
        res.on('end', () => resolver(datos.trim()));
      }
    );
    req.on('error', rechazar);
    req.on('timeout', () => {
      req.destroy();
      rechazar(new Error('timeout'));
    });
    req.end();
  });
}

async function obtenerMetadatos() {
  try {
    const token = await peticionMetadatos('PUT', '/latest/api/token', {
      'X-aws-ec2-metadata-token-ttl-seconds': '21600'
    });
    const cabeceras = { 'X-aws-ec2-metadata-token': token };
    const id = await peticionMetadatos('GET', '/latest/meta-data/instance-id', cabeceras);
    const zona = await peticionMetadatos('GET', '/latest/meta-data/placement/availability-zone', cabeceras);
    const tipo = await peticionMetadatos('GET', '/latest/meta-data/instance-type', cabeceras);
    return { id, zona, tipo };
  } catch (err) {
    return { id: 'local-' + os.hostname(), zona: 'sin-nube', tipo: 'local' };
  }
}

function colorDesdeId(texto) {
  let hash = 0;
  for (let i = 0; i < texto.length; i++) {
    hash = texto.charCodeAt(i) + ((hash << 5) - hash);
  }
  const matiz = Math.abs(hash) % 360;
  return `hsl(${matiz}, 60%, 45%)`;
}

const META = await obtenerMetadatos();
META.color = colorDesdeId(META.id);

app.use(express.static(path.join(__dirname, 'public')));

app.get('/info', (req, res) => {
  res.json({
    id_instancia: META.id,
    zona: META.zona,
    tipo: META.tipo,
    color: META.color,
    hora: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', instancia: META.id });
});

app.listen(PORT, () => {
  console.log(`Servidor ${META.id} corriendo en el puerto ${PORT}`);
});
