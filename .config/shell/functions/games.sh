# Configuration variables for default Wine prefixes
readonly WINE_PREFIX_DEFAULT_64="$HOME/.wine/64/default"
readonly WINE_PREFIX_DEFAULT_PROTON="$HOME/.wine/proton/default"
readonly WINE_PREFIX_DEFAULT_WINEGE="$HOME/.wine/ge/default"

# Wine launcher
# $1 - executable path (required)
# $2 - WINEPREFIX directory (optional)
launch_wine() {
  local exe="$1"
  local prefix="${2:-$WINE_PREFIX_DEFAULT_64}"
  local exe_dir exe_file

  exe_dir=$(dirname -- "$exe")
  exe_file=$(basename -- "$exe")

  builtin cd "$exe_dir" || return 1
  WINEPREFIX="$prefix" WINEDEBUG=-all wine "./$exe_file"
}

# Proton launcher
# $1 - executable path (required)
# $2 - prefix directory (optional)
launch_proton() {
  local exe="$1"
  local prefix="${2:-$WINE_PREFIX_DEFAULT_PROTON}"
  local exe_dir exe_file

  exe_dir=$(dirname -- "$exe")
  exe_file=$(basename -- "$exe")

  if [[ ! -d "$prefix" ]]; then
    mkdir -p "$prefix"
    STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam" \
      STEAM_COMPAT_DATA_PATH="$prefix" \
      WINEPREFIX="$prefix" \
      /usr/bin/proton run wineboot
  fi

  builtin cd "$exe_dir" || return 1
  STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam" \
    STEAM_COMPAT_DATA_PATH="$prefix" \
    WINEPREFIX="$prefix" \
    /usr/bin/proton run "./$exe_file"
}

# Wine-GE launcher
# $1 - executable path (required)
# $2 - WINEPREFIX directory (optional)
launch_winege() {
  local exe="$1"
  local prefix="${2:-$WINE_PREFIX_DEFAULT_WINEGE}"
  local exe_dir exe_file

  exe_dir=$(dirname -- "$exe")
  exe_file=$(basename -- "$exe")

  builtin cd "$exe_dir" || return 1
  WINEPREFIX="$prefix" /opt/wine-ge-custom-opt/bin/wine "./$exe_file"
}
