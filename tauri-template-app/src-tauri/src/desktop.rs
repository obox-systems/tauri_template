//! Module with PC specific code

use tauri::{
    image::Image,
    menu::{Menu, MenuItem, Submenu},
    path::BaseDirectory,
    tray::TrayIconBuilder,
    App, Manager,
};

use tauri_plugin_autostart::{MacosLauncher, ManagerExt};
use tauri_plugin_notification::NotificationExt;

const QUIT_TRAY_MENU_ID: &str = "quit_btn";
const ENABLE_AUTOSTART_MENU_ID: &str = "autostart_enable_btn";
const DISABLE_AUTOSTART_MENU_ID: &str = "autostart_disable_btn";

const ICON_PATH: &str = "icons/32x32.png";

/// Example function with creates builder for tray with:
/// - quit button;
/// - autostart submenu for enable or disable autostart for this app.
fn tray_icon_builder<R: tauri::Runtime>(app: &App<R>) -> tauri::Result<TrayIconBuilder<R>> {
    // Set tray menu
    let quit_i = MenuItem::with_id(app, QUIT_TRAY_MENU_ID, "Quit", true, None::<&str>)?;

    let is_autostart_enabled = app.autolaunch().is_enabled().unwrap_or(false);

    let enable_i = MenuItem::with_id(
        app,
        ENABLE_AUTOSTART_MENU_ID,
        "Enable",
        !is_autostart_enabled,
        None::<&str>,
    )?;
    let disable_i = MenuItem::with_id(
        app,
        DISABLE_AUTOSTART_MENU_ID,
        "Disable",
        is_autostart_enabled,
        None::<&str>,
    )?;

    let autostart_submenu = Submenu::with_items(app, "Autostart", true, &[&enable_i, &disable_i])?;

    let menu = Menu::with_items(app, &[&autostart_submenu, &quit_i])?;

    let builder = TrayIconBuilder::new()
        .icon(Image::from_path(
            app.path().resolve(ICON_PATH, BaseDirectory::Resource)?,
        )?)
        .on_menu_event(move |app, event| match event.id.as_ref() {
            QUIT_TRAY_MENU_ID => {
                app.exit(0);
            }
            ENABLE_AUTOSTART_MENU_ID => match app.autolaunch().enable() {
                Ok(_) => {
                    let _ = enable_i.set_enabled(false);
                    let _ = disable_i.set_enabled(true);
                }
                Err(err) => {
                    let _ = app
                        .notification()
                        .builder()
                        .title("Failed to enable autostart")
                        .body(format!("Error: {err}"))
                        .show();
                }
            },
            DISABLE_AUTOSTART_MENU_ID => match app.autolaunch().disable() {
                Ok(_) => {
                    let _ = enable_i.set_enabled(true);
                    let _ = disable_i.set_enabled(false);
                }
                Err(err) => {
                    let _ = app
                        .notification()
                        .builder()
                        .title("Failed to disable autostart")
                        .body(format!("Error: {err}"))
                        .show();
                }
            },
            _ => (),
        })
        .menu(&menu)
        .menu_on_left_click(true);

    Ok(builder)
}

pub fn setup_desktop_plugins(app: &mut App) -> tauri::Result<()> {
    // Single instance of app
    app.handle()
        .plugin(tauri_plugin_single_instance::init(|app, _args, _cwd| {
            // this code prevents spawn of new windows for app. Instead it will focus on `main` window
            if let Some(app) = app.get_webview_window("main") {
                let _ = app.set_focus();
            }
        }))?;

    // Add autostart plugin, but no actual autostart
    app.handle().plugin(tauri_plugin_autostart::init(
        MacosLauncher::LaunchAgent,
        None,
    ))?;

    tray_icon_builder(&app)?.build(app)?;

    Ok(())
}
