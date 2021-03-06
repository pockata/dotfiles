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

-- -- Enable hotkeys help widget for VIM and other apps
-- -- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- TODO: Download these on first run if not present

-- https://github.com/streetturtle/awesome-wm-widgets/
local volumearc_widget = require("awesome-wm-widgets.volumearc-widget.volumearc")

-- https://github.com/lcpz/lain
local lain = require("lain")

-- screen_width = awful.screen.focused().geometry.width
-- screen_height = awful.screen.focused().geometry.height

local navigation_keys = {
    { "j", "left" },
    { "k", "down" },
    { "l", "up" },
    { ";", "right" },
}

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
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    lain.layout.centerwork,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
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

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- overload keyboardlayout func to stop showing keyboard section "(phonetic)"
mykeyboardlayout.layout_name = function(v)
    return v.file;
end
awesome.emit_signal("xkb::map_changed")

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach( mytextclock, "tr", {on_hover = false})

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local function set_wallpaper()
    awful.spawn("nitrogen --restore", false);
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local function rounded_bar(color)
    return wibox.widget {
        max_value     = 100,
        value         = 0,
        forced_width  = 20,
        -- forced_width  = beautiful.bar_width,
        margins       = {
            top = 5,
            bottom = 5,
            -- top = beautiful.bar_margin,
            -- bottom = beautiful.bar_margin,
        },
        shape         = gears.shape.rounded_bar,
        border_width  = 1,
        -- border_width  = beautiful.bar_border,
        color         = color,
        -- background_color = beautiful.bar_bg,
        background_color = "#fafafa",
        border_color  = "#fafafa",
        -- border_color  = beautiful.bar_bordercolor,
        widget        = wibox.widget.progressbar,
    }
end

-- Wallpaper
set_wallpaper(s)

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- -- Create a tasklist widget
    -- s.mytasklist = awful.widget.tasklist {
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons
    -- }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal
    })

    -- local volume_bar = rounded_bar("#4c9882")

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        -- s.mytasklist, -- Middle widget
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            -- lain.widget.bat({
            --     -- battery = "/sys/class/power_supply/BAT0",
            --     ac = "AC",
            --     settings = function ()
            --         local bat_header = "⚡"
            --         local bat_p = bat_now.perc
            --
            --         if bat_now.status == "Not present" then
            --             bat_header = ""
            --             bat_p = ""
            --         elseif bat_now.status == "Discharging" then
            --             bat_p = lain.util.markup("#ff0000", bat_p)
            --         else
            --             bat_p = lain.util.markup("#aa00aa", bat_p)
            --         end
            --
            --         widget:set_markup(lain.util.markup("#ff0000", bat_header) .. bat_p)
            --     end
            -- }),
            volumearc_widget({
                timeout = 10,
                button_press = function(widget, lx, ly, button)
                    if (button == 1) then
                        awful.spawn.easy_async_with_shell('pacmd list-cards | grep -i "active profile" | cut -d " " -f 3 | tr -d "<>"', function(current_profile)
                            local audio_profiles = {
                                "output:hdmi-stereo-extra1+input:analog-stereo",
                                "output:analog-stereo+input:analog-stereo"
                            };

                            current_profile = current_profile:gsub("%s+", "");

                            local new_profile = audio_profiles[1];
                            for k,v in ipairs(audio_profiles) do
                                if v == current_profile then
                                    local next_key = k+1
                                    if audio_profiles[next_key] then
                                        new_profile = audio_profiles[next_key]
                                    -- else
                                    --     new_profile = audio_profiles[0]
                                    end
                                end
                            end

                            awful.spawn('pactl set-card-profile 0 ' .. new_profile, false);
                        end)
                    end

                    if (button == 3) then
                        awful.spawn('pavucontrol --tab=3', false)
                    end
                end
            }),
            -- volume_bar,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key(
        { modkey, "Shift" }, "/", hotkeys_popup.show_help,
        { description="show help", group="awesome" }
    ),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp",
        function()
            awful.spawn("xbacklight -inc 10", false)
        end,
        {description = "+10%", group = "hotkeys"}
    ),
    awful.key({}, "XF86MonBrightnessDown",
        function()
            awful.spawn("xbacklight -dec 10", false)
        end,
        {description = "-10%", group = "hotkeys"}
    ),

    -- Screenshot on prtscn using scrot
    awful.key({}, "Print",
        function()
            awful.util.spawn("asd", false)
        end
    ),

    -- awful.key({}, "XF86PowerOff",
    --     function()
    --         -- emit signal to show the exit screen
    --         awesome.emit_signal("show_exit_screen")
    --     end,
    --     {description = "toggle exit screen", group = "hotkeys"}
    -- ),

    -- -- restore minimized client
    -- awful.key({modkey, "Shift"}, "n",
    --     function()
    --         local c = awful.client.restore()
    --         -- Focus restored client
    --         if c then
    --         client.focus = c
    --         c:raise()
    --         end
    --     end,
    --     {description = "restore minimized", group = "client"}
    -- )

    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    --           {description = "focus the next screen", group = "screen"}),
    -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    --           {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "Escape", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key(
        { modkey, "Shift" }, ".",
        function () awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key(
        { modkey, "Shift" }, ",",
        function () awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}
    ),

    -- TODO: These are useful, but will not be that commonly used so add a
    -- right-click menu for these
    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --           {description = "increase the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --           {description = "decrease the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    --           {description = "increase the number of columns", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    --           {description = "decrease the number of columns", group = "layout"}),
    awful.key(
        { modkey, "Control" }, ".",
        function () awful.layout.inc(1) end,
        { description = "select next", group = "layout" }
    ),
    awful.key(
        { modkey, "Control" }, ",",
        function () awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }
    ),

    -- awful.key({ modkey, "Control" }, "n",
    --           function ()
    --               local c = awful.client.restore()
    --               -- Focus restored client
    --               if c then
    --                 c:emit_signal(
    --                     "request::activate", "key.unminimize", {raise = true}
    --                 )
    --               end
    --           end,
    --           {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key(
        { modkey }, "d",
        function () awful.spawn("rofi -show drun") end,
        { description = "run prompt", group = "launcher" }
    ),

    awful.key(
        { modkey }, "w",
        function () awful.spawn("rofi -show window") end,
        { description = "window switch prompt", group = "launcher" }
    ),

    awful.key(
        { modkey, "Shift"}, "e",
        function () awful.spawn(os.getenv("HOME") .. "/bin/logout.sh") end,
        { description = "run prompt", group = "launcher" }
    ),

    -- Clipboard manager
    awful.key(
        { modkey }, "c",
        function ()
            awful.spawn("rofi -modi \"clipboard:greenclip print\" -show clipboard")
        end,
        { description = "show clipboard manager", group = "launcher" }
    ),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    -- Volume controls
    awful.key(
        {}, "XF86AudioRaiseVolume",
        function ()
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
        end
    ),

    awful.key(
        {}, "XF86AudioLowerVolume",
        function ()
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
        end
    ),


    awful.key(
        {}, "XF86AudioMute",
        function ()
            awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
        end
    )
)

for i, v in ipairs(navigation_keys) do
    local key = navigation_keys[i][1]
    local dir = navigation_keys[i][2]

    globalkeys = gears.table.join(globalkeys,
        awful.key(
            { modkey }, key,
            function ()
                awful.client.focus.global_bydirection(dir)
                if client.focus then client.focus:raise() end
            end,
            { description = "focus client " .. dir, group = "client" }
        ),

        awful.key(
            { modkey, "Shift" }, key,
            function ()
                awful.client.swap.global_bydirection(dir)
            end,
            { description = "swap client " .. dir, group = "client" }
        )
    )
end

clientkeys = gears.table.join(
    awful.key(
        { modkey, "Shift" }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key(
        { modkey }, "space",
        function (c)
            -- awful.client.floating.toggle(c)
            c.floating = not c.floating
            awful.placement.no_offscreen(c)
        end,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    -- awful.key({ modkey,           }, "n",
    --     function (c)
    --         -- The client currently has the input focus, so it cannot be
    --         -- minimized, since minimized clients can't have the focus.
    --         c.minimized = true
    --     end ,
    --     {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),

    awful.key({ modkey, "Shift" }, "h",
        function (c)
            awful.placement.centered(c.focus)
        end,
        {description = "move to the center of the screen", group = "corner movements"}),

    awful.key({ modkey, "Shift" }, "u",
        function (c)
            awful.placement.top_left(c.focus, {
                honor_workarea = true,
                margins = beautiful.useless_gap * 2
            })
        end,
        {description = "move to the top left corner of the screen", group = "corner movements"}),

    awful.key({ modkey, "Shift" }, "p",
        function (c)
            awful.placement.top_right(c.focus, {
                honor_workarea = true,
                margins = beautiful.useless_gap * 2
            })
        end,
        {description = "move to the top right corner of the screen", group = "corner movements"}),

    awful.key({ modkey, "Shift" }, "i",
        function (c)
            awful.placement.bottom_left(c.focus, {
                honor_workarea = true,
                margins = beautiful.useless_gap * 2
            })
        end,
        {description = "move to the bottom left corner of the screen", group = "corner movements"}),

    awful.key({ modkey, "Shift" }, "o",
        function (c)
            awful.placement.bottom_right(c.focus, {
                honor_workarea = true,
                margins = beautiful.useless_gap * 2
            })
        end,
        {description = "move to the bottom right corner of the screen", group = "corner movements"})
)

for i, v in ipairs(navigation_keys) do
    local key = navigation_keys[i][1]
    local dir = navigation_keys[i][2]

    clientkeys = gears.table.join(clientkeys,
        awful.key(
            { modkey, "Control" }, key,
            function (c)
                local screen = awful.screen.focused():get_next_in_direction(dir)

                if screen then
                    c:move_to_screen(screen.index)
                    c:raise()
                end
            end,
            { description = "move to " .. dir .. " screen", group = "client" }
        )
    )
end

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
        local corner = awful.mouse.client.resize(c, "bottom_right")
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
                     border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.centered+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
          "Devtools", -- Firefox devtools
        },
        class = {
          "Arandr",
          "Alacritty",
          "Blueman-manager",
          "Gpick",
          "Galculator",
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
          "Bluetooth",
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- TODO why does Chromium always start up floating in AwesomeWM?
    -- Temporary fix until I figure it out
    {
        rule_any = {
            class = {
                "Chromium-browser",
                "Chromium",
            }
        },
        properties = { floating = false }
    },

    -- -- "Needy": Clients that steal focus when they are urgent
    -- {
    --     rule_any = {
    --         class = {
    --             "TelegramDesktop",
    --             "firefox",
    --             "Nightly",
    --         },
    --         type = {
    --             "dialog",
    --         },
    --     },
    --     callback = function (c)
    --         c:connect_signal("property::urgent", function ()
    --             if c.urgent then
    --                 c:jump_to()
    --             end
    --         end)
    --     end
    -- },
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    -- "Switch to tag"
    -- These clients make you switch to their tag when they appear
    {
        rule_any = {
            class = {
                "Firefox"
            },
        },
        properties = {
            switchtotag = true
        }
    },

    -- Pavucontrol & Bluetooth Devices
    {
        rule_any = {
            class = {
                "Pavucontrol",
            },
        },
        properties = {
            floating = true,
            width = 756,
            height = 486
        }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.

    -- Set the new window as a slave
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- -- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = gears.table.join(
--         awful.button({ }, 1, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.resize(c)
--         end)
--     )
--
--     awful.titlebar(c) : setup {
--         { -- Left
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         { -- Middle
--             { -- Title
--                 align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

local function customBorder(c)
    -- Sometimes windows do strange things and borders disappear
    if (not c.fullscreen and c.border_width ~= beautiful.border_width) then
        c.border_width = beautiful.border_width
    end

    if c == client.focus then
        if c.maximized then
            c.border_color = beautiful.border_fullscreen
        elseif c.floating then
            c.border_color = beautiful.border_floating
        else
            c.border_color = beautiful.border_focus
        end
    else
        c.border_color = beautiful.border_normal
    end
end

client.connect_signal("focus", customBorder)
client.connect_signal("unfocus", customBorder)
-- (un)maximizing the window doesn't trigger `arrange` so we have to target it
-- separately
client.connect_signal("property::maximized", customBorder)

-- Change border color for fullscreen windows
screen.connect_signal("arrange", function (s)
    for _, c in pairs(s.clients) do
        customBorder(c)
    end
end)

-- Attempt to prevent memory leak
-- https://www.reddit.com/r/awesomewm/comments/cex6j6/memory_leak_when_setting_shapes_for_clients/
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

-- }}}
