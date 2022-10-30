enemy={
    sprite=-1,
    x=64,
    y=64,
    w=1,
    h=1,
    max_health=100,
    health=100
}
enemy.__index=enemy

-- constructor
function enemy:new(o)
    return setmetatable(o or {}, self)
end

-- health manager
function enemy:take_damage(damage)
    self.health = max(0,self.health-damage)
    return self.health
end

function enemy:heal(health)
    self.health = min(max_health,self.health+health)
    return self.health
end

-- primary draw loop
function enemy:draw_health_bar()
    local bar_length = 10
    local bar_height = 5

    -- green bar
    line(
        self.x-bar_length/2,
        self.y-bar_height-4*self.h-7,
        self.x+bar_length/2-1,
        self.y-bar_height-4*self.h-7,
        11
    )

    -- red bar
    if self.health < self.max_health then
        line(
            self.x-bar_length/2+1+self.health/bar_length-1,
            self.y-bar_height-8*self.h,
            self.x+bar_length/2-1,
            self.y-bar_height-8*self.h,
            8
        )
    end

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