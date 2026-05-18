require("dotenv").config();
const express = require("express");
const cors = require("cors");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const speakeasy = require("speakeasy");
const QRCode = require("qrcode");

const { sql, pool, poolConnect } = require("./db");
const {
  sendVerificationEmail,
  sendPasswordChangeEmail,
  sendContactFormToAdmin,
  sendAutoReplyToUser,
} = require("./mailer");

const app = express();
app.use(cors({ origin: "http://127.0.0.1:5500" }));
app.use(express.json());

app.get("/", (req, res) => {
  res.send("¡Servidor Clima JS en línea!");
});

// -----------------------------
// Middleware de autenticación
// -----------------------------
function authenticateToken(req, res, next) {
  const auth = req.headers["authorization"];
  const token = auth && auth.split(" ")[1];
  if (!token) return res.status(401).json({ mensaje: "Token requerido." });

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ mensaje: "Token inválido o expirado." });
    req.user = user;
    next();
  });
}

// — Registro
app.post("/registro", async (req, res) => {
  const { nombre, email, password } = req.body;
  if (!nombre || !email || !password)
    return res.status(400).json({ mensaje: "Todos los campos son obligatorios." });
  if (password.length < 6)
    return res.status(400).json({ mensaje: "La contraseña debe tener al menos 6 caracteres." });

  const token = Math.random().toString(36).substring(2, 66);
  const hashed = await bcrypt.hash(password, 10);

  try {
    await poolConnect;
    // Verificar correo único
    const { recordset: regCheck } = await pool
      .request()
      .input("email", sql.VarChar, email)
      .query("SELECT COUNT(*) AS total FROM usuarios WHERE email=@email");
    if (regCheck[0].total > 0)
      return res.status(400).json({ mensaje: "Correo ya registrado." });

    // Insert
    await pool
      .request()
      .input("nombre", sql.VarChar, nombre)
      .input("email", sql.VarChar, email)
      .input("password", sql.VarChar, hashed)
      .input("token", sql.VarChar, token)
      .query(
        `INSERT INTO usuarios (nombre,email,contraseña,token,confirmado,mfa_enabled)
         VALUES (@nombre,@email,@password,@token,0,0)`
      );

    // Envío de correo
    await sendVerificationEmail(email, token);
    res.status(201).json({
      mensaje: "Registro exitoso. Revisa tu correo para verificar tu cuenta.",
    });
  } catch (err) {
    console.error("Error en /registro:", err);
    res.status(500).json({ mensaje: "Error al registrar usuario." });
  }
});

// — Verificación de cuenta
app.get("/verificar/:token", async (req, res) => {
  const { token } = req.params;
  try {
    await poolConnect;
    const { rowsAffected } = await pool
      .request()
      .input("token", sql.VarChar, token)
      .query("UPDATE usuarios SET confirmado=1 WHERE token=@token AND confirmado=0");

    if (rowsAffected[0] > 0) {
      res.send("✅ Cuenta verificada con éxito. Ya puedes iniciar sesión.");
    } else {
      res.send("❌ Token inválido o cuenta ya verificada.");
    }
  } catch (err) {
    console.error("Error en /verificar:", err);
    res.status(500).send("Error al verificar el token.");
  }
});

// — Login (con MFA opcional)
app.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).json({ mensaje: "Ingresa email y contraseña." });

  try {
    await poolConnect;
    const { recordset } = await pool
      .request()
      .input("email", sql.VarChar, email)
      .query(
        "SELECT id, nombre, contraseña, confirmado, mfa_enabled FROM usuarios WHERE email=@email"
      );
    const user = recordset[0];
    if (!user || !user.confirmado)
      return res.status(400).json({ mensaje: "Usuario no existe o no ha confirmado aún." });

    const match = await bcrypt.compare(password, user.contraseña);
    if (!match)
      return res.status(400).json({ mensaje: "Contraseña incorrecta." });

    if (user.mfa_enabled) {
      // Generar token temporal para etapa MFA
      const tempToken = jwt.sign(
        { id: user.id, stage: "mfa" },
        process.env.JWT_SECRET,
        { expiresIn: "10m" }
      );
      return res.json({
        mensaje: "MFA requerido.",
        mfaRequired: true,
        tempToken,
      });
    }

    // Si no tiene MFA activado, se emite el JWT normal
    const sessionToken = jwt.sign(
      { id: user.id, nombre: user.nombre },
      process.env.JWT_SECRET,
      { expiresIn: "2h" }
    );
    res.json({ mensaje: "Login exitoso.", token: sessionToken });
  } catch (err) {
    console.error("Error en /login:", err);
    res.status(500).json({ mensaje: "Error al iniciar sesión." });
  }
});

// — Login MFA (segunda etapa)
app.post("/login/mfa", async (req, res) => {
  const authHeader = req.headers["authorization"];
  const tempToken = authHeader && authHeader.split(" ")[1];
  if (!tempToken) return res.status(401).json({ mensaje: "Token requerido." });

  jwt.verify(tempToken, process.env.JWT_SECRET, async (err, decoded) => {
    if (err) return res.status(403).json({ mensaje: "Token inválido o expirado." });
    if (decoded.stage !== "mfa")
      return res.status(400).json({ mensaje: "Solicitud inválida." });

    const { token } = req.body; // OTP
    const userId = decoded.id;
    try {
      await poolConnect;
      const { recordset } = await pool
        .request()
        .input("id", sql.Int, userId)
        .query("SELECT mfa_secret, nombre FROM usuarios WHERE id=@id");
      if (!recordset.length)
        return res.status(404).json({ mensaje: "Usuario no encontrado." });

      const secret = recordset[0].mfa_secret.trim();
      const verified = speakeasy.totp.verify({
        secret,
        encoding: "base32",
        token,
        window: 1,
      });
      if (!verified)
        return res.status(400).json({ mensaje: "Código MFA inválido." });

      // Generar JWT de sesión definitivo
      const sessionToken = jwt.sign(
        { id: userId, nombre: recordset[0].nombre },
        process.env.JWT_SECRET,
        { expiresIn: "2h" }
      );
      res.json({ mensaje: "Login exitoso.", token: sessionToken });
    } catch (error) {
      console.error("Error en /login/mfa:", error);
      res.status(500).json({ mensaje: "Error al procesar MFA." });
    }
  });
});

app.get("/mfa/setup", authenticateToken, async (req, res) => {
  const userId = req.user.id;
  await poolConnect;
  const { recordset } = await pool
    .request()
    .input("id", sql.Int, userId)
    .query("SELECT mfa_secret, nombre FROM usuarios WHERE id=@id");

  let base32 = recordset[0].mfa_secret?.trim();
  if (!base32) {
    const secret = speakeasy.generateSecret({
      name: `ClimaJS (${recordset[0].nombre})`,
    });
    base32 = secret.base32;
    await pool
      .request()
      .input("id", sql.Int, userId)
      .input("secret", sql.VarChar(128), base32)
      .query("UPDATE usuarios SET mfa_secret=@secret WHERE id=@id");
  }

  const otpauth_url = speakeasy.otpauthURL({
    secret: base32,
    label: `ClimaJS (${recordset[0].nombre})`,
    issuer: "ClimaJS",
    encoding: "base32",
  });
  const qrData = await QRCode.toDataURL(otpauth_url);
  res.json({ qrData });
});



// — MFA Verify Setup: activación definitiva
app.post("/mfa/verify-setup", authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const { token } = req.body;
  try {
    await poolConnect;
    const { recordset } = await pool
      .request()
      .input("id", sql.Int, userId)
      .query("SELECT mfa_secret FROM usuarios WHERE id=@id");
    if (!recordset.length)
      return res.status(404).json({ mensaje: "Usuario no encontrado." });

    const secret = recordset[0].mfa_secret.trim();
    const verified = speakeasy.totp.verify({
      secret,
      encoding: "base32",
      token,
      window: 1,
    });
    if (!verified)
      return res.status(400).json({ mensaje: "Código MFA inválido." });

    // Activar MFA
    await pool
      .request()
      .input("id", sql.Int, userId)
      .query("UPDATE usuarios SET mfa_enabled=1 WHERE id=@id");
    res.json({ mensaje: "MFA activado correctamente." });
  } catch (err) {
    console.error("Error en /mfa/verify-setup:", err);
    res.status(500).json({ mensaje: "Error al verificar MFA." });
  }
});

// — Perfil (protegido)
app.get("/perfil", authenticateToken, async (req, res) => {
  res.json({ nombre: req.user.nombre, id: req.user.id });
});

// — Contacto
app.post("/contacto", async (req, res) => {
  console.log("▶️ /contacto recibida:", req.body);
  const { name, email, category, message } = req.body;
  try {
    await sendContactFormToAdmin({ name, email, category, message });
    console.log("✉️ Enviado al admin");
    await sendAutoReplyToUser({ name, email });
    console.log("✉️ Acuse enviado al usuario");
    return res.json({ mensaje: "Mensaje enviado correctamente." });
  } catch (err) {
    console.error("❌ Error en /contacto:", err);
    return res.status(500).json({ mensaje: "Error al enviar tu mensaje." });
  }
});

// — Cambiar contraseña
app.post("/cambiar-contrasena", authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const { currentPassword, newPassword } = req.body;
  try {
    await poolConnect;
    const result = await pool
      .request()
      .input("id", sql.Int, userId)
      .query("SELECT contraseña, email FROM usuarios WHERE id=@id");
    if (result.recordset.length === 0) {
      return res.status(404).json({ mensaje: "Usuario no encontrado." });
    }
    const { contraseña: hashEnDB, email } = result.recordset[0];
    const match = await bcrypt.compare(currentPassword, hashEnDB);
    if (!match) {
      return res.status(401).json({ mensaje: "Contraseña actual incorrecta." });
    }
    const salt = await bcrypt.genSalt(10);
    const newHash = await bcrypt.hash(newPassword, salt);
    await pool
      .request()
      .input("id", sql.Int, userId)
      .input("password", sql.VarChar, newHash)
      .query("UPDATE usuarios SET contraseña = @password WHERE id = @id");
    const fechaCambio = new Date().toLocaleString();
    await sendPasswordChangeEmail(email, fechaCambio);
    res.json({ mensaje: "Contraseña cambiada con éxito." });
  } catch (err) {
    console.error("Error en /cambiar-contrasena:", err);
    res.status(500).json({ mensaje: "Error al cambiar contraseña." });
  }
});

// — Levantar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor en el puerto ${PORT}`));







