-- player class

player={
    spr=16,
    x=0,
    y=0,
    w=1,
    h=1,
    center=nil,
    room=nil,
    active=false,
    movement_boost=1,
    damage={
        light={
            all=5,
            x1=10
        },
        heavy={
            all=40,
            x1=70
        }
    },
    health=100,
    max_health=100,

    -- for combat
    is_current_turn=true,
    accuracy=0.8,

    -- for visuals
    facing_left=false,
    facing_right=false,
    facing_up=false,
    walking=false,
}
player.__index=player

function player:new(o)
    -- combat bonuses
    o.bonuses={
        temp={
            damage=0,
            health=0,
            accuracy=0
        },
        perm={
            damage=5,
            health=0,
            accuracy=0
        }
    }

    o.room={0,0}
    o.center={self.x+2,self.y+4}
    o.health = (o.max_health or self.max_health) + o.bonuses.temp.health + o.bonuses.perm.health
    return setmetatable(o or {}, self)
end--player:new()

function player:spawn(x,y)
    self.active=true
    self.x=x
    self.y=y
end--player:spawn()

-- ! it was 7am i'm sorry, i'll fix this when i get the chance
local cycle = 0
local cycles_per_second = 60
function player:render()

    -- rendering variables
    local r_x = (self.x-4*self.w/2)
    local r_y = (self.y-4*self.h/2-1)

    -- increment animation cycle if walking
    if self.walking then
        cycle += 1 / cycles_per_second * globals.fps
        if cycle >= cycles_per_second then cycle = 0 end

        -- only play footsteps at 0 and halfway
        if flr(cycle) == 0 then
            sound_fx.footstep1()
        elseif flr(cycle) == 30 then
            sound_fx.footstep2()
        end
    end

    -- up walking animation
    if self.facing_up then
        -- animate in intervals of 5
        if self.walking then
            if cycle < cycles_per_second / 4 then
                return spr(self.spr+1*self.w,r_x,r_y,self.w,self.h,false,false)
            elseif cycle < cycles_per_second / 4 * 2 then
                return spr(44,r_x,r_y,self.w,self.h,false,false)
            elseif cycle < cycles_per_second / 4 * 3 then
                return spr(self.spr+1*self.w,r_x,r_y,self.w,self.h,false,false)
            else
                return spr(46,r_x,r_y,self.w,self.h,false,false)
            end
        else
            -- no animation
            return spr(44,r_x,r_y,self.w,self.h,false,false) 
        end
    end

    -- left walking animation
    if self.facing_left then
        -- animate if walking
        if self.walking then
            if cycle < cycles_per_second / 4 then
                return spr(self.spr+3*self.w,r_x,r_y,self.w,self.h,true,false)
            elseif cycle < cycles_per_second / 4 * 2 then
                return spr(self.spr+2*self.w,r_x,r_y,self.w,self.h,true,false)
            elseif cycle < cycles_per_second / 4 * 3 then
                return spr(self.spr+3*self.w,r_x,r_y,self.w,self.h,true,false)
            else
                return spr(self.spr+2*self.w,r_x,r_y,self.w,self.h,true,false)
            end
        else
            -- not walking
            return spr(self.spr+3*self.w,r_x,r_y,self.w,self.h,true,false)
        end
    end

    -- right walking animation
    if self.facing_right then
        -- animate if walking
        -- animate if walking
        if self.walking then
            if cycle < cycles_per_second / 4 then
                return spr(self.spr+3*self.w,r_x,r_y,self.w,self.h,false,false)
            elseif cycle < cycles_per_second / 4 * 2 then
                return spr(self.spr+2*self.w,r_x,r_y,self.w,self.h,false,false)
            elseif cycle < cycles_per_second / 4 * 3 then
                return spr(self.spr+3*self.w,r_x,r_y,self.w,self.h,false,false)
            else
                return spr(self.spr+2*self.w,r_x,r_y,self.w,self.h,false,false)
            end
        else
            -- not walking
            return spr(self.spr+3*self.w,r_x,r_y,self.w,self.h,false,false)
        end
    end

    -- walking forward animation
    if self.walking then
        -- animate in intervals of 5
        if cycle < cycles_per_second / 4 then
            return spr(8,r_x,r_y,self.w,self.h,false,false)
        elseif cycle < cycles_per_second / 4 * 2 then
            return spr(40,r_x,r_y,self.w,self.h,false,false)
        elseif cycle < cycles_per_second / 4 * 3 then
            return spr(8,r_x,r_y,self.w,self.h,false,false)
        else
            return spr(42,r_x,r_y,self.w,self.h,false,false)
        end
    end
    spr(self.spr,r_x,r_y,self.w,self.h)
end--player:spawn()

function player:move(dx,dy)
    -- local tile=mget(dx,dy)
    local hitbox_offset_x = 0
    local hitbox_offset_y = 0

    -- if right
    if dx > 0 then
        hitbox_offset_x = self.w * 2 + 4
        self.facing_left = false
        self.facing_right = true
    -- else left
    elseif dx < 0 then
        hitbox_offset_x = self.w * 2 - 4
        self.facing_left = true
        self.facing_right = false
    else
        self.facing_left = false
        self.facing_right = false
    end--l/r/c

    -- if down
    if dy > 0 then
        hitbox_offset_y = self.h * 2 + 1
        self.facing_up = false
    -- else up
    elseif dy < 0 then
        self.facing_up = true
    else
        self.facing_up = false
    end--d/u

    -- toggle walking animations
    if dx == 0 and dy == 0 then
        self.walking = false
    else
        self.walking = true
    end

    -- calculate collission
    local tile_solid=fget(mget((self.x+dx+hitbox_offset_x)/8,(self.y+dy+4+hitbox_offset_y)/8),7)
    or fget(mget((self.x+dx)/8,(self.y+dy+4)/8),7)
    or fget(mget((self.x+dx+4)/8,(self.y+dy+4)/8),7)
    or fget(mget((self.x+dx-1)/8,(self.y+dy+4)/8),7)
    if not tile_solid then
        self.x+=dx*self.movement_boost
        self.y+=dy*self.movement_boost
        self.center={self.x+2,self.y+4}
    end
end--player:move()

--[[
    health
]]

-- health manager
function player:take_damage(damage)
    self.health = max(0,self.health-damage)
    return self.health
end

function player:heal(health)
    self.health = min(max_health,self.health+health)
    return self.health
end

function player:get_max_health()
    return self.max_health + self.bonuses.temp.health + self.bonuses.perm.health
end

function player:get_bonus_damage()
    return self.bonuses.temp.damage + self.bonuses.perm.damage
end

function player:get_temp_bonus_damage()
    return self.bonuses.temp.damage
end

function player:get_perm_bonus_damage()
    return self.bonuses.perm.damage
end

--[[
    attacks
]]

function player:roll()
    return rnd(100)
    + self.accuracy / 2
end

function player:light_all()
    
    -- hit all enemies
    local b = battle_manager.get_active()
    for i,en in ipairs(b.enemies) do
        -- attack one at a time with light delay
        wait(function()
            -- roll for hit
            if self:roll() > b:calculate_dc() then
                -- play hit fx
                fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
                sound_fx.hit()

                -- perform damage
                en:take_damage(self.damage.light.all + self:get_bonus_damage())
            -- missed
            else
                -- play missed fx
                sound_fx.player_miss()
                fx:new(en.x-4,en.y+8,1,1,{202},1,30):animate()        
            end
        end,(i-1)/5)
    end
end

function player:light_one(enemy)
    
    -- get selected enemy information
    local b = battle_manager.get_active()
    local en = b.enemies[enemy]

    -- roll for hit
    if self:roll() > b:calculate_dc() then
        -- play hit fx
        fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
        sound_fx.hit()

        -- perform damage
        en:take_damage(self.damage.light.x1 + self:get_bonus_damage())
    -- missed
    else
        -- play missed fx
        sound_fx.player_miss()
        fx:new(en.x-4,en.y+8,1,1,{202},1,30):animate()        
    end
end

function player:heavy_all()
    
    -- hit all enemies
    local b = battle_manager.get_active()
    for i,en in ipairs(b.enemies) do
        -- attack one at a time with light delay
        wait(function()
            -- roll for hit
            if self:roll() > b:calculate_dc() then
                -- play hit fx
                fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
                sound_fx.hit()

                -- perform damage
                en:take_damage(self.damage.heavy.all + self:get_bonus_damage())
            -- missed
            else
                -- play missed fx
                sound_fx.player_miss()
                fx:new(en.x-4,en.y+8,1,1,{202},1,30):animate()        
            end
        end,(i-1)/5)
    end
end

function player:heavy_one(enemy)
    
    -- get selected enemy information
    local b = battle_manager.get_active()
    local en = b.enemies[enemy]

    -- roll for hit
    if self:roll() > b:calculate_dc() then
        -- play hit fx
        fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
        sound_fx.hit()

        -- perform damage
        en:take_damage(self.damage.heavy.x1 + self:get_bonus_damage())
        -- missed
    else
        -- play missed fx
        sound_fx.player_miss()
        fx:new(en.x-4,en.y+8,1,1,{202},1,30):animate()        
    end
end