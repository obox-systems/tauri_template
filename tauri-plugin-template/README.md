# Tauri Plugin template

This crate demonstrates example of plugin creation for tauri.

## Guides

Read more about how to create plugins in [this](https://tauri.app/develop/plugins) guide.

For quickstart in mobile plugin development for android you may read [this](https://tauritutorials.com/blog/develop-a-tauri-plugin-for-android) guide.

## Support for new platforms

Makes sure that you have `tauri-build` in deps or `tauri-plugin` has `build` feature enabled.

### Init android support

Execute following in plugin root directory.

```bash
cargo tauri plugin android init
```

It should print:

```rust
// You must add the following to the Cargo.toml file:

[build-dependencies]
tauri-build = "2.0.2"

// You must add the following code to the build.rs file:

const COMMANDS: &[&str] = &["ping"];

fn main() {
  tauri_plugin::Builder::new(COMMANDS)
    .android_path("android")
    .ios_path("ios")
    .build();
}

// Your plugin's init function under src/lib.rs must initialize the Android plugin:

pub fn init<R: Runtime>() -> TauriPlugin<R> {
  Builder::new("template")
    .setup(|app, api| {
      #[cfg(target_os = "android")]
      let handle = api.register_android_plugin("com.plugin.template", "ExamplePlugin")?;
      Ok(())
    })
    .build()
}
```

Also add identifier of your android project to `init` fn in `mobile` module.

### Init ios support

Execute following in plugin root directory.

```bash
cargo tauri plugin ios init
```

It should print:

```rust
// You must add the following to the Cargo.toml file:

[build-dependencies]
tauri-build = "2.0.2"

// You must add the following code to the build.rs file:

const COMMANDS: &[&str] = &["ping"];

fn main() {
  tauri_plugin::Builder::new(COMMANDS)
    .android_path("android")
    .ios_path("ios")
    .build();
}

// Your plugin's init function under src/lib.rs must initialize the iOS plugin:

#[cfg(target_os = "ios")]
tauri::ios_plugin_binding!(init_plugin_template);

pub fn init<R: Runtime>() -> TauriPlugin<R> {
  Builder::new("template")
    .setup(|app| {
      #[cfg(target_os = "ios")]
      app.register_ios_plugin(init_plugin_template)?;
      Ok(())
    })
    .build()
}
```

### Remove android support

Remove [`android`](./android/) directory and remove plugin identifier from `init` fn in `mobile` module.

### Remove ios support

Remove [`ios`](./ios/) directory and remove plugin identifier from `init` fn in `mobile` module.
