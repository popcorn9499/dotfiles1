pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")

-- Widget and layout library
local wibox = require("wibox")
-- Notification library
--local naughty = require("naughty")
local menubar = require("menubar")

require("modules.config")


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
 }
 
 mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                     { "open terminal", terminal }
                                    }
                         })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                    menu = mymainmenu })
 
 -- Menubar configuration
 menubar.utils.terminal = terminal -- Set the terminal for applications that require it
 -- }}}
 
 -- {{{ Tag
 -- Table of layouts to cover with awful.layout.inc, order matters.
 tag.connect_signal("request::default_layouts", function()
     awful.layout.append_default_layouts({
         awful.layout.suit.floating,
         awful.layout.suit.tile,
         awful.layout.suit.tile.left,
         awful.layout.suit.tile.bottom,
         awful.layout.suit.tile.top,
         awful.layout.suit.fair,
         awful.layout.suit.fair.horizontal,
         awful.layout.suit.spiral,
         awful.layout.suit.spiral.dwindle,
         awful.layout.suit.max,
         awful.layout.suit.max.fullscreen,
         awful.layout.suit.magnifier,
         awful.layout.suit.corner.nw,
     })
 end)
 -- }}}
 
 -- {{{ Wibar
 
 -- Keyboard map indicator and switcher
 mykeyboardlayout = awful.widget.keyboardlayout()
 
 -- Create a textclock widget
 mytextclock = wibox.widget.textclock()
 
 screen.connect_signal("request::wallpaper", function(s)
     -- Wallpaper
     if beautiful.wallpaper then
         local wallpaper = beautiful.wallpaper
         -- If wallpaper is a function, call it with the screen
         if type(wallpaper) == "function" then
             wallpaper = wallpaper(s)
         end
         gears.wallpaper.maximized(wallpaper, s, true)
     end
 end)
 
 screen.connect_signal("request::desktop_decoration", function(s)
     -- Each screen has its own tag table.
     awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
 
     -- Create a promptbox for each screen
     s.mypromptbox = awful.widget.prompt()
 
     -- Create an imagebox widget which will contain an icon indicating which layout we're using.
     -- We need one layoutbox per screen.
     s.mylayoutbox = awful.widget.layoutbox {
         screen  = s,
         buttons = {
             awful.button({ }, 1, function () awful.layout.inc( 1) end),
             awful.button({ }, 3, function () awful.layout.inc(-1) end),
             awful.button({ }, 4, function () awful.layout.inc(-1) end),
             awful.button({ }, 5, function () awful.layout.inc( 1) end),
         }
     }
 
     -- Create a taglist widget
     s.mytaglist = awful.widget.taglist {
         screen  = s,
         filter  = awful.widget.taglist.filter.all,
         buttons = {
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
             awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
             awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
         }
     }
 
     -- Create a tasklist widget

     s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = {
            awful.button({ }, 1, function (c) c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        },
        layout   = {
            spacing_widget = {
                {
                    forced_width  = 5,
                    forced_height = 24,
                    thickness     = 1,
                    color         = '#777777',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 1,
            layout  = wibox.layout.fixed.horizontal
        },
        --Notice that there is *NO* wibox.wibox prefix, it is a template,
        --not a widget instance.
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 5,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 5,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        }
    }
     
 
     -- Create the wibox
     s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 30})

     s.systray = wibox.widget.systray()

     -- Add widgets to the wibox
     s.mywibox.widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            s.systray,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)

 -- }}}
