use std::path::PathBuf;

use serde::Deserialize;
use clap::{app_from_crate, crate_name, App, Arg};

/// Return config dir path.
pub fn dir() -> PathBuf {
    let mut path = dirs::home_dir().unwrap();
    path.push(".config");
    path.push(crate_name!());
    path
}

pub struct Config {}

/// Program configuration.
impl Config {
    pub fn load() -> Config {
        Config {}
    }
}
