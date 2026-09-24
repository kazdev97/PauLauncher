# Política de privacidad — PauLauncher

Última actualización: 23 de septiembre de 2026

Esta política explica qué datos trata **PauLauncher** ("el launcher", "nosotros"), un
launcher de Minecraft para Windows, y con qué finalidad. Al usar la aplicación aceptas
lo descrito en este documento.

## 1. Qué hace la aplicación

PauLauncher es una herramienta que te permite iniciar sesión con tu cuenta de Microsoft,
descargar e instalar instancias de Minecraft (packs de mods distribuidos por el
desarrollador) y lanzar el juego. No vendemos datos ni mostramos publicidad.

## 2. Datos que se tratan

- **Datos de tu cuenta de Microsoft/Minecraft.** Cuando inicias sesión, la aplicación
  actúa como intermediaria entre tú y Microsoft: intercambia el código de autorización
  para obtener un token que permite lanzar Minecraft con tu perfil (nombre de usuario,
  UUID, skin). Estos datos se guardan **solo en tu dispositivo**.
- **Datos de configuración y de uso local.** Ajustes de la aplicación, instancias
  descargadas, registros (logs) del launcher y del juego. Todos se almacenan
  localmente en tu equipo y no se envían a ningún servidor del desarrollador.

## 3. Almacenamiento y eliminación

Los datos se guardan en la carpeta de documentos del usuario
(`Documentos\PauLauncher`). Puedes eliminarlos en cualquier momento:

- Cerrar sesión en la pestaña "Cuenta" elimina tus credenciales guardadas.
- Eliminar una instancia o la propia carpeta `PauLauncher` elimina el resto de
  datos locales.

No existe ninguna base de datos remota ni copia de tus credenciales en nuestros
servidores.

## 4. Servicios de terceros

PauLauncher se conecta a los siguientes servicios, sobre los que no tenemos control.
Cada uno aplica su propia política de privacidad:

| Servicio | Finalidad |
| --- | --- |
| **Microsoft** (`login.microsoftonline.com`, `user.auth.xboxlive.com`, `xsts.auth.xboxlive.com`, `api.minecraftservices.com`) | Autenticación de tu cuenta, obtención del perfil de Minecraft y credenciales de juego. |
| **Mojang / Minecraft** | Lanzamiento del juego con tu sesión. |
| **GitHub** (`raw.githubusercontent.com`, `media.githubusercontent.com`) | Descarga de actualizaciones del modpack distribuido por el desarrollador. No recibe datos personales. |
| **Discord** (Rich Presence) | Opcional y desactivable: muestra en tu perfil de Discord el contenido que estás jugando. Se desactiva desde Ajustes. |
| **Servicios de avatar/skin** (`mc-heads.net`, `crafatar.com`, `minotar.net`) | Muestran tu skin en la interfaz a partir de tu nombre o UUID de Minecraft. |
| **Cloudflare WARP** (modo anti-lag) | Opcional y desactivable: establece un túnel hacia el servidor de juego configurado para reducir la latencia. No se envían datos personales por el launcher. |

En todos los casos la conexión se establece directamente desde tu dispositivo a estos
servicios según sea necesario para el funcionamiento de la aplicación.

## 5. Direcciones IP y metadatos

Como cualquier aplicación conectada, al usar PauLauncher tu dispositivo envía su
dirección IP a los servidores con los que se comunica (Microsoft, GitHub, Discord,
servidores de juego, etc.). El launcher no recopila ni almacena estas direcciones.

## 6. Menores

La aplicación no está dirigida intencionadamente a menores de 13 años ni recopila, de
forma deliberada, información personal de niños. Los padres o tutores pueden eliminar
los datos del dispositivo siguiendo el apartado 3.

## 7. Tus derechos

Dependiendo de tu región, puedes tener derecho a acceder, corregir o eliminar tus datos.
Como la información se guarda en tu propio dispositivo, puedes ejercer estos derechos
directamente desde la aplicación o eliminando la carpeta de datos locales (apartado 3).

## 8. Cambios en esta política

Si esta política cambia de forma sustancial, actualizaremos la fecha al principio de este
documento y la nueva versión será la vigente a partir de su publicación.

## 9. Contacto

Si tienes preguntas sobre esta política o sobre el tratamiento de tus datos, puedes
contactarnos a través del repositorio oficial del proyecto
`github.com/kazdev97/PauLauncher` o en nuestra cuenta de X: `@EseDjKaz`.