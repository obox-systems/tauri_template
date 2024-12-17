.DEFAULT_GOAL := run-desktop

run-desktop:
	cargo tauri dev 

run-android:
	cargo tauri android dev 

build:
	cargo tauri build $(filter-out $@,$(MAKECMDGOALS))

build-apk:
	cargo tauri android build --apk $(filter-out $@,$(MAKECMDGOALS))

install-apk:
	adb install tauri-template-app/src-tauri/gen/android/app/build/outputs/apk/universal/release/app-universal-release-unsigned.apk

.PHONY: run-desktop run-android build build-apk install-apk