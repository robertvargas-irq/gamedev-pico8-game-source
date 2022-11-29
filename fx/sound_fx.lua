-- sound effect
--[[
    handles any sound effects
]]

sound_fx={}

function sound_fx.ready()
    sfx(0,-1,0,10)
end

function sound_fx.hit()
    sfx(0,-1,16,12)
end

function sound_fx.miss()
    sfx(1,-1,0,4)
end

function sound_fx.player_miss()
    sfx(2,-1,5,2)
end

function sound_fx.player_hit()
    sfx(2,-1,0,4)
end

function sound_fx.hit_quick()
    sfx(0,1,16,4)
end

function sound_fx.select()
    sfx(0,-1,12,3)
end

function sound_fx.footstep1()
    sfx(1,0,5,2)
end

function sound_fx.footstep2()
    sfx(1,0,8,2)
end

function sound_fx.tip()
    sfx(0,-1,29,2)
end

function sound_fx.merchant_reached()
    sfx(1,-1,12,4)
end

function sound_fx.item_found()
    sfx(1,-1,12,4)
end

function sound_fx.room_music()
    local m = {0}
    music(-1, 500)
    music(m[current_level])
end

function sound_fx.encounter_start()
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