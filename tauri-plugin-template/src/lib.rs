use tauri::{
  plugin::{Builder, TauriPlugin},
  Manager, Runtime,
};

pub use models::*;

#[cfg(desktop)]
mod desktop;
#[cfg(mobile)]
mod mobile;

mod commands;
mod error;
mod models;

pub use error::{Error, Result};

#[cfg(desktop)]
use desktop::Template;
#[cfg(mobile)]
use mobile::Template;

/// Extensions to [`tauri::App`], [`tauri::AppHandle`] and [`tauri::Window`] to access the template APIs.
pub trait TemplateExt<R: Runtime> {
  fn template(&self) -> &Template<R>;
}

impl<R: Runtime, T: Manager<R>> crate::TemplateExt<R> for T {
  fn template(&self) -> &Template<R> {
    self.state::<Template<R>>().inner()
  }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
  Builder::new("template")
    .invoke_handler(tauri::generate_handler![commands::ping])
    .setup(|app, api| {
      #[cfg(mobile)]
      let template = mobile::init(app, api)?;
      #[cfg(desktop)]
      let template = desktop::init(app, api)?;
      app.manage(template);
      Ok(())
    })
    .build()
}
