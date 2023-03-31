-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

function VLOG(text)
	naughty.notify({ title = "lek", text = text })
end

function serializeTable(val, name, skipnewlines, depth)
	skipnewlines = skipnewlines or false
	depth = depth or 0

	local tmp = string.rep(" ", depth)

	if name then tmp = tmp .. name .. " = " end

	if type(val) == "table" then
		tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
			tmp = tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
		end

		tmp = tmp .. string.rep(" ", depth) .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
	end

	return tmp
end

function LOG(text)
	local file = io.open("/tmp/awesome-log", "a")

	if type(text) == "table" then
		text = serializeTable(text)
	end

	file:write(text .. "\n")
	file:close()
end

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
-- local volumearc_widget = require("awesome-wm-widgets.volumearc-widget.volumearc")

-- https://github.com/lcpz/lain
local lain = require("lain")
-- local quake = lain.util.quake({
-- 	app = "spotify"
-- })

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
	awesome.connect_signal("debug::error", function(err)
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
local terminal = "alacritty -e 'zsh' -c 'tmux new-session'"
-- local editor = os.getenv("EDITOR") or "nano"
-- local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.left,
	lain.layout.centerwork,
	-- lain.layout.centerwork.horizontal,
	-- awful.layout.suit.tile.top,
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
local mykeyboardlayout = awful.widget.keyboardlayout()

-- overload keyboardlayout func to stop showing keyboard section "(phonetic)"
mykeyboardlayout.layout_name = function(v)
	return v.file;
end
awesome.emit_signal("xkb::map_changed")

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()
local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach(mytextclock, "tr", { on_hover = false })

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local function set_wallpaper()
	-- https://github.com/tpruzina/awesomerc/blob/master/settings/wallpaper.lua
	awful.spawn("nitrogen --restore --force-setter=xwindows", false);
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local function rounded_bar(color)
	return wibox.widget {
		max_value        = 100,
		value            = 0,
		forced_width     = 20,
		-- forced_width  = beautiful.bar_width,
		margins          = {
			top = 5,
			bottom = 5,
			-- top = beautiful.bar_margin,
			-- bottom = beautiful.bar_margin,
		},
		shape            = gears.shape.rounded_bar,
		border_width     = 1,
		-- border_width  = beautiful.bar_border,
		color            = color,
		-- background_color = beautiful.bar_bg,
		background_color = "#fafafa",
		border_color     = "#fafafa",
		-- border_color  = beautiful.bar_bordercolor,
		widget           = wibox.widget.progressbar,
	}
end

-- Wallpaper
set_wallpaper()

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])
	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function() awful.layout.inc(1) end),
		awful.button({}, 3, function() awful.layout.inc(-1) end),
		awful.button({}, 4, function() awful.layout.inc(1) end),
		awful.button({}, 5, function() awful.layout.inc(-1) end)))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons
	}

	-- -- Create a tasklist widget
	-- s.mytasklist = awful.widget.tasklist {
	--	   screen  = s,
	--	   filter  = awful.widget.tasklist.filter.currenttags,
	--	   buttons = tasklist_buttons
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
			--	   -- battery = "/sys/class/power_supply/BAT0",
			--	   ac = "AC",
			--	   settings = function ()
			--		   local bat_header = "⚡"
			--		   local bat_p = bat_now.perc
			--
			--		   if bat_now.status == "Not present" then
			--			   bat_header = ""
			--			   bat_p = ""
			--		   elseif bat_now.status == "Discharging" then
			--			   bat_p = lain.util.markup("#ff0000", bat_p)
			--		   else
			--			   bat_p = lain.util.markup("#aa00aa", bat_p)
			--		   end
			--
			--		   widget:set_markup(lain.util.markup("#ff0000", bat_header) .. bat_p)
			--	   end
			-- }),
			-- 			volumearc_widget({
			-- 				timeout = 10,
			-- 				button_press = function(_widget, _lx, _ly, button)
			-- 					if (button == 1) then
			-- 						awful.spawn.easy_async_with_shell('pacmd list-cards | grep -i "active profile" | tail -1 | cut -d " " -f 3 | tr -d "<>"', function(current_profile)
			-- 							local audio_profiles = {
			-- 								"output:iec958-stereo+input:analog-stereo",
			-- 								"off"
			-- 								-- "output:hdmi-stereo-extra1+input:analog-stereo",
			-- 								-- "output:analog-stereo+input:analog-stereo"
			-- 							};
			--
			-- 							current_profile = current_profile:gsub("%s+", "");
			--
			-- 							local new_profile = audio_profiles[1];
			-- 							for k,v in ipairs(audio_profiles) do
			-- 								if v == current_profile then
			-- 									local next_key = k+1
			-- 									if audio_profiles[next_key] then
			-- 										new_profile = audio_profiles[next_key]
			-- 									-- else
			-- 									--	   new_profile = audio_profiles[0]
			-- 									end
			-- 								end
			-- 							end
			--
			-- 							awful.spawn('pactl set-card-profile "alsa_card.usb-Creative_Technology_Ltd_Sound_Blaster_Play__3_00079805-00" ' .. new_profile, false);
			-- 						end)
			-- 					end
			--
			-- 					if (button == 3) then
			-- 						awful.spawn('pavucontrol --tab=3', false)
			-- 					end
			-- 				end
			-- 			}),
			-- volume_bar,
			wibox.widget.systray(),
			mytextclock,
			s.mylayoutbox,
		},
	}
end)
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(

	awful.key({ modkey }, "o", function() awful.client.movetoscreen() end,
		{ description = "Change screen", group = "client" }),
	-- awful.key({ modkey, }, "z", function () quake:toggle() end),
	awful.key(
		{ modkey, "Shift" }, "/", hotkeys_popup.show_help,
		{ description = "show help", group = "awesome" }
	),

	-- Brightness
	awful.key({}, "XF86MonBrightnessUp",
		function()
			awful.spawn("xbacklight -inc 10", false)
		end,
		{ description = "+10%", group = "hotkeys" }
	),
	awful.key({}, "XF86MonBrightnessDown",
		function()
			awful.spawn("xbacklight -dec 10", false)
		end,
		{ description = "-10%", group = "hotkeys" }
	),

	awful.key({}, "XF86AudioPlay",
		function()
			awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
				, false)
		end,
		{ description = "document this", group = "hotkeys" }
	),

	awful.key({}, "XF86AudioNext",
		function()
			awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
				, false)
		end,
		{ description = "document this", group = "hotkeys" }
	),

	awful.key({}, "XF86AudioPrev",
		function()
			awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Prev"
				, false)
		end,
		{ description = "document this", group = "hotkeys" }
	),

	-- awful.key({}, "XF86PowerOff",
	--	   function()
	--		   -- emit signal to show the exit screen
	--		   awesome.emit_signal("show_exit_screen")
	--	   end,
	--	   {description = "toggle exit screen", group = "hotkeys"}
	-- ),

	-- -- restore minimized client
	-- awful.key({modkey, "Shift"}, "n",
	--	   function()
	--		   local c = awful.client.restore()
	--		   -- Focus restored client
	--		   if c then
	--		   client.focus = c
	--		   c:raise()
	--		   end
	--	   end,
	--	   {description = "restore minimized", group = "client"}
	-- )

	awful.key({ modkey, }, "Left", awful.tag.viewprev,
		{ description = "view previous", group = "tag" }),
	awful.key({ modkey, }, "Right", awful.tag.viewnext,
		{ description = "view next", group = "tag" }),
	awful.key({ modkey, }, "Escape", awful.tag.history.restore,
		{ description = "go back", group = "tag" }),

	-- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
	--			 {description = "focus the next screen", group = "screen"}),
	-- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
	--			 {description = "focus the previous screen", group = "screen"}),
	awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab",
		function()
			awful.client.focus.byidx(1)
			if client.focus then
				client.focus:raise()
			end
		end,
		{ description = "focus next window on tag", group = "client" }),

	awful.key({ modkey, "Shift" }, "Tab",
		function()
			awful.client.focus.byidx(-1)
			if client.focus then
				client.focus:raise()
			end
		end,
		{ description = "focus previous window on tag", group = "client" }),

	-- Standard program
	awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
		{ description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart,
		{ description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "Escape", awesome.quit,
		{ description = "quit awesome", group = "awesome" }),

	awful.key(
		{ modkey, "Shift" }, ".",
		function() awful.tag.incmwfact(0.05) end,
		{ description = "increase master width factor", group = "layout" }
	),
	awful.key(
		{ modkey, "Shift" }, ",",
		function() awful.tag.incmwfact(-0.05) end,
		{ description = "decrease master width factor", group = "layout" }
	),

	-- TODO: These are useful, but will not be that commonly used so add a
	-- right-click menu for these
	-- awful.key({ modkey, "Shift"	 }, "h",	 function () awful.tag.incnmaster( 1, nil, true) end,
	--			 {description = "increase the number of master clients", group = "layout"}),
	-- awful.key({ modkey, "Shift"	 }, "l",	 function () awful.tag.incnmaster(-1, nil, true) end,
	--			 {description = "decrease the number of master clients", group = "layout"}),
	-- awful.key({ modkey, "Control" }, "h",	 function () awful.tag.incncol( 1, nil, true)	 end,
	--			 {description = "increase the number of columns", group = "layout"}),
	-- awful.key({ modkey, "Control" }, "l",	 function () awful.tag.incncol(-1, nil, true)	 end,
	--			 {description = "decrease the number of columns", group = "layout"}),
	awful.key(
		{ modkey, "Control" }, ".",
		function() awful.layout.inc(1) end,
		{ description = "select next", group = "layout" }
	),
	awful.key(
		{ modkey, "Control" }, ",",
		function() awful.layout.inc(-1) end,
		{ description = "select previous", group = "layout" }
	),

	-- awful.key({ modkey, "Control" }, "n",
	--			 function ()
	--				 local c = awful.client.restore()
	--				 -- Focus restored client
	--				 if c then
	--				   c:emit_signal(
	--					   "request::activate", "key.unminimize", {raise = true}
	--				   )
	--				 end
	--			 end,
	--			 {description = "restore minimized", group = "client"}),

	-- Prompt
	awful.key(
		{ modkey }, "d",
		function() awful.spawn("rofi -show drun") end,
		-- function () awful.spawn("rofi -show drun -window-command '{window}' -kb-accept-entry '' -kb-accept-alt 'Return'") end,
		{ description = "run prompt", group = "launcher" }
	),

	awful.key(
		{ modkey }, "w",
		function() awful.spawn("rofi -modi combi -combi-modi window,drun -show combi") end,
		{ description = "window switch prompt", group = "launcher" }
	),

	awful.key(
		{ modkey, "Shift" }, "e",
		function() awful.spawn(os.getenv("HOME") .. "/bin/logout.sh") end,
		{ description = "run prompt", group = "launcher" }
	),

	-- Clipboard manager
	awful.key(
		{ modkey }, "c",
		function()
			awful.spawn("rofi -modi \"clipboard:greenclip print\" -show clipboard")
		end,
		{ description = "show clipboard manager", group = "launcher" }
	),

	awful.key({ modkey }, "x",
		function()
			awful.prompt.run {
				prompt       = "Run Lua code: ",
				textbox      = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval"
			}
		end,
		{ description = "lua execute prompt", group = "awesome" }),

	-- Screenshot on prtscn using scrot
	awful.key(
		{}, "Print",
		function()
			awful.util.spawn(os.getenv("HOME") .. "/bin/screenshot.sh", false)
		end
	),

	-- Volume controls
	awful.key(
		{}, "XF86AudioRaiseVolume",
		function()
			awful.util.spawn("pulseaudio-ctl up", false)
		end
	),

	awful.key(
		{}, "XF86AudioLowerVolume",
		function()
			awful.util.spawn("pulseaudio-ctl down", false)
		end
	),

	awful.key(
		{}, "XF86AudioMute",
		function()
			awful.util.spawn("pulseaudio-ctl mute", false)
		end
	)
)

for i, _ in ipairs(navigation_keys) do
	local key = navigation_keys[i][1]
	local dir = navigation_keys[i][2]

	globalkeys = gears.table.join(globalkeys,
		awful.key(
			{ modkey }, key,
			function()
				awful.client.focus.global_bydirection(dir)
				if client.focus then client.focus:raise() end
			end,
			{ description = "focus client " .. dir, group = "client" }
		),

		awful.key(
			{ modkey, "Shift" }, key,
			function()
				awful.client.swap.global_bydirection(dir)
			end,
			{ description = "swap client " .. dir, group = "client" }
		)
	)
end

local clientkeys = gears.table.join(
	awful.key(
		{ modkey, "Shift" }, "f",
		function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{ description = "toggle fullscreen", group = "client" }
	),
	awful.key({ modkey, "Shift" }, "q", function(c) c:kill() end,
		{ description = "close", group = "client" }),
	awful.key(
		{ modkey }, "space",
		function(c)
			-- awful.client.floating.toggle(c)
			c.floating = not c.floating
			awful.placement.no_offscreen(c)
		end,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Shift" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
		{ description = "move to master", group = "client" }),

	awful.key({ modkey, }, "s", function(c) c.sticky = not c.sticky end),
	awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
		{ description = "toggle keep on top", group = "client" }),
	-- awful.key({ modkey,			 }, "n",
	--	   function (c)
	--		   -- The client currently has the input focus, so it cannot be
	--		   -- minimized, since minimized clients can't have the focus.
	--		   c.minimized = true
	--	   end ,
	--	   {description = "minimize", group = "client"}),
	awful.key({ modkey, }, "f",
		function(c)
			c.maximized = not c.maximized
			c:raise()
		end,
		{ description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Shift" }, "m",
		function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{ description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Control" }, "m",
		function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{ description = "(un)maximize horizontally", group = "client" }),

	awful.key({ modkey, "Shift" }, "h",
		function(c)
			awful.placement.centered(c.focus)
		end,
		{ description = "move to the center of the screen", group = "corner movements" }),

	awful.key({ modkey, "Shift" }, "u",
		function(c)
			awful.placement.top_left(c.focus, {
				honor_workarea = true,
				margins = beautiful.useless_gap * 2
			})
		end,
		{ description = "move to the top left corner of the screen", group = "corner movements" }),

	awful.key({ modkey, "Shift" }, "p",
		function(c)
			awful.placement.top_right(c.focus, {
				honor_workarea = true,
				margins = beautiful.useless_gap * 2
			})
		end,
		{ description = "move to the top right corner of the screen", group = "corner movements" }),

	awful.key({ modkey, "Shift" }, "i",
		function(c)
			awful.placement.bottom_left(c.focus, {
				honor_workarea = true,
				margins = beautiful.useless_gap * 2
			})
		end,
		{ description = "move to the bottom left corner of the screen", group = "corner movements" }),

	awful.key({ modkey, "Shift" }, "o",
		function(c)
			awful.placement.bottom_right(c.focus, {
				honor_workarea = true,
				margins = beautiful.useless_gap * 2
			})
		end,
		{ description = "move to the bottom right corner of the screen", group = "corner movements" })
)

for i, _ in ipairs(navigation_keys) do
	local key = navigation_keys[i][1]
	local dir = navigation_keys[i][2]

	clientkeys = gears.table.join(clientkeys,
		awful.key(
			{ modkey, "Control" }, key,
			function(c)
				local screen = awful.screen.focused():get_next_in_direction(dir)

				if screen then
					c:move_to_screen(screen.index)
					awful.placement.centered(c)
					awful.placement.no_offscreen(c, {
						honor_workarea = true,
						honor_padding = true
					})
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
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{ description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{ description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{ description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{ description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c, "bottom_right")
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.centered + awful.placement.no_offscreen
		},
		except_any = {
			name = {
				"Plasma",
			},

			type = {
				"notification",
			},
		}
	},

	-- Make systray/main menu windows appear on all screens (by default they show only on
	-- tag 1)
	{
		rule_any = {
			name = {
				"Plasma",
			},
		},
		properties = {
			sticky = true,
			focusable = true,
		},
	},

	-- plasmashell notification
	{ rule_any = {
		type = {
			"notification",
		},
		-- name = {
		-- 	"Plasma",
		-- },
		-- class = {
		-- 	"plasmashell",
		-- },
	}, properties = {
		floating = true,
		-- border_width = 0,
		-- placement = nil,
		focusable = false,
	} },
	-- -- Floating with no borders
	-- { rule_any = {
	-- 	role = {
	-- 		"pop-up",
	-- 		"task_dialog",
	-- 	},
	-- 	name = {
	-- 		"win7",
	-- 		-- "Desktop — Plasma",
	-- 	},
	-- 	class = {
	-- 		-- "plasmashell",
	-- 		"krunner",
	-- 		"Kmix",
	-- 		"Klipper",
	-- 		"Plasmoidviewer",
	-- 	},
	-- 	}, properties = {
	-- 		floating = true,
	-- 		border_width = 0
	-- }},
	-- Floating clients.
	{ rule_any = {
		instance = {
			"DTA", -- Firefox addon DownThemAll.
			"copyq", -- Includes session name in class.
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
			"MessageWin", -- kalarm.
			"Sxiv",
			"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			"Wpa_gui",
			"veromix",
			"xtightvncviewer",
			"dolphin",
			"kcalc"
		},

		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
			"Event Tester", -- xev.
			"Bluetooth",
		},
		role = {
			"AlarmWindow", -- Thunderbird's calendar.
			"ConfigManager", -- Thunderbird's about:config.
			-- "pop-up",		  -- e.g. Google Chrome's (detached) Developer Tools.
		}
	}, properties = { floating = true } },

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = { "normal", "dialog" }
		},
		properties = { titlebars_enabled = false }
	},

	-- -- TODO why does Chromium always start up floating in AwesomeWM?
	-- -- Temporary fix until I figure it out
	-- {
	-- 	rule_any = {
	-- 		class = {
	-- 			"Chromium-browser",
	-- 			"Chromium",
	-- 		}
	-- 	},
	-- 	properties = { floating = false }
	-- },

	-- -- "Needy": Clients that steal focus when they are urgent
	-- {
	--	   rule_any = {
	--		   class = {
	--			   "TelegramDesktop",
	--			   "firefox",
	--			   "Nightly",
	--		   },
	--		   type = {
	--			   "dialog",
	--		   },
	--	   },
	--	   callback = function (c)
	--		   c:connect_signal("property::urgent", function ()
	--			   if c.urgent then
	--				   c:jump_to()
	--			   end
	--		   end)
	--	   end
	-- },
	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--	 properties = { screen = 1, tag = "2" } },

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
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.

	-- Set the new window as a slave
	if not awesome.startup then awful.client.setslave(c) end

	if not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Restore geometry for floating clients after swapping
tag.connect_signal('property::layout', function(t)
	for k, c in ipairs(t:clients()) do
		if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
			local cgeo = awful.client.property.get(c, 'floating_geometry')
			if cgeo then
				c:geometry(awful.client.property.get(c, 'floating_geometry'))
			end
		end
	end
end)

client.connect_signal('manage', function(c)
	if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
		awful.client.property.set(c, 'floating_geometry', c:geometry())
	end

	if c.name == "Desktop — Plasma" then
		c:kill()
	end
end)

-- Set mouse in the middle of the window when switching with Rofi
-- TODO: Compare mouse/window coords to fix same-screen switching
client.connect_signal('focus', function(c)
	if not (mouse.screen.index == c.screen.index) then
		mouse.coords({
			x = c.x + c.width / 2,
			y = c.y + c.height / 2,
		})
	end
end)

client.connect_signal('property::geometry', function(c)
	if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
		awful.client.property.set(c, 'floating_geometry', c:geometry())
	end
end)

-- -- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--	   -- buttons for the titlebar
--	   local buttons = gears.table.join(
--		   awful.button({ }, 1, function()
--			   c:emit_signal("request::activate", "titlebar", {raise = true})
--			   awful.mouse.client.move(c)
--		   end),
--		   awful.button({ }, 3, function()
--			   c:emit_signal("request::activate", "titlebar", {raise = true})
--			   awful.mouse.client.resize(c)
--		   end)
--	   )
--
--	   awful.titlebar(c) : setup {
--		   { -- Left
--			   awful.titlebar.widget.iconwidget(c),
--			   buttons = buttons,
--			   layout  = wibox.layout.fixed.horizontal
--		   },
--		   { -- Middle
--			   { -- Title
--				   align  = "center",
--				   widget = awful.titlebar.widget.titlewidget(c)
--			   },
--			   buttons = buttons,
--			   layout  = wibox.layout.flex.horizontal
--		   },
--		   { -- Right
--			   awful.titlebar.widget.floatingbutton (c),
--			   awful.titlebar.widget.maximizedbutton(c),
--			   awful.titlebar.widget.stickybutton	(c),
--			   awful.titlebar.widget.ontopbutton	(c),
--			   awful.titlebar.widget.closebutton	(c),
--			   layout = wibox.layout.fixed.horizontal()
--		   },
--		   layout = wibox.layout.align.horizontal
--	   }
-- end)

-- Disable ontop when the client is not floating, and restore ontop if needed
-- when the client is floating again
-- I never want a non floating client to be ontop.
client.connect_signal('property::floating', function(c)
	if c.floating then
		if c.restore_ontop then
			c.ontop = c.restore_ontop
		end
	else
		c.restore_ontop = c.ontop
		c.ontop = false
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

local function customBorder(c)
	-- Sometimes windows do strange things and borders disappear
	--	if (not c.fullscreen and c.border_width ~= beautiful.border_width) then
	--		c.border_width = beautiful.border_width
	--	end

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
screen.connect_signal("arrange", function(s)
	for _, c in pairs(s.clients) do
		customBorder(c)
	end
end)

-- Attempt to prevent memory leak
-- https://www.reddit.com/r/awesomewm/comments/cex6j6/memory_leak_when_setting_shapes_for_clients/
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

-- }}}
