# Hacia Adentro — Guía de configuración

## Estructura del proyecto

```
hacia-adentro/
├── app/
│   └── index.html        ← La app que ve tu madre
├── admin/
│   └── index.html        ← Tu panel de administración
└── sql/
    └── schema.sql        ← Esquema de la base de datos
```

---

## Paso 1 — Crear el proyecto en Supabase (5 min)

1. Ve a https://supabase.com y crea una cuenta gratuita
2. Crea un nuevo proyecto (elige nombre y región, p.ej. "West EU")
3. Espera ~2 minutos a que se inicialice
4. Ve a **SQL Editor** y pega todo el contenido de `sql/schema.sql`
5. Pulsa **Run** — se creará la tabla, la vista y las políticas de seguridad

---

## Paso 2 — Obtener las claves de API

1. En tu proyecto Supabase, ve a **Settings → API**
2. Copia:
   - **Project URL** → es tu `SUPABASE_URL`
   - **anon / public key** → es tu `SUPABASE_ANON_KEY`

---

## Paso 3 — Configurar los dos archivos HTML

Abre `app/index.html` y `admin/index.html` y reemplaza las dos constantes al inicio del script:

```js
const SUPABASE_URL      = 'https://TU_PROYECTO.supabase.co';  // ← tu Project URL
const SUPABASE_ANON_KEY = 'TU_ANON_KEY';                      // ← tu anon key
```

---

## Paso 4 — Crear tu usuario administrador

1. En Supabase, ve a **Authentication → Users**
2. Pulsa **Invite user** e introduce tu email
3. Recibirás un email — sigue el enlace para establecer tu contraseña
4. Usa ese email y contraseña para entrar en el panel admin

---

## Paso 5 — Publicar en GitHub Pages

### Primera vez:
```bash
git init
git add .
git commit -m "Hacia Adentro — primera versión"
git remote add origin https://github.com/TU_USUARIO/hacia-adentro.git
git push -u origin main
```

### Activar GitHub Pages:
1. Ve a tu repo en GitHub → **Settings → Pages**
2. Source: **Deploy from a branch**
3. Branch: `main` / folder: `/ (root)`
4. Guarda — en ~2 min tendrás dos URLs:
   - `https://TU_USUARIO.github.io/hacia-adentro/app/` → para tu madre
   - `https://TU_USUARIO.github.io/hacia-adentro/admin/` → tu panel

### Para actualizar después:
```bash
git add .
git commit -m "actualizar contenido"
git push
```

---

## Flujo de uso diario

```
Tú abres admin/index.html
  → Pegas un enlace de YouTube / Spotify / Drive
  → Eliges sección y (si es Radio) el tema
  → Pulsas "Publicar"
  
Tu madre abre app/index.html
  → El contenido aparece automáticamente en la sección correcta
  → Pulsa cualquier tarjeta para verlo o escucharlo sin salir de la app
```

---

## Notas importantes

### Google Drive
- Los archivos deben tener permisos **"Cualquiera con el enlace puede ver"**
- El enlace debe ser el de la carpeta o el archivo directo (no una carpeta compartida general)

### YouTube
- Puedes usar vídeos **públicos** de cualquier canal (Sadhguru, Osho, etc.)
- O vídeos **no listados** propios — solo quien tenga el enlace los ve

### Spotify
- Tu madre necesita tener **Spotify abierto** en el navegador o en la app del móvil
- Con Premium, la escucha es completa desde el embed
- El embed de Spotify funciona mejor en Chrome/Safari

### Seguridad
- La `anon key` de Supabase es segura para exponer en el frontend — solo puede leer contenido publicado (gracias a las políticas RLS del schema.sql)
- Solo tú puedes escribir, porque el panel requiere autenticación
