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
    o.x=x
    o.y=y
    return setmetatable(o or {}, self)
end

function battle:calculate_dc()
    return globals.get_difficulty()/2
    +#self.enemies*2
    +current_level*2
end

function battle:start()
    -- swap to battle screen
    screen=2
    battle_scene.battle=self

    sound_encounter_start()()
    
    -- wait 1 second before enabling player controls
    player_manager.get().is_current_turn=false
    wait(function()
        -- begin battle music
        music(-1, 500)
        music(5)

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
    self.__turn+=1
    if self.__turn > #self.enemies then
        self.__turn=0
    end

    -- adjust player's turn; return if it is
    local p=player_manager.get()
    if self.__turn==0 then
        -- make turn and play "ready" sound effect
        sound_ready()
        p.is_current_turn=true
        return
    else
        p.is_current_turn=false
    end

    -- have the enemy attack the player
    local en=self.enemies[self.__turn]
    -- if unconscious, then move on to the next turn
    if en.health <= 0 then
        self.__turn-=1
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
    self.__turn+=turns or 1
    return self.__turn
end

function battle:stop()
    -- remove battle from scene and manager
    battle_scene.battle=nil

    -- place player in the battle position if won
    local p=player_manager.get()
    if self:is_won() then
        local pcoords=battle_scene.get_player_pos()
        p.x=pcoords.x
        p.y=pcoords.y
    end

    -- swap back to level
    level_play.init()

    -- give rewards
    self:drop_rewards()
end

local offset=0
local dur={'temp','perm'}
local name={'damage','health','accuracy'}
local s_off={temp=0,perm=3}
local s_fx={temp=4,perm=7}
local rewards={
    function(p) -- heal
        sfx(3)
        fx:new(63,64-offset,1,1,{251},60,12):animate()
        p:heal(flr(rnd(50)))
    end,
    function(p) -- bonuses
        -- temp or perm
        local c=rnd(dur)

        -- bonus type index {1: damage, 2: health, 3: accuracy}
        local b=flr(rnd(3))+1
        -- name of the type
        local n=name[b]
        -- sprite for the requested bonus
        local s=229+s_off[c]+b

        -- play sound effect for either temp or perm
        sfx(s_fx[c])

        -- apply to player
        p.bonuses[c][n]+=flr(rnd(10))+10
        local sp={temp=232,perm=235}
        fx:new(63,64-offset,1,1,{sp[c]},60,12):animate()
    end
}
function battle:drop_rewards()
    for i=1,rnd(3)+current_level,1 do
        rnd(rewards)(player_manager.get())
        offset+=10
    end
    offset=0
end