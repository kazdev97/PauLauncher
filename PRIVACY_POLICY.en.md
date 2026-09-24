# Privacy Policy — PauLauncher

Last updated: September 23, 2026

This policy explains what data **PauLauncher** ("the launcher", "we") processes and for
what purpose. By using the application you agree to the practices described in this
document.

## 1. What the app does

PauLauncher is a Minecraft launcher for Windows that lets you sign in with your Microsoft
account, download and install Minecraft instances (modpacks distributed by the
developer) and launch the game. We do not sell data and we do not show ads.

## 2. Data we process

- **Your Microsoft/Minecraft account data.** When you sign in, the app acts as an
  intermediary between you and Microsoft: it exchanges the authorization code to obtain
  a token that allows Minecraft to launch with your profile (username, UUID, skin).
  This data is stored **only on your device**.
- **Local configuration and usage data.** App settings, downloaded instances, launcher
  and game logs. All of this is stored locally on your device and is never sent to
  developer servers.

## 3. Storage and deletion

Data is stored in your documents folder (`Documents\PauLauncher`). You can delete it at
any time:

- Signing out on the "Account" tab removes your stored credentials.
- Deleting an instance or the `PauLauncher` folder itself removes the rest of the local
  data.

There is no remote database and no copy of your credentials on our servers.

## 4. Third-party services

PauLauncher connects to the following services, over which we have no control. Each one
applies its own privacy policy:

| Service | Purpose |
| --- | --- |
| **Microsoft** (`login.microsoftonline.com`, `user.auth.xboxlive.com`, `xsts.auth.xboxlive.com`, `api.minecraftservices.com`) | Account authentication, Minecraft profile and game credentials. |
| **Mojang / Minecraft** | Launching the game with your session. |
| **GitHub** (`raw.githubusercontent.com`, `media.githubusercontent.com`) | Downloading modpack updates distributed by the developer. No personal data is sent. |
| **Discord** (Rich Presence) | Optional and disableable: shows what you are playing on your Discord profile. It can be turned off in Settings. |
| **Avatar/skin services** (`mc-heads.net`, `crafatar.com`, `minotar.net`) | Show your in-game skin in the interface based on your Minecraft name or UUID. |
| **Cloudflare WARP** (anti-lag mode) | Optional and disableable: opens a tunnel to the configured game server to reduce latency. No personal data is sent by the launcher. |

In all cases the connection is made directly from your device to these services as needed
for the application to work.

## 5. IP addresses and metadata

Like any connected application, when you use PauLauncher your device sends its IP address
to the servers it communicates with (Microsoft, GitHub, Discord, game servers, etc.). The
launcher does not collect or store these addresses.

## 6. Children

The app is not intentionally directed to children under 13 and does not knowingly collect
personal information from children. Parents or guardians can delete device data as
described in section 3.

## 7. Your rights

Depending on your region, you may have the right to access, correct or delete your data.
Because the information is stored on your own device, you can exercise these rights
directly from the app or by deleting the local data folder (section 3).

## 8. Changes to this policy

If this policy changes materially, we will update the date at the top of this document,
and the new version will be effective upon publication.

## 9. Contact

If you have questions about this policy or how we handle your data, contact us through
the official project repository `github.com/kazdev97/PauLauncher` or on X: `@EseDjKaz`.