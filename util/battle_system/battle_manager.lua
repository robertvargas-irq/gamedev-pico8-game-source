battle_manager={}

function battle_manager.get(x,y)
    -- get x
    if not battle_manager[x] then
        battle_manager[x] = {}
    end
    local x_battles = battle_manager[x]

    -- get y
    if not x_battles[y] then
        -- get enemies to attach to the battle then create
        local enemies = level.active.graph[x][y].enemies
        x_battles[y] = battle:new(x,y,{enemies=enemies})
    end

    -- return battle
    return x_battles[y]
end