# Launch a Windows game via Wine, changing to the correct directory first
launch_wine() {
	local game_dir="$1"
	local game_executable="$2"
	cd "$game_dir" || return
	wine "$game_executable"
}

# Launch Distant Worlds Universe with the correct Wine prefix and environment
dwu() {
	cd "$HOME/.winedwu/drive_c/GOG Games/Distant Worlds Universe" || return
	WINEARCH=win32 wine-dwu WINEDEBUG=-all wine DistantWorlds.exe
}

# Function to launch HoI3 Black Ice for a given version (call: hoi3bi 7)
hoi3bi() {
	local version="$1"
	wine-hoi launch_wine "$HOME/.winehoi/drive_c/GOG Games/hoi3bi${version}/" launcher.exe
}
