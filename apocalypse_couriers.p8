pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- includes
#include globals.lua
#include list.lua
#include room.lua
#include floor.lua
#include level.lua
#include player.lua
#include scenes/main_menu.lua
#include scenes/level_play.lua
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
	if globals.screen==1 then return level_play._update() end
	if globals.screen==999 then return debug_levels._update() end
end
-->8
-- _draw() loop

function _draw()
	if globals.screen==0 then return main_menu._draw() end
	if globals.screen==1 then return level_play._draw() end
	if globals.screen==999 then return debug_levels._draw() end
end

__gfx__
00000000000000000555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044944405566565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700046967705656665500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000046966406576555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000046966405576566500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700046966405766556500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044944405665565600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000656675000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dbd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07d70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d766d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3b3333333333333303bb6bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33300000000000003036b6bb0d0dd0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b300333333333333303bb6bb00d7bd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
300336bb6b6b6b6b3036b6bb0d7bb7d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30336bbbbbbbbbbb303bbb6b0dbbbbd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3036b6bbb66b66663036b6bb00db7d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303b6b6b6bb6bbbb303bb6bb0d0dd0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303bbbbbbbbbbbbb3036bb6b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003336b6bbb6bbb44400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000b6bbb6bbb6b4940000000000b000b000000b00000b00b0000000000000000000000000000000000000000000000000000000000000000000000000
000000003bbbb6bb6b6bb644000600b0000070b00000b0000b0b00b0000000000000000000000000000000000000000000000000000000000000000000000000
000000006b6b6b6bbbb6b6bb00000bb000000b0000000000b00b0000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb66bbbb6b00000000000000000b00000000000b00000000000000000000000000000000000000000000000000000000000000000000000000
00000000b66b66463bb6b6bb000000000b000600000000b00000b00b000000000000000000000000000000000000000000000000000000000000000000000000
000000006bb6b49430bbb6bb600000000b0b00b0b000b0000b00b0b0000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbb443036bb6b00000060500000000000000000b0b0b0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000003300080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000300003333000003300088000088
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000000000330033333300003300008800880
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333333333333333000330000003300000888800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333333333333333000330000003300000088000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000000000330000330000333333000888800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000300000330000033330008800880
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000003300088000088
__gff__
0000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060a122280000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000000000
__map__
4470707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f700f7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020f027000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
700f0f7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4470707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
