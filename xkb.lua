local wibox = wibox
local awful = awful
local os = os
local awesome = awesome
local screen = screen
local math = math
local tags = tag
local root =root

module("xkb")

-- Keyboard map indicator and changer
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "" }, { "ru", "" } }
kbdcfg.current = 1  -- us is our default layout
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text( " " .. kbdcfg.layout[kbdcfg.current][1] .. " ")
kbdcfg.switch = function ()
      kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
      local t = kbdcfg.layout[kbdcfg.current]
      kbdcfg.widget:set_text( " " .. t[1] .. " ")
      os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end
    
-- Mouse bindings
kbdcfg.widget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () kbdcfg.switch() end)
))
indicators = {}
indicators.widget = wibox.widget.textbox()
-- indicators.widget: = function()
--   {}
-- end
