# PauLauncher

Launcher de Minecraft **diseñado para DoctoraPaula**.

- **Se optimiza solo**: ajusta la RAM, los flags JVM y el rendimiento automáticamente según la versión del juego, los mods instalados y el modo en uso (incluido el modo streamer).
- Escrito en **Rust + Tauri v2** (backend en Rust; frontend en HTML, CSS y JavaScript, sin Node).
- Diseño neumórfico en rosa `#FF9EEA`, lila `#D59EFF` y menta `#9EFFEA`.

## Compilar

```powershell
cd src-tauri
cargo build --release
```

Resultado: `src-tauri\target\release\PauLauncher.exe`.