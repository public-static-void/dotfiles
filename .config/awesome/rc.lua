-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Wibar
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- This will shift the workarea on position and by pixels specified.
    local wibar = awful.wibar {
        position = "bottom",
        height   = 32,
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),



--    awful.key({ modkey, }, "k",
--        function ()
--            awful.client.focus.byidx( 1)
--        end,
--        {description = "focus next by index", group = "client"}
--    ),
--    awful.key({ modkey, }, "j",
--        function ()
--            awful.client.focus.byidx(-1)
--        end,
--        {description = "focus previous by index", group = "client"}
--    ),
--    awful.key({ modkey, }, "Right",
--        function ()
--            awful.client.focus.byidx( 1)
--        end,
--        {description = "focus next by index", group = "client"}
--    ),
--    awful.key({ modkey, }, "Left",
--        function ()
--            awful.client.focus.byidx(-1)
--        end,
--        {description = "focus previous by index", group = "client"}
--    ),






    awful.key({ modkey, }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program.
    awful.key({ modkey, }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Reshape workspace layout.
    -- Adjust rows.
    awful.key({ modkey, "Mod1" }, "h", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Mod1" }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Mod1" }, "Left", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Mod1" }, "Right", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    -- Adjust columns.
    awful.key({ modkey, "Mod1" }, "k", function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Mod1" }, "j", function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey, "Mod1" }, "Up", function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Mod1" }, "Down", function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    -- Start dmenu.
    awful.key({ modkey }, "d", function () awful.spawn("dmenu_run -fn SourceCodePro-13") end,
              {description = "launch dmenu", group = "launcher"}),

    -- Start firefox.
    awful.key({ modkey, "Shift" }, "f", function () awful.spawn("firefox") end,
              {description = "launch firefox", group = "applications"}),

    -- Start spacefm.
    awful.key({ modkey, "Shift" }, "w", function () awful.spawn("spacefm") end,
              {description = "launch spacefm", group = "applications"}),

    -- Open awesome wm config.
    awful.key({ modkey, "Shift" }, "a", function () awful.spawn.with_shell(terminal.. " -e " ..editor.. " ~/.config/awesome/rc.lua") end,
              {description = "Open awesome wm config", group = "configs"}),

    -- Open polybar config.
    awful.key({ modkey, "Shift" }, "y", function () awful.spawn.with_shell(terminal.. " -e " ..editor.. " ~/.config/polybar/config.ini") end,
              {description = "Open polybar config", group = "configs"}),

    -- Open alacritty config.
    awful.key({ modkey, "Shift" }, "x", function () awful.spawn.with_shell(terminal.. " -e " ..editor.. " ~/.config/alacritty/alacritty.yml") end,
              {description = "Open alacritty config", group = "configs"}),

    -- Open zsh config.
    awful.key({ modkey, "Shift" }, "s", function () awful.spawn.with_shell(terminal.. " -e " ..editor.. " ~/.zshrc") end,
              {description = "Open zsh config", group = "configs"}),

    -- Open neovim config.
    awful.key({ modkey, "Shift" }, "d", function () awful.spawn.with_shell(terminal.. " -e " ..editor.. " ~/.config/nvim/init.vim") end,
              {description = "Open neovim config", group = "configs"}),

    -- Adjust screen brightness.
    awful.key({ modkey, }, "F5", function () awful.spawn.with_shell("brightnessctl set 10%-") end,
              {description = "Decrease screen brightness", group = "configs"}),
    awful.key({ modkey, }, "F6", function () awful.spawn.with_shell("brightnessctl set 10%+") end,
              {description = "Increase screen brightness", group = "configs"}),

    -- Adjust volume.
    awful.key({ modkey, }, "F2", function () awful.spawn.with_shell("pactl set-sink-volume 0 -5%") end,
              {description = "Decrease volume", group = "configs"}),
    awful.key({ modkey, }, "F3", function () awful.spawn.with_shell("pactl set-sink-volume 0 +5%") end,
              {description = "Increase volume", group = "configs"}),
    awful.key({ modkey, }, "F1", function () awful.spawn.with_shell("pactl set-sink-mute 0 toggle") end,
              {description = "Mute volume", group = "configs"}),

    -- Start shutdown script.
    awful.key({ modkey, "Shift" }, "Escape", function () awful.spawn.with_shell("~/scripts/prompt 'Rechner runterfahren?' 'sudo -A shutdown -h now' '#c0c0c0' '#666666' '#f14c4c' '#e5e5e5' 'SourceCodePro-13'") end,
              {description = "Launch shutdown script", group = "launcher"})

)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift" }, "q",      function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Shift" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    -- Focus windows by direction.
    awful.key({ modkey, }, "j",
        function (c)
            awful.client.focus.global_bydirection("down")
            c:lower()
        end,
        {description = "focus next window to the bottom", group = "client"}
    ),
    awful.key({ modkey, }, "k",
        function (c)
            awful.client.focus.global_bydirection("up")
            c:lower()
        end,
        {description = "focus next window to the top", group = "client"}
    ),
    awful.key({ modkey, }, "h",
        function (c)
            awful.client.focus.global_bydirection("left")
            c:lower()
        end,
        {description = "focus next window to the left", group = "client"}
    ),
    awful.key({ modkey, }, "l",
        function (c)
            awful.client.focus.global_bydirection("right")
            c:lower()
        end,
        {description = "focus next window to the right", group = "client"}
    ),
    -- Same for arrow keys.
    awful.key({ modkey, }, "Down",
        function (c)
            awful.client.focus.global_bydirection("down")
            c:lower()
        end,
        {description = "focus next window to the bottom", group = "client"}
    ),
    awful.key({ modkey, }, "Up",
        function (c)
            awful.client.focus.global_bydirection("up")
            c:lower()
        end,
        {description = "focus next window to the top", group = "client"}
    ),
    awful.key({ modkey, }, "Left",
        function (c)
            awful.client.focus.global_bydirection("left")
            c:lower()
        end,
        {description = "focus next window to the left", group = "client"}
    ),
    awful.key({ modkey, }, "Right",
        function (c)
            awful.client.focus.global_bydirection("right")
            c:lower()
        end,
        {description = "focus next window to the right", group = "client"}
    ),

    -- Swap clients by direction.
    awful.key({ modkey, "Shift" }, "k", function (c) awful.client.swap.global_bydirection("up") c:raise() end,
              {description = "swap with above", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function (c) awful.client.swap.global_bydirection("down") c:raise() end,
              {description = "swap with below", group = "client"}),
    awful.key({ modkey, "Shift" }, "h", function (c) awful.client.swap.global_bydirection("left") c:raise() end,
              {description = "swap with client at the left", group = "client"}),
    awful.key({ modkey, "Shift" }, "l", function (c) awful.client.swap.global_bydirection("right") c:raise() end,
              {description = "swap with client at the right", group = "client"}),
    -- Same with arrow keys.
    awful.key({ modkey, "Shift" }, "Up", function (c) awful.client.swap.global_bydirection("up") c:raise() end,
              {description = "swap with above", group = "client"}),
    awful.key({ modkey, "Shift" }, "Down", function (c) awful.client.swap.global_bydirection("down") c:raise() end,
              {description = "swap with below", group = "client"}),
    awful.key({ modkey, "Shift" }, "Left", function (c) awful.client.swap.global_bydirection("left") c:raise() end,
              {description = "swap with client at the left", group = "client"}),
    awful.key({ modkey, "Shift" }, "Right", function (c) awful.client.swap.global_bydirection("right") c:raise() end,
              {description = "swap with client at the right", group = "client"}),

  -- Resize vertically.
    awful.key({ modkey, "Control" }, "k", function (c)
        if c.floating then
            c:relative_move(0,0,0,10)
        else
            awful.client.incwfact(-0.05) end
        end,
              {description = "increase client height factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "j", function (c)
        if c.floating then
            c:relative_move(0,0,0,-10)
        else
            awful.client.incwfact( 0.05) end
        end,
              {description = "decrease client height factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Up", function (c)
        if c.floating then
            c:relative_move(0,0,0,10)
        else
            awful.client.incwfact(-0.05) end
        end,
              {description = "increase client height factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Down", function (c)
        if c.floating then
            c:relative_move(0,0,0,-10)
        else
            awful.client.incwfact( 0.05) end
        end,
              {description = "decrease client height factor", group = "layout"}),

    -- Resize horizontally.
    awful.key({ modkey, "Control" }, "l", function (c)
        if c.floating then
            c:relative_move(0,0,10,0)
        else
            awful.tag.incmwfact( 0.05) end
        end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "h", function (c)
        if c.floating then
            c:relative_move(0,0,-10,0)
        else
            awful.tag.incmwfact(-0.05) end
        end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Right", function (c)
        if c.floating then
            c:relative_move(0,0,10,0)
        else
            awful.tag.incmwfact( 0.05) end
        end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Left", function (c)
        if c.floating then
            c:relative_move(0,0,-10,0)
        else
            awful.tag.incmwfact(-0.05) end
        end,
              {description = "decrease master width factor", group = "layout"})

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- Borders.
beautiful.border_width = 3

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- Autostart applications.
awful.spawn.with_shell("picom -b -f")
awful.spawn.with_shell("dunst")
awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("~/.config/polybar/launch.sh")

-- Gaps.
beautiful.useless_gap = 3

