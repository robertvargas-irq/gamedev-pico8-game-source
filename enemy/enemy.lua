enemy={
    sprite=-1,
    x=64,
    y=64,
    w=1,
    h=1,
    max_health=200,
    health=0,

    -- for combat
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
--    attacks
--]]
function enemy:attack()

    -- TODO: implement damage scaling

    -- check if hit; if not, play miss sfx and return
    local hit=rnd(100) < globals.get_difficulty()
    if not hit then
        sound_enemy_miss()
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
    sound_player_hit()
end




-- primary draw loop
function enemy:draw_health_bar()
    local bar_length,bar_height,perc_health_left=10,5,(self.health)/self.max_health
    local sx,sy,sh,b_l_half=self.x,self.y,self.h,bar_length/2

    -- red bar
    if self.health < self.max_health then
        line(
            sx-b_l_half,
            sy-bar_height-8*sh,
            sx+b_l_half-1,
            sy-bar_height-8*sh,
            8
        )
    end

    -- green bar
    line(
        sx-b_l_half,
        sy-bar_height-8*sh,
        (sx+b_l_half)-(1-perc_health_left)*bar_length,
        sy-bar_height-8*sh,
        11
    )

    -- print out health with dynamic color based on percent left
    local nm_clr=11-(1-perc_health_left)*3
    print(self.health,sx,sy-1.5*sh,0)
    print(self.health,sx,sy-2*sh,nm_clr)
    
end

function enemy:_draw()
    local sx,sy,sw,sh=self.x,self.y,self.w,self.h
    if self.sprite > -1 then
        -- draw sprite
        spr(self.sprite,sx-4*sw,sy-8*sh,sw,sh)
    else
        -- debug circle fill
        circfill(sx,sy,sw*sw+sh*sh,7)
        spr(207,sx,sy)
    end

    self:draw_health_bar()
end