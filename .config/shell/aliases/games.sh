# Prefix path variables
readonly WINE32_PREFIX="$HOME/.wine/32/default"
readonly WINE64_PREFIX="$HOME/.wine/64/default"
readonly WINEDWU_PREFIX="$HOME/.wine/32/dwu"
readonly WINEHOI_PREFIX="$HOME/.wine/32/hoi"
readonly REASON_PREFIX="$HOME/.wine/64/reason"

# Wine prefix runner functions with debug flags
wine_32() {
  WINEPREFIX="$WINE32_PREFIX" WINEDEBUG=-all wine "$@"
}
wine_64() {
  WINEPREFIX="$WINE64_PREFIX" WINEDEBUG=-all wine "$@"
}
wine_dwu() {
  WINEPREFIX="$WINEDWU_PREFIX" WINEDEBUG=-all wine "$@"
}
wine_hoi() {
  WINEPREFIX="$WINEHOI_PREFIX" WINEDEBUG=-all wine "$@"
}

# Games Launchers
arcadia() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Chronicles of Arcadia/Launcher.exe"
  launch_wine "$game_executable" "$prefix"
}
baldur2() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Baldur s Gate II Enhanced Edition v2 5/Baldur.exe"
  launch_wine "$game_executable" "$prefix"
}
coinpoker() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/CoinPoker/Lobby.exe"
  launch_wine "$game_executable" "$prefix"
}
diablo2() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Diablo II Complete Edition/Mod PlugY/PlugY.exe"
  launch_wine "$game_executable" "$prefix"
}
dwu() {
  local prefix="$WINEDWU_PREFIX"
  local game_executable="$HOME/Games/Distant Worlds Universe/DistantWorlds.exe"
  launch_wine "$game_executable" "$prefix"
}
eu3() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Europa Universalis III/Launch Europa Universalis III Complete.lnk"
  launch_wine "$game_executable" "$prefix"
}
fallout2() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Fallout 2/fallout2.exe"
  launch_wine "$game_executable" "$prefix"
}
forest() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/The Forest/TheForest.exe"
  launch_wine "$game_executable" "$prefix"
}
iwd1() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Icewind Dale Enhanced Edition/Launch Icewind Dale - Enhanced Edition.lnk"
  launch_wine "$game_executable" "$prefix"
}
iwd2() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Icewind Dale 2/Launch Icewind Dale 2.lnk"
  launch_wine "$game_executable" "$prefix"
}
ksp() {
  local prefix="$WINE32_PREFIX"
  local game_executable="$HOME/Games/wine/drive_c/Program Files (x86)/Kerbal Space Program Breaking Ground/Launcher.exe"
  launch_wine "$game_executable" "$prefix"
}
medy() {
  local prefix="$WINE32_PREFIX"
  local game_executable="$HOME/Games/wine/drive_c/Program Files (x86)/Medieval.Dynasty.v0.3.1.4/Medieval_Dynasty.exe"
  launch_wine "$game_executable" "$prefix"
}
metw() {
  local prefix="$WINE32_PREFIX"
  local game_executable="$HOME/Games/wine/drive_c/Program Files (x86)/The Creative Assembly/Medieval - Total War - Gold Edition/Medieval_TW.exe"
  launch_wine "$game_executable" "$prefix"
}
mw3() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/wine64/drive_c/Program Files (x86)/Call of Duty Modern Warfare 3/iw5sp.exe"
  launch_wine "$game_executable" "$prefix"
}
nwo() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/.local/share/Steam/steamapps/common/Cryptic Studios/Neverwinter.exe"
  launch_wine "$game_executable" "$prefix"
}
pjz() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Project Zomboid/ProjectZomboid64.exe"
  launch_wine "$game_executable" "$prefix"
}
pst() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Planescape Torment - Enhanced Edition/Launch Planescape - Torment Enhanced Edition.lnk"
  launch_wine "$game_executable" "$prefix"
}
ptcgl() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/PokemonTCG/Pokémon Trading Card Game Live/Pokemon TCG Live.exe"
  launch_wine "$game_executable" "$prefix"
}
revo() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Revolution Under Siege Gold Edition/RUS.exe"
  launch_wine "$game_executable" "$prefix"
}
rwo() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/RevoWinter/Run (English).exe"
  launch_wine "$game_executable" "$prefix"
}
shemp() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Shadow Empire/ShadowEmpire.exe"
  launch_wine "$game_executable" "$prefix"
}
sims2() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/The Sims 2 Ultimate Collection/The Sims 2 Mansion and Garden Stuff/TSBin/Sims2EP9.exe"
  launch_wine "$game_executable" "$prefix"
}
sos() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Songs of Syx/SongsofSyx.exe"
  launch_wine "$game_executable" "$prefix"
}
subsis() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Subsistence.v30.07.2021/Subsistence.v30.07.2021/Subsistence.v30.07.2021/Binaries/Win64/UDK.exe"
  launch_wine "$game_executable" "$prefix"
}
toee() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Temple of Elemental Evil/Launch Temple of Elemental Evil.lnk"
  launch_wine "$game_executable" "$prefix"
}
vic2() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Victoria II/Launch Victoria II - Civil War Edition.lnk"
  launch_wine "$game_executable" "$prefix"
}
wow() {
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/WoW/WoW.exe"
  launch_wine "$game_executable" "$prefix"
}

# Special treatment
cc3() {
  cd "$HOME/Games/Close Combat 3" || return
  WINEPREFIX="$WINE32_PREFIX" wine explorer /desktop=cc3,800x600 CC3.exe
}

cwg2() {
  sudo mount -o loop CivilWarGeneral2.ISO /mnt/disk
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/SIERRA/CWG2/Cwg2.exe"
  launch_wine "$game_executable" "$prefix"
}

hoi3bi() {
  local version="$1"
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/hoi3bi${version}/launcher.exe"
  launch_wine "$game_executable" "$prefix"
}

reason4() {
  sudo mount "$HOME"/ISOS/Propellerheads.Reason.v4.0.HYBRID.DVDR-AiRISO/Reason\ 4.iso /mnt/disk -o loop
  local version="$1"
  local prefix="$REASON_PREFIX"
  local game_executable="$HOME/Games/Propellerhead/Reason4/Reason.exe"
  launch_wine "$game_executable" "$prefix"
}

reason5() {
  local version="$1"
  local prefix="$REASON_PREFIX"
  local game_executable="$HOME/Games/Propellerhead/Reason5/Reason.exe"
  launch_wine "$game_executable" "$prefix"
}

gtasa() {
  local version="$1"
  local prefix="$WINE64_PREFIX"
  local game_executable="$HOME/Games/Grand Theft Auto San Andreas/gta_sa.exe"
  launch_wine "$game_executable" "$prefix"
}
