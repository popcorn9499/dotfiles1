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
 
     --CCreate a tasklist widget

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
                    color         = '#000000',
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
                local tooltip = awful.tooltip({
                    objects = { self },
                    timer_function = function()
                      return c.name
                    end,
                  })
                
                  -- Then you can set tooltip props if required
                  tooltip.align = "left"
                  tooltip.mode = "outside"
                  tooltip.preferred_positions = {"left"}
                
            end,
            layout = wibox.layout.align.vertical,
        }
    }
 
    local bg = wibox.container.background()
    bg:set_bg("#ff0000")
    
    local tb1 = wibox.widget.textbox()
    local tb2 = wibox.widget {
        checked       = false,
        color         = beautiful.bg_normal,
        paddings      = 2,
        shape         = gears.shape.circle,
        widget        = wibox.widget.checkbox
    }--wibox.widget.textbox("bar")

    tb2.checked=true
    tb1:set_text("foo")
    --tb2:set_text("bar")
    
    local l = wibox.layout.fixed.vertical()
    --l:add(tb1)
    l:add(tb2)
    
    bg:set_widget(l)

    local box_pressed = function(widget,lx, ly, button, mods)
       awful.spawn("notify-send box pressed ")

       print(lx)
       print(ly)
       print(button)
       print(mods)
       --print(find_widgets_result)
    for key, value in pairs(mods) do
        print(key, value)
    end

    --print(awful.tasklist.filter.allscreen())

       --find_widgets_result.checked = not tb2.checked
       tb2.checked= not tb2.checked
    end

    tb2:connect_signal("button::press", box_pressed)

    -- tb.connect_signal("button::press, function (c)
    --     awful.spawn("notify-send test1")

    --end)
    -- local bg = wibox.widget {
    --     {
    --         {
    --             text = "foo",
    --             widget = wibox.widget.textbox
    --         },
    --         {
    --             text = "bar",
    --             widget = wibox.widget.textbox
    --         },
    --         layout = wibox.layout.fixed.vertical
    --     },
    --     bg = "#ff0000",
    --     widget = wibox.container.background
    -- }
    
--     local common = require("awful.widget.common")
--     local function list_update(w, buttons, label, data, objects)
--         common.list_update(w, buttons, label, data, objects)
--         awful.spawn("notify-send test ")
--         w:set_max_widget_size(300)
--     end

--     tasklist_buttons = {
--                 awful.button({ }, 1, function (c) c:activate { context = "tasklist", action = "toggle_minimization" }
--                 end),
--                 awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
--                 awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
--                 awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
--             }

-- s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, nil, list_update, wibox.layout.flex.horizontal())
 



     -- Create the wibox
     s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 30, ontop = true})

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
            bg,

            mykeyboardlayout,
            s.systray,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)

 -- }}}
