#!/bin/bash

#############
# ~/.bashrc #
#############

####################
# GENERAL SETTINGS #
####################

# Disable ctrl+s ctrl+q.
stty -ixon

# Enable vi mode.
set -o vi

# Allow to change directory without typing 'cd'.
shopt -s autocd

# Set bash command history to infinite.
HISTSIZE= HISTFILESIZE=

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

###################
# PROMPT SETTINGS #
###################

# If id command returns zero, you got root access.
if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt.
  PS1="\\[$(tput setaf 1)\\]\\u@\\h:\\w #\\[$(tput sgr0)\\]"
else # normal.
  PS1="[\\u@\\h:\\w] $"
fi

# Powerline.
export TERM="rxvt-unicode-256color"
if [ -f `which powerline-daemon` ]; then
   powerline-daemon -q
   POWERLINE_BASH_CONTINUATION=1
   POWERLINE_BASH_SELECT=1
   . /usr/lib/python3.10/site-packages/powerline/bindings/bash/powerline.sh
fi

#########
# PATHS #
#########

# Add custom scripts folder to PATH-variable.
PATH="$HOME/scripts:$PATH"

# Add i3ass to PATH-variable.
#PATH="$HOME/scripts/i3ass/src:$PATH"

# Add Haskell Stack to PATH-variable.
#PATH="$HOME/.local/bin${PATH:+:${PATH}}"; export PATH;

#JAVA_HOME="/usr/lib/jvm/java-16-adoptopenjdk"
#PATH="$JAVA_HOME/bin:$PATH"

#ANT_HOME="$HOME/UNI/MASTER/2-SoSe22/MVS/MVS2022/libs/ant"
#PATH="$ANT_HOME/bin:$PATH"

# Export the PATH-variable.
export PATH

#############
# AUTOSTART #
#############

# Start neofetch with terminal.
neofetch --ascii_colors 14 23

###########
# ALIASES #
###########

# Make managing dotfiles with git easier.
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Make 'ls' print directories first and ignore colorcode if output to file.
alias ls='ls -hN --color=auto --group-directories-first'

# Make pacman colorful.
alias pacman="sudo pacman --color=auto"

# Make trizen colorful.
alias trizen="trizen --color=auto"

# Make grep highlight matches.
alias grep="grep --color=auto"

# Remove orphan packages.
alias remorph="pacman -Qtdq | pacman -Rns -"

# Xrandr.
alias xr1920x1080='xrandr --output HDMI-0 --mode 1920x1080'

alias xr1280x960='xrandr --output HDMI-0 --mode 1280x960'

alias xr1024x768='xrandr --output HDMI-0 --mode 1024x768'

alias xr800x600='xrandr --output HDMI-0 --mode 800x600'

alias xr640x480='xrandr --output HDMI-0 --mode 640x480'

# Webcam software 1.
alias webcam1='qv4l2'

# Webcam software 2.
alias webcam2='guvcview'

# Uni vpn tunnel.
alias univpn='univpn.sh'

# Renew.
alias renew='cd $HOME/UNI/MASTER/2-SoSe22/MVS/MVS2022/workspace/Renew/; java -p dist:dist/libs -m de.renew.loader gui'

alias makestub='$HOME/UNI/MASTER/2-SoSe22/MVS/MVS2022/workspace/Renew/Core/bin/unix/makestub'

alias compilestub='$HOME/UNI/MASTER/2-SoSe22/MVS/MVS2022/workspace/Renew/Core/bin/unix/compilestub'

alias jcompile='$HOME/UNI/MASTER/2-SoSe22/MVS/MVS2022/workspace/Renew/Core/bin/unix/jcompile'

# Main wine prefix.
alias wine-64='WINEPREFIX=$HOME/.wine64'

# Path to wine games dir.
alias winegames='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)'

# Reason 4.
alias reason4='sudo mount $HOME/ISOS/Propellerheads.Reason.v4.0.HYBRID.DVDR-AiRISO/Reason4ISO/Reason\ 4.iso /mnt/disk -o loop; cd $HOME/.wine64/drive_c/Program\ Files\ \(x86\)/Propellerhead/Reason/; wine-64 WINEDEBUG=-all wine Reason.exe'

# Baldurs Gate 2.
alias baldur2='cd $HOME/.wine64/drive_c/Program\ Files\ \(x86\)/Baldur\ s\ Gate\ II\ Enhanced\ Edition\ v2\ 5; wine-64 WINEDEBUG=-all wine Baldur.exe'

# Fallout 2.
alias fallout2='cd $HOME/.wine64/drive_c/GOG\ Games/Fallout\ 2/; wine-64 WINEDEBUG=-all WINEDLLOVERRIDES="ddraw.dll=n,b ddraw.ini=n,b" wine fallout2.exe'

# Close Combat 3.
alias cc3='cd $HOME/.wine64/drive_c/GOG\ Games/Close\ Combat\ 3; wine-64 WINEDEBUG=-all wine CC3.exe'

# Warthunder.
alias warthunder='$HOME/Games/war-thunder/aces'

# PokeOne 1.Acc.
alias poke1='WINEPREFIX=$HOME/.wine $HOME/.wine/drive_c/Program\ Files\ \(x86\)/PokeOne32/PokeOne32.exe'

# PokeOne 2.Acc.
alias poke2='WINEPREFIX=$HOME/.wine2 $HOME/.wine/drive_c/Program\ Files\ \(x86\)/PokeOne32/PokeOne32.exe'

# Openxcom.
alias xcom='openxcom -data $HOME/.wine/drive_c/GOG\ Games/X-COM\ UFO\ Defense'

# Dwarf fortress.
alias dwarfnew='$HOME/Games/LinuxDwarfPack-0.47.05-r3/startlnp.sh'

# Sims2.
alias sims2='cd $HOME/wine-3.19/a; env WINEPREFIX=~/wine-3.19/a/ ./wine $HOME/wine-3.19/a/drive_c/Program\ Files/EA\ GAMES/Die\ Sims\ 2\ Villen-\ und\ Garten-Accessoires/TSBin/Sims2EP9.exe'

# HoI3.
alias hoi3='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/Paradox\ Interactive/Hearts\ of\ Iron\ III; wine BI\ Quick\ Launch.exe'

# HoI3 black ice 8.
alias hoi3bi8='cd $HOME/win32-HoI3/drive_c/Games/Hearts\ of\ Iron\ III/; WINEPREFIX=$HOME/win32-HoI3 WINEDEBUG=-all wine BlackICE\ by\ Panzeroo.exe'

# HoI3 black ice 10.41.
alias hoi3bi10='cd $HOME/.wine64/drive_c/Program\ Files\ \(x86\)/Paradox\ Interactive/Hearts\ of\ Iron\ III/; wine-64 WINEDEBUG=-all wine launcher.exe'

# Retro wow.
alias wow='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/RetroWoW\ 1.12.1/RetroWoW\ 1.12.1/; WINEPREFIX=$HOME/win32-HoI3 wine WoW.exe'

# Retro wow with 64bit prefix.
alias wow2='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/RetroWoW\ 1.12.1/RetroWoW\ 1.12.1/; WINEPREFIX=$HOME/.wine64 wine WoW.exe'

# Medieval total war.
alias metw='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/The\ Creative\ Assembly/Medieval\ -\ Total\ War\ -\ Gold\ Edition; WINEPREFIX=$HOME/.wine64 wine Medieval_TW.exe'

# Medieval dynasty.
alias medy='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/Medieval.Dynasty.v0.3.1.4/Medieval.Dynasty.v0.3.1.4/Medieval.Dynasty.v0.3.1.4; WINEPREFIX=$HOME/.wine64 wine Medieval_Dynasty.exe'

# Neverwinter.
alias nwo='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/Cryptic\ Studios; WINEDEBUG=-all wine Neverwinter.exe'

# Neverwinter with 64bit prefix.
alias nwo64='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/Cryptic\ Studios; wine-64 WINEDEBUG=-all wine Neverwinter.exe'

# Diablo 2.
alias diablo2='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/Diablo\ II/Mod\ PlugY; wine-64 WINEDEBUG=-all wine PlugY.exe'

# Ksp.
alias ksp='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/Kerbal\ Space\ Program\ Breaking\ Ground; wine-64 WINEDEBUG=-all wine Launcher.exe'

# Subsistence.
alias subsis='cd $HOME/.wine/drive_c/Program\ Files\ \(x86\)/Subsistence.v30.07.2021/Subsistence.v30.07.2021/Subsistence.v30.07.2021/Binaries/Win64; wine-64 WINEDEBUG=-all wine UDK.exe'

# Revolution under Siege.
alias revo='cd $HOME/.wine64/drive_c/Program\ Files\ \(x86\)/Revolution\ Under\ Siege\ Gold\ Edition; wine-64 WINEDEBUG=-all wine RUS.exe'

