use std::path::PathBuf;

pub struct Config {}

/// Return config dir string.
pub fn dir() -> PathBuf {
    let mut path = dirs::home_dir().unwrap();
    path.push(".config/ap");
    path
}

/// Program configuration.
impl Config {
    pub fn load() -> Config {
        Config {}
    }
}
