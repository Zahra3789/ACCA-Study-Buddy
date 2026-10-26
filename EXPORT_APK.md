# Exporting Samurai Ledger to an Android APK 📱

The app name ("Samurai Ledger") comes from `project.godot` → `config/name`, so that's what shows under the icon on your phone. Name the exported file to match, e.g. `ACCA_Study_Buddy.apk`.


You already did this for DojoChef, so this is the same path. High-level, with the bits people usually trip on.

## One-time setup (if not already done for DojoChef)
1. **Install the Android build template** in Godot: `Project ▸ Install Android Build Template…` (creates an `android/` folder in the project).
2. **Install a JDK (Java 17)** and the **Android SDK** (easiest via Android Studio, or the command-line tools).
3. In Godot: `Editor ▸ Editor Settings ▸ Export ▸ Android`, set:
   - **Android SDK Path** (the folder containing `platform-tools`, `cmdline-tools`, etc.).
   - **Debug Keystore** — Godot can generate one, or use the default debug keystore. For a quick test build the debug keystore is fine.
   - If `adb` / `apksigner` / `keytool` paths are requested, point them at your SDK / JDK.

## Each build
1. `Project ▸ Export…`
2. Add an **Android** preset (the **Runnable** box should be ticked once the setup above is valid — if it shows errors in red, fix those first; they're almost always SDK/JDK/keystore paths).
3. Pick **Export Project** (for an `.apk` to copy to your phone) — choose a location and filename like `FFA_Dojo.apk`.
   - For a quick test you can instead use **"Export as APK"** in debug mode; for installing on your own phone that's enough.
4. Copy the `.apk` to your phone and install it (you'll need to allow "install from unknown sources" for your file manager the first time).

## Tips for this game specifically
- It's set to **portrait** and the **Compatibility (GL) renderer**, which is the friendliest for a wide range of phones — no change needed.
- It saves your progress to the device automatically (`user://`), so your best scores survive reinstalls of data only if Android keeps app data; a fresh install may reset it — that's fine for studying.
- If text looks tiny or huge on your phone, tell me and I'll adjust the font sizes / stretch settings.
- If the build fails, copy me the **red error text** from Godot's export window — it's nearly always a missing SDK/JDK path, and it names which one.

Once this slice runs on your phone, say the word and I'll build the other 15 monster rooms the same way.
