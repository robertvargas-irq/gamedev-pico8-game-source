pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- includes
#include globals.lua
#include list.lua
#include room.lua
#include floor.lua
#include level.lua
#include scenes/main_menu.lua
#include scenes/debug_levels.lua

-->8
-- _init() start

function _init()
	globals.screen=0
end
-->8
-- _update() loop

function _update()
	if globals.screen==0 then return main_menu._update() end
	if globals.screen==1 then return print('levels _update() not ready') end
	if globals.screen==999 then return debug_levels._update() end
end
-->8
-- _draw() loop

function _draw()
	if globals.screen==0 then return main_menu._draw() end
	if globals.screen==1 then return print('levels _draw() not ready') end
	if globals.screen==999 then return debug_levels._draw() end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044944400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700046967700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000046966400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000046966400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700046966400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044944400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
