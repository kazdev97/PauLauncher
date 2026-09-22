# PauLauncher

Launcher de Minecraft en **Rust + Tauri v2**, diseñado para que el owner (Kaz) controle la experiencia de los jugadores:

- **Actualiza mods**, reemplaza `config/` y aplica cambios en cada instancia **de forma visible** y con **backup/rollback** (nada de ejecución remota ni oculta).
- Las instancias se distribuyen **como manifiestos hash-verificados** (SHA-256) publicados en **Google Drive, GitHub o cualquier URL directa**.
- Login **Microsoft/Minecraft** (OAuth2 + PKCE + XBL/XSTS) reutilizando el `client_id` del KazLauncher.
- **Java Adoptium** descargado automáticamente según la versión de Minecraft (8/17/21), sin permisos de administrador.
- Flags **JVM de optimización** por versión, RAM y nº de mods (modo streamer incluido).
- Diseño **neumórfico** en rosa `#FF9EEA`, lila `#D59EFF` y menta `#9EFFEA`.
- Frontend **sin Node**: HTML/CSS/JS plano con `withGlobalTauri`.

## Cómo funciona el control del owner

1. **Publicar**: en la pestaña *Estudio* el owner exporta una instancia → genera
   `manifest.json` (lista de archivos + SHA-256 + revisión) y `PauPack-<nombre>.pau.zip`
   (contenido bajo `files/`).
2. **Subir**: se suben los 2 ficheros a Google Drive (o GitHub). En Drive usa el enlace
   directo `https://drive.google.com/uc?export=download&id=FILE_ID`.
3. **Dar la URL**: el jugador pega la URL del `manifest.json` al crear su instancia
   (campo "URL del manifest").
4. **Sincronizar**: el jugador pulsa *"Actualizar"* → el launcher **descarga solo el
   manifest pequeño**, compara hashes con la instancia local y muestra el **diff**
   (a añadir / reemplazar / eliminar). Al *"Aplicar"*:
   - crea un **backup** automático en `instancias/<nombre>/backups/<revisión>/`,
   - descarga el `.pau.zip`, copia solo lo que cambió,
   - elimina los mods retirados (solo dentro de carpetas gestionadas: `mods/`,
     `config/`, `resourcepacks/`),
   - **nunca toca** `saves/`, `versions/`, `libraries/`, `assets/`, `logs/`, `options.txt`.
5. **Rollback**: en *Ajustes → Backups* el jugador puede restaurar cualquier revisión.

Cada archivo es **público y auditable**: los SHA-256 y el diff se muestran antes de
aplicar. El jugador siempre confirma. No hay acceso remoto ni ejecución silenciosa.

## Estructura del proyecto

```
PauLauncher/
├─ src/                     # Frontend estático (HTML/CSS/JS, sin build)
│  ├─ index.html
│  ├─ styles.css
│  └─ main.js
├─ src-tauri/
│  ├─ Cargo.toml
│  ├─ tauri.conf.json
│  ├─ capabilities/default.json
│  ├─ icons/                # generados por tools/generate_icons.ps1
│  └─ src/
│     ├─ main.rs            # entry point (llama a lib.rs::run)
│     ├─ lib.rs             # comandos tauri + registro de módulos
│     ├─ config.rs          # rutas (Documentos\PauLauncher), settings, cuentas
│     ├─ auth.rs            # login Microsoft (PKCE, XBL/XSTS/Minecraft)
│     ├─ downloader.rs      # descargas con reintentos + SHA-256
│     ├─ java.rs            # Adoptium por versión + búsqueda/validación
│     ├─ jvm.rs             # flags JVM optimizados (port de Kaz)
│     ├─ installer.rs       # instalación Vanilla + Fabric (Mojang + meta.fabricmc)
│     ├─ instances.rs       # registro/escan/eo de instancias
│     ├─ sync.rs            # motor de sincronización (manifest + diff + backup)
│     ├─ packager.rs        # exporta instancia a .pau + manifest.json
│     └─ launch.rs          # resolución de version.json, classpath y proceso
└─ tools/
   └─ generate_icons.ps1    # iconos necesarios para compilar
```

## Requisitos para compilar

El frontend no necesita Node. Para compilar el binario:

1. **Rust** (rustup): `https://rustup.rs` → instalar con perfil por defecto (MSVC toolchain).
   - Si falta el linker MSVC, instalarlo de: `winget install Microsoft.VisualStudio.2022.BuildTools`
     y marcar "Herramientas de compilación de C++".
2. **WebView2** (Windows 10/11 ya lo incluye, si no: `winget install Microsoft.WebView2Runtime`).
3. Compilar:

```powershell
cd C:\Users\kaz\Documents\CODIGO LIMPIO\PauLauncher\src-tauri
cargo build --release
```

Resultado: `src-tauri\target\release\PauLauncher.exe`.

Instalador NSIS (opcional):

```powershell
cargo install tauri-cli
cd C:\Users\kaz\Documents\CODIGO LIMPIO\PauLauncher\src-tauri
cargo tauri build
```

## Datos del launcher

Todo vive en `Documentos\PauLauncher\`:

```
Documentos\PauLauncher\
├─ accounts.json        # cuentas Microsoft (token + refresh)
├─ settings.json        # ajustes gráficos
├─ instancias\<nombre>\ # instancias
│  ├─ kazu_instance.json
│  ├─ mods/ config/ saves/ resourcepacks/
│  ├─ versions/ libraries/ assets/
│  └─ backups\<revisión>/
└─ runtime\jdk-<major>\ # Java portátil descargado
```

## Cuenta de Azure (importante)

El login usa el `client_id` de la app Azure (heredado de KazLauncher), que **no
está en el repositorio**: se inyecta al compilar desde `src-tauri/client_id.env`
(archivo local git-ignoreado, solo el texto del ID) o la variable de entorno
`PAU_CLIENT_ID`. El `redirect_uri` registrado es `http://localhost:<8080-8089>/callback`.
Si se registra una app de Azure nueva, asegurarse de:

- Type: **Mobile and desktop applications** (permite loopbacks sin HTTPS).
- Redirect URI: `http://localhost:<puerto>/callback`.
- Permisos de API: `XboxLive.signin` + `offline_access` (Microsoft Graph delegado),
  y la cuenta de Windows Store/partner (Xbox) como en KazLauncher.

## Notas de implementación

- La consola del juego (stdout/stderr) se transmite en vivo vía evento `launch/line`.
- El diff de actualización gestiona solo `mods/`, `config/`, `resourcepacks/` por
  defecto (configurable en el manifest). Las carpetas protegidas nunca se tocan.
- El instalador de Fabric usa `meta.fabricmc.net` para el perfil y `maven.fabricmc.net`
  para el jar del loader.
- Modrinth como fuente de mods individuales está pendiente (ver TODOs en el código).