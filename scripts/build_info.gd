# build_info.gd -- which content version this is. tools/publish_update.ps1 bumps BUILD each time it
# publishes an update; Boot.gd compares it with the version online and any update already downloaded.

extends RefCounted

const BUILD := 4
# Updates live on the rolling "live" release: version.txt + content.pck (content updates, no reinstall),
# apk.txt + ACCA_Study_Buddy.apk (only when the app itself must change: icon, name, permissions, engine).
const UPDATE_URL := "https://github.com/Zahra3789/ACCA-Study-Buddy/releases/download/live"
