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

    -- for visuals
    facing_left=false,
    facing_right=false,
    facing_up=false,
    walking=false,
}
player.__index=player

function player:new(o)
    -- combat bonuses
    self.bonuses={
        temp={
            damage=15,
            health=0
        },
        perm={
            damage=10,
            health=150
        }
    }

    self.room={0,0}
    self.center={self.x+2,self.y+4}
    self.health = self:get_max_health()
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
    return self.bonuses.temp.damage + self.bonuses.perm.health
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

function player:light_all()
    -- TODO: implement roll for hit

    -- play sfx
    sound_fx.hit_quick()

    -- hit all enemies
    local b = battle_manager.get_active()
    for en in all(b.enemies) do
        en:take_damage(self.damage.light.all + self:get_bonus_damage())
        fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
    end
end

function player:light_one(enemy)
    -- TODO: implement roll for hit

    -- hit specified enemy
    local b = battle_manager.get_active()
    local en = b.enemies[enemy]
    en:take_damage(self.damage.light.x1 + self:get_bonus_damage())

    -- play fx
    fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
    sound_fx.hit_quick()
end

function player:heavy_all()
    -- TODO: implement roll for hit

    -- play sfx
    sound_fx.hit()

    -- hit all enemies
    local b = battle_manager.get_active()
    for en in all(b.enemies) do
        en:take_damage(self.damage.heavy.all + self:get_bonus_damage())
        fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
    end
end

function player:heavy_one(enemy)
    -- TODO: implement roll for hit

    -- hit specified enemy
    local b = battle_manager.get_active()
    local en = b.enemies[enemy]
    en:take_damage(self.damage.heavy.x1 + self:get_bonus_damage())

    -- play fx
    fx:new(en.x-8,en.y-8,2,2,{238},1,30):animate()
    sound_fx.hit()
end