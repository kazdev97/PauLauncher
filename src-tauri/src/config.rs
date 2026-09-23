//! Rutas de datos y ajustes del launcher.
//! Terminal del puerto del port de KazLauncher (paths.py / settings.py): en vez de
//! '<Documentos>/Kaz Studio/KazLauncher' usamos '<Documentos>/PauLauncher'.
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::{Path, PathBuf};

/// identidad/nombre de la app (usado para nombres de carpeta)
pub const APP_NAME: &str = "PauLauncher";
/// metacarpeta interna en la que cada instancia guarda su manifest local
pub const INSTANCE_META_FILE: &str = "kazu_instance.json";

/// URL por defecto del índice de instancias disponibles (source).
/// Apunta a un repo GitHub público del owner:
/// raw.githubusercontent.com/<usuario>/<repo>/main/index.json
pub const DEFAULT_SOURCE_URL: &str =
    "https://raw.githubusercontent.com/kazdev97/Paucalipsis-2/main/index.json";

pub fn launcher_data_dir() -> PathBuf {
    let base = dirs::document_dir()
        .or_else(dirs::home_dir)
        .unwrap_or_else(|| PathBuf::from("."));
    let dir = base.join(APP_NAME);
    fs::create_dir_all(&dir).ok();
    dir
}

pub fn instances_dir() -> PathBuf {
    let dir = launcher_data_dir().join("instancias");
    fs::create_dir_all(&dir).ok();
    dir
}

/// Java portátil (Adoptium) descargado por el launcher
pub fn runtime_dir() -> PathBuf {
    let dir = launcher_data_dir().join("runtime");
    fs::create_dir_all(&dir).ok();
    dir
}

pub fn accounts_file() -> PathBuf {
    launcher_data_dir().join("accounts.json")
}

pub fn settings_file() -> PathBuf {
    launcher_data_dir().join("settings.json")
}

pub fn launcher_log_file() -> PathBuf {
    launcher_data_dir().join("paulauncher.log")
}

// ---------------------------------------------------------------------------
// Ajustes del usuario
// ---------------------------------------------------------------------------
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(default)]
pub struct Settings {
    pub ram_mb: u32,
    pub max_ram_mb: u32,
    pub java_path_override: String,
    pub streamer_mode: bool,
    pub close_launcher_after_launch: bool,
    pub game_res_width: u32,
    pub game_res_height: u32,
    pub fullscreen: bool,
    pub last_username: String,
    pub source_url: String,
    pub auto_update: bool,
    pub antilag_enabled: bool,
    pub antilag_host: String,
    pub discord_rpc_enabled: bool,
}

impl Default for Settings {
    fn default() -> Self {
        Settings {
            ram_mb: 4096,
            max_ram_mb: 0,
            java_path_override: String::new(),
            streamer_mode: true,
            close_launcher_after_launch: false,
            game_res_width: 0,
            game_res_height: 0,
            fullscreen: false,
            last_username: String::new(),
            source_url: DEFAULT_SOURCE_URL.to_string(),
            auto_update: true,
            antilag_enabled: false,
            antilag_host: String::new(),
            discord_rpc_enabled: true,
        }
    }
}

impl Settings {
    pub fn load() -> Self {
        let path = settings_file();
        if let Ok(text) = fs::read_to_string(&path) {
            if let Ok(s) = serde_json::from_str(&text) {
                return s;
            }
        }
        Settings::default()
    }

    pub fn save(&self) -> Result<(), String> {
        let path = settings_file();
        let json =
            serde_json::to_string_pretty(self).map_err(|e| format!("serialize settings: {e}"))?;
        fs::write(&path, json).map_err(|e| format!("guardar settings: {e}"))
    }

    /// RAM efectiva (MB) usando el maximum si se definió, sino ram_mb.
    pub fn effective_ram_mb(&self) -> u32 {
        if self.max_ram_mb > 0 {
            self.max_ram_mb
        } else {
            self.ram_mb
        }
    }
}

// ---------------------------------------------------------------------------
// Cuentas premium (multi-cuenta, port de account_store.py)
// ---------------------------------------------------------------------------
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Account {
    pub id: String,
    pub name: String,
    pub access_token: String,
    pub refresh_token: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct AccountStore {
    pub accounts: Vec<Account>,
    pub selected_id: String,
    pub mode: String, // "offline" | "online"
    #[serde(default)]
    pub offline_username: String,
}

impl AccountStore {
    pub fn load() -> Self {
        if let Ok(text) = fs::read_to_string(accounts_file()) {
            if let Ok(store) = serde_json::from_str(&text) {
                return store;
            }
        }
        AccountStore {
            accounts: Vec::new(),
            selected_id: String::new(),
            mode: "offline".to_string(),
            offline_username: String::new(),
        }
    }

    pub fn save(&self) -> Result<(), String> {
        let json = serde_json::to_string_pretty(self)
            .map_err(|e| format!("serialize accounts: {e}"))?;
        fs::write(accounts_file(), json).map_err(|e| format!("guardar cuentas: {e}"))
    }

    pub fn selected(&self) -> Option<&Account> {
        self.accounts.iter().find(|a| a.id == self.selected_id)
    }

    pub fn get(&self, account_id: &str) -> Option<&Account> {
        self.accounts.iter().find(|a| a.id == account_id)
    }

    /// Marca una cuenta como seleccionada (modo online).
    pub fn set_selected(&mut self, account_id: &str) -> Result<(), String> {
        if !self.accounts.iter().any(|a| a.id == account_id) {
            return Err("La cuenta no está en el almacén".to_string());
        }
        self.selected_id = account_id.to_string();
        self.mode = "online".to_string();
        self.save()
    }

    /// upsert_account: añade o actualiza y lo deja seleccionado en modo online.
    pub fn upsert(&mut self, account: Account) {
        let id = account.id.clone();
        if let Some(existing) = self.accounts.iter_mut().find(|a| a.id == id) {
            *existing = account;
        } else {
            self.accounts.push(account);
        }
        self.selected_id = id;
        self.mode = "online".to_string();
    }

    pub fn remove(&mut self, account_id: &str) {
        self.accounts.retain(|a| a.id != account_id);
        if self.selected_id == account_id {
            if let Some(first) = self.accounts.first() {
                self.selected_id = first.id.clone();
                self.mode = "online".to_string();
            } else {
                self.selected_id = String::new();
                self.mode = "offline".to_string();
            }
        }
    }
}

/// Cuenta "No premium": sesión offline con un nombre local y sin tokens de
/// Microsoft. La UUID se deriva del nombre (determinista, patrón habitual en
/// launchers) y el token queda vacío para que el cliente entre en modo legacy.
pub fn offline_account(username: &str) -> Account {
    let hash = crate::downloader::sha256_bytes(username.trim().as_bytes());
    let hex: String = hash.chars().take(32).collect();
    let uuid = format!(
        "{}-{}-{}-{}-{}",
        &hex[0..8],
        &hex[8..12],
        &hex[12..16],
        &hex[16..20],
        &hex[20..32]
    );
    Account {
        id: uuid,
        name: username.trim().to_string(),
        access_token: String::new(),
        refresh_token: String::new(),
    }
}

/// Utilidades de rutas usadas por varios módulos.
pub fn path_exists(p: impl AsRef<Path>) -> bool {
    p.as_ref().exists()
}

/// Free helper para la UI: seleccionar cuenta persistida.
pub fn set_selected_account(account_id: &str) -> Result<(), String> {
    let mut store = AccountStore::load();
    store.set_selected(account_id)
}

/// Free helper para la UI: eliminar una cuenta persistida.
pub fn remove_account(account_id: &str) -> Result<(), String> {
    let mut store = AccountStore::load();
    store.remove(account_id);
    store.save()
}