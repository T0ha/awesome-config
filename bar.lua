local awful = awful
local widget = widget
local screen = screen
local client = client
local modkey = modkey
local mypromptbox = mypromptbox

local menu = require("menu")
local xkb = require("xkb")
local vicious = require("vicious")

module("bar")



-- Taglist
function create_taglist(screen)
  
   buttons = awful.util.table.join(
      awful.button({ }, 1, awful.tag.viewonly),
      awful.button({ modkey }, 1, awful.client.movetotag),
      awful.button({ }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, awful.client.toggletag),
      awful.button({ }, 4, awful.tag.viewnext),
      awful.button({ }, 5, awful.tag.viewprev)
					    )
   return awful.widget.taglist(screen, awful.widget.taglist.label.all, buttons)
end

--Tasklist
function create_tasklist(screen)
   buttons = awful.util.table.join(
      awful.button({ }, 1, function (c)
		      if c == client.focus then
			 c.minimized = true
		      else
			 if not c:isvisible() then
			    awful.tag.viewonly(c:tags()[1])
			 end
			 -- This will also un-minimize
			 -- the client, if needed
			 client.focus = c
			 c:raise()
		      end
			   end),
      awful.button({ }, 3, function ()
		      if instance then
			 instance:hide()
			 instance = nil
		      else
			 instance = awful.menu.clients({ width=250 })
		      end
			   end),
      awful.button({ }, 4, function ()
		      awful.client.focus.byidx(1)
		      if client.focus then client.focus:raise() end
			   end),
      awful.button({ }, 5, function ()
		      awful.client.focus.byidx(-1)
		      if client.focus then client.focus:raise() end
			   end))
   return awful.widget.tasklist(function(c)
				   return awful.widget.tasklist.label.currenttags(c, screen)
				end, buttons)
end



function create_layoutbox(screen, layouts)
   mylayoutbox = {}
   mylayoutbox = awful.widget.layoutbox(screen)
   mylayoutbox:buttons(awful.util.table.join(
			     awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			     awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
   return mylayoutbox
end

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })


for s = 1,  screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

   top = {
      {
	 menu.create(),
	 create_taglist(s),
	 mypromptbox[s],
	 layout = awful.widget.layout.horizontal.leftright
      },
      
      create_layoutbox(s),
      mytextclock,
      s == 1 and mysystray or nil,
      s == 1 and xkb.kbdcfg.widget or nil,
      create_tasklist(s),
      layout = awful.widget.layout.horizontal.rightleft
   }
   awful.wibox({screen = s, position = "top", widgets = top})
   
   cpu = widget({ type = "textbox"})
   vicious.register(cpu, vicious.widgets.cpu, "CPU: $1 % |")
   
   mem = widget({ type = "textbox" })
   vicious.register(mem, vicious.widgets.mem, " RAM: $1% ($2MB / $3MB) |")

   hdd = widget({ type = "textbox" })
   vicious.register(hdd, vicious.widgets.fs, " HDD: / ${/ avail_gb}GB; /home ${/home avail_gb}GB; /srv ${/srv avail_gb}GB |" )

   bat = widget({ type = "textbox" })
   vicious.register(bat, vicious.widgets.bat, "Batery: $1 ($2%  $3s) ", 10, "BAT0")
   
   bottom = { 
      s == 1 and cpu or nil,
      s == 1 and mem or nil,
      s == 1 and hdd or nil,
      s == 1 and bat or nil,
      -- s == 1 and xkb.indicators.widget or nil,
      layout = awful.widget.layout.horizontal.leftright
   }
   awful.wibox({screen = s, position = "bottom", widgets = bottom})
end
