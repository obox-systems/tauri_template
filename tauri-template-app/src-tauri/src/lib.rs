#[cfg(desktop)]
mod desktop;

/// Example of basic command from Tauri
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

/// Example of command which accepts handler to app
#[tauri::command]
async fn exit_app_ok<R: tauri::Runtime>(
    app: tauri::AppHandle<R>,
    _window: tauri::Window<R>, // you may also require handler to window which calls this command
) -> Result<(), String> {
    app.exit(0);

    Ok(())
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .setup(|_app| {
            #[cfg(desktop)]
            {
                // add desktop specific logic to this section
                desktop::setup_desktop_plugins(_app)?;
            }
            #[cfg(mobile)]
            {
                // add mobile specific logic to this section
            }

            Ok(())
        })
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet, exit_app_ok]) // You need to add new commands here to make them available in JS
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
