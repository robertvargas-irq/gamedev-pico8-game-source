battle_manager={
    active={},
    cache={}
}

function battle_manager.get(x,y)
    -- get x
    if battle_manager.cache[x]==nil then
        battle_manager.cache[x]={}
    end
    local x_battles=battle_manager.cache[x]

    -- get y
    if x_battles[y]==nil then
        
        local enemies=level.active:get_room(x,y).enemies
        assert(enemies,'no enemies found in the room, battle is invalid')
        x_battles[y]=battle:new(x,y,{enemies=enemies})
    end

    -- set as active and return
    battle_manager.active=x_battles[y]
    return battle_manager.active
end

function battle_manager.clear()
    battle_manager.active={}
    battle_manager.cache={}
end

function battle_manager.get_active()
    assert(battle_manager.active,'error: no active battle in battle_manager found')
    return battle_manager.active
end