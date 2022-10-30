battle={
    x=0,
    y=0,
    enemies=nil,
    __turn=0
}
battle.__index=battle

-- battle constructor
function battle:new(x,y,o)
    self.x=x
    self.y=y
    return setmetatable(o or {}, self)
end

function battle:start()
    -- swap to battle screen
    globals.screen = 2
    battle_scene.battle = self
end


--[[
    turn manager
]]
function battle:get_turn()
    return self.__turn
end

function battle:add_turn(turns)
    self.__turn += turns or 1
    return self.__turn
end

function battle:stop()
    -- remove battle from scene and manager
    battle_scene.battle = nil

    -- swap back to level
    globals.screen = 1
end