enemy={
    sprite=-1,
    x=64,
    y=64,
    w=1,
    h=1,
    max_health=200,
    health=0,

    -- for combat
    damage=nil,
    damage_bonus=0
}
enemy.__index=enemy

-- constructor
function enemy:new(x,y,o)
    o.x=x
    o.y=y
    o.damage={
        light=1,
        medium=1,
        heavy=1
    }
    o.health=o.max_health or self.max_health
    return setmetatable(o or {}, self)
end

-- move to a new position
function enemy:set_pos(x,y)
    self.x=x
    self.y=y
end


-- take damage
function enemy:take_damage(damage)
    self.health=max(0,self.health-damage)
    return self.health
end

-- heal up
function enemy:heal(health)
    self.health=min(max_health,self.health+health)
    return self.health
end

--[[
    attacks
]]
function enemy:attack()

    -- TODO: implement damage scaling

    -- check if hit; if not, play miss sfx and return
    local hit=rnd(100) < globals.get_difficulty()
    if not hit then
        sound_fx.miss()
        fx:new(self.x-4,self.y+8,1,1,{207},1,30):animate()
        return
    end

    -- attack hits, calculate damage
    local options={'light','medium','heavy'}
    local attack=self.damage[options[flr(rnd(#options))+1]]
   +self.damage_bonus
    local pl=player_manager.get()
    local visual_pl=battle_scene.get_player_pos()

    -- attack and play fx
    pl:take_damage(attack)
    fx:new(visual_pl.x-2,visual_pl.y-6,2,2,{236},1,30):animate()
    fx:new(self.x-4,self.y+8,1,1,{223},1,30):animate()
    sound_fx.player_hit()
end




-- primary draw loop
function enemy:draw_health_bar()
    local bar_length=10
    local bar_height=5
    local perc_health_left=(self.health)/self.max_health

    -- red bar
    if self.health < self.max_health then
        line(
            self.x-bar_length/2,
            self.y-bar_height-8*self.h,
            self.x+bar_length/2-1,
            self.y-bar_height-8*self.h,
            8
        )
    end

    -- green bar
    line(
        self.x-bar_length/2,
        self.y-bar_height-8*self.h,
        (self.x+bar_length/2)-(1-perc_health_left)*bar_length,
        self.y-bar_height-8*self.h,
        11
    )

    -- print out health with dynamic color based on percent left
    local nm_clr=11-(1-perc_health_left)*3
    print(self.health,self.x,self.y-2*self.h,nm_clr)
    
end

function enemy:_draw()
    if self.sprite > -1 then
        -- draw sprite
        spr(self.sprite,self.x-4*self.w,self.y-8*self.h,self.w,self.h)
    else
        -- debug circle fill
        circfill(self.x,self.y,self.w*self.w+self.h*self.h,7)
        spr(207,self.x,self.y)
    end

    self:draw_health_bar()
end