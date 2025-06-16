# Tauri template APP

App uses typescript with vanilla flavour for UI.

Directories:

- src: directory with UI,
- src-tauri: rust crate with main logic for your app.

## Notes

Build on Linux may [require](https://github.com/tauri-apps/tauri/issues/5175) additional dependency:

- openSUSE Tumbleweed: `libayatana-indicator3-devel`;
- Ubuntu: `libayatana-appindicator3-dev`;
- Fedora: `libappindicator-gtk3-devel`.


