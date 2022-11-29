-- sound effect
--[[
    handles any sound effects
]]
function sound_ready() sfx(0,-1,0,10) end
function sound_enemy_hit() sfx(0,-1,16,12) end
function sound_enemy_miss() sfx(1,-1,0,4) end
function sound_player_miss() sfx(2,-1,5,2) end
function sound_player_hit() sfx(2,-1,0,4) end
function sound_select() sfx(0,-1,12,3) end
function sound_footstep_1() sfx(1,0,5,2) end
function sound_footstep_2() sfx(1,0,8,2) end
function sound_tip() sfx(0,-1,29,2) end
function sound_merchant_reached() sfx(1,-1,12,4) end
function music_room()
    local m={0,3}
    music(-1, 500)
    music(m[current_level])
end

function sound_encounter_start()
    sfx(0,-1,29,2)
    wait(function()
        sfx(0,-1,29,2)
        wait(function()
            sfx(0,-1,29,2)
            wait(function()
                sfx(0,-1,29,2)
            end,0.17)
        end,0.15)
    end,0.15)
end