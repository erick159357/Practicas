import express from 'express';
import bcrypt from 'bcrypt';
import session from 'express-session';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import pool from './db.js';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 1000 * 60 * 60 } // 1 hora
}));

// Ruta principal -> redirige al login
app.get('/', (req, res) => {
  res.redirect('/login.html');
});

// Registro de usuario
app.post('/api/registro', async (req, res) => {
  const { nombre, email, password } = req.body;
  if (!nombre || !email || !password) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios' });
  }

  try {
    const hash = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO usuarios (nombre, email, password) VALUES ($1, $2, $3) RETURNING id, nombre, email',
      [nombre, email, hash]
    );
    res.json({ mensaje: 'Usuario registrado correctamente', usuario: result.rows[0] });
  } catch (error) {
    if (error.code === '23505') {
      return res.status(400).json({ error: 'El email ya está registrado' });
    }
    console.error(error);
    res.status(500).json({ error: 'Error al registrar usuario' });
  }
});

// Login
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email y contraseña son obligatorios' });
  }

  try {
    const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    const usuario = result.rows[0];
    const passwordValido = await bcrypt.compare(password, usuario.password);

    if (!passwordValido) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    req.session.usuario = { id: usuario.id, nombre: usuario.nombre, email: usuario.email };
    res.json({ mensaje: 'Login exitoso', usuario: req.session.usuario });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al iniciar sesión' });
  }
});

// Página protegida
app.get('/inicio.html', (req, res) => {
  if (!req.session.usuario) {
    return res.redirect('/login.html');
  }
  res.sendFile(path.join(__dirname, 'public', 'inicio.html'));
});

// Obtener datos del usuario en sesión
app.get('/api/usuario', (req, res) => {
  if (!req.session.usuario) {
    return res.status(401).json({ error: 'No autenticado' });
  }
  res.json(req.session.usuario);
});

// Cerrar sesión
app.post('/api/logout', (req, res) => {
  req.session.destroy();
  res.json({ mensaje: 'Sesión cerrada' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});