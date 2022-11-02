floor_enemies={
    current=nil
}

local function get_enemies()
    -- if no enemies, it is a safe room
    if floor_enemies.current==nil or level.active==nil then return nil end
    local fl=level.active:get_active_room()
    if not fl then return nil end
    return fl.enemies
end

-- switch current room
function floor_enemies.switch_room(x,y)
    floor_enemies.current={x,y}

    -- arrange enemies on screen
    local enemies=get_enemies()
    if enemies==nil then return end

end--func

function floor_enemies.set_battle_tiles()
    local enemies=get_enemies()
    if enemies==nil or #enemies < 1 then
        for x=8,120,8 do
            mset(x/8,x/8,0)
            mset((x-8)/8,(128-x)/8,0)
        end
        return
    end

    -- since there are enemies in the room, render warnings
    for x=8,120,8 do
        mset(x/8,x/8,globals.battle_spr)
        mset(x/8,(120-x)/8,globals.battle_spr)
    end
end

local interval=0
local interval_start=3
local interval_max=6
function floor_enemies._draw()

    local enemies=get_enemies()
    if enemies==nil or #enemies < 1 then return end

    -- since there are enemies in the room, render warnings
    local offset=0
    for x=8,120-8,8 do
        local sprite=interval_start+(interval+offset)%(interval_max-interval_start)
        spr(interval_start+(interval+offset)%(interval_max-interval_start),x,x)
        spr(interval_start+(interval+offset*2)%(interval_max-interval_start),x,120-x)
        offset+=1
    end
    interval+=10/globals.fps
    if interval_start+interval > interval_max then
        interval=0
    end

    -- draw all enemies on screen
    for en in all(enemies) do
        en:_draw()
    end

end