# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import hook
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()

colors = {"black_0"   : "#000000",
          "black_1"   : "#666666",
          "red_0"     : "#cd3131",
          "red_1"     : "#f14c4c",
          "green_0"   : "#6a9955",
          "green_1"   : "#b5cea8",
          "yellow_0"  : "#ce9178",
          "yellow_1"  : "#dcdcaa",
          "blue_0"    : "#2472c8",
          "blue_1"    : "#569cd6",
          "magenta_0" : "#c586c0",
          "magenta_1" : "#daadd6",
          "cyan_0"    : "#11a8cd",
          "cyan_1"    : "#9cdcfe",
          "white_0"   : "#c0c0c0",
          "white_1"   : "#e5e5e5",
         }

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.call([home + '/.config/qtile/autostart.sh'])

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h",
        lazy.layout.left(),
        desc="Move focus to left"),
    Key([mod], "l",
        lazy.layout.right(),
        desc="Move focus to right"),
    Key([mod], "j",
        lazy.layout.down(),
        desc="Move focus down"),
    Key([mod], "k",
        lazy.layout.up(),
        desc="Move focus up"),

    Key([mod], "Left",
        lazy.layout.left(),
        desc="Move focus to left"),
    Key([mod], "Right",
        lazy.layout.right(),
        desc="Move focus to right"),
    Key([mod], "Down",
        lazy.layout.down(),
        desc="Move focus down"),
    Key([mod], "Up",
        lazy.layout.up(),
        desc="Move focus up"),

    Key([mod], "space",
        lazy.layout.next(),
        desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up(),
        desc="Move window up"),

    Key([mod, "shift"], "Left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "Down",
        lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "Up",
        lazy.layout.shuffle_up(),
        desc="Move window up"),

# Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        desc="Grow window up"),

    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        desc="Grow window up"),

    Key([mod], "n",
        lazy.layout.normalize(),
        desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return",
        lazy.spawn(terminal),
        desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "f", lazy.next_layout(),
        desc="Toggle between layouts"),
    Key([mod, "shift"], "q",
        lazy.window.kill(),
        desc="Kill focused window"),
    Key([mod, "shift"], "r",
        lazy.reload_config(),
        desc="Reload the config"),
    Key([mod, "shift"], "e",
        lazy.shutdown(),
        desc="Shutdown Qtile"),

    Key([mod, "shift"], "f",
        lazy.spawn("firefox"),
        desc="Launch Firefox"),
    Key([mod], "d",
        lazy.spawn("dmenu_run -nb "+ colors["white_0"]
                   + " -nf " + colors["black_1"]
                   + " -sb " + colors["red_1"]
                   + " -sf " + colors["white_1"]
                   + " -fn SourceCodePro-13"),
        desc="Launch dmenu"),
    Key([mod, "shift"], "Escape",
        lazy.spawn("scripts/prompt 'Rechner runterfahren?'"
                   + " 'sudo -A shutdown -h now' "
                   + colors["white_0"] + " "
                   + colors["black_1"] + " "
                   + colors["red_1"] + " "
                   + colors["white_1"] + " "
                   + " 'SourceCodePro-13'"),
        desc="Shutdown script"),
Key([mod, "shift"], "a",
        lazy.spawn("alacritty -e nvim .config/qtile/config.py"),
        desc="Open Qtile config"),
    Key([mod, "shift"], "s",
        lazy.spawn("alacritty -e nvim .zshrc"),
        desc="Open zsh config"),
    Key([mod, "shift"], "d",
        lazy.spawn("alacritty -e nvim .config/nvim/init.vim"),
        desc="Open neovim config"),
    Key([mod, "shift"], "y",
        lazy.spawn("alacritty -e nvim .config/polybar/config.ini"),
        desc="Open polybar config"),
    Key([mod, "shift"], "x",
        lazy.spawn("alacritty -e nvim .config/alacritty/alacritty.yml"),
        desc="Open alacritty config"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_options = {"border_width": 2,
                  "margin": 0,
                  "border_focus": colors["white_0"],
                  "border_normal": colors["black_1"],
                 }


layouts = [
    layout.Columns(**layout_options),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    # layout.Floating()
]

widget_defaults = dict(
    font="sourcecodepro",
    fontsize=18,
    padding=1,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.TextBox("|"),
                widget.GroupBox(),
                widget.Prompt(),
                widget.TextBox("|"),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("|"),
                widget.Clock(format="%a, %d.%m.%Y %k:%M"),
                widget.TextBox("|"),
                widget.Systray(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
