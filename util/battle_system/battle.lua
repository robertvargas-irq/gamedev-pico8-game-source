battle={
    turn_delay=0.2,
    entry_delay=0.5,
    x=0,
    y=0,
    enemies=nil,
    __turn=-1
}
battle.__index=battle

-- battle constructor
function battle:new(x,y,o)
    o.x = x
    o.y = y
    return setmetatable(o or {}, self)
end

function battle:start()
    -- swap to battle screen
    globals.screen = 2
    battle_scene.battle = self

    -- begin battle music
    sound_fx.encounter_start()
    
    -- wait 1 second before enabling player controls
    player_manager.get().is_current_turn = false
    wait(function()
        sfx(5,0,0)
        self:advance()
    end,self.entry_delay)
end

-- check for all enemies unconscious
function battle:is_won()

    -- return false if at least one enemy is left standing
    for en in all(self.enemies) do
        if en.health > 0 then return false end
    end
    return true
end

function battle:advance()

    -- advance to the next turn
    self.__turn += 1
    if self.__turn > #self.enemies then
        self.__turn = 0
    end

    -- adjust player's turn; return if it is
    local p = player_manager.get()
    if self.__turn == 0 then
        -- make turn and play "ready" sound effect
        sound_fx.ready()
        p.is_current_turn = true
        return
    else
        p.is_current_turn = false
    end

    -- have the enemy attack the player
    local en = self.enemies[self.__turn]
    -- if unconscious, then move on to the next turn
    if en.health <= 0 then
        self.__turn -= 1
        del(level.active:get_room(self.x,self.y).enemies,en)

        -- if all enemies are unconscious, stop the battle
        if self:is_won() then
            for en in all(self.enemies) do
                del(self.enemies,en)
            end
            return self:stop()
        else
            return self:advance()
        end
    end

    -- if conscious attack
    wait(function()
        en:attack()
        self:advance()
    end,self.turn_delay)

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

    -- place player in the battle position if won
    local p = player_manager.get()
    if self:is_won() then
        local pcoords = battle_scene.get_player_pos()
        p.x = pcoords.x
        p.y = pcoords.y
    end

    -- stop battle music
    sfx(5,-2,0)

    -- swap back to level
    globals.screen = 1
end