-- player class

player={
    spr=16,
    x=0,
    y=0,
    center=nil,
    room=nil,
    active=false,
    movement_boost=1
}
player.__index=player

function player:new(o)
    self.room={0,0}
    self.center={self.x+2,self.y+4}
    return setmetatable(o or {}, self)
end--player:new()

function player:spawn(x,y)
    self.active=true
    self.x=x
    self.y=y
end--player:spawn()

function player:render()
    return spr(self.spr,self.x-2,self.y-4,1,1)
end--player:spawn()

function player:move(dx,dy)
    -- local tile=mget(dx,dy)
    local tile_solid=fget(mget((self.x+dx)/8,(self.y+dy)/8),7)
    if not tile_solid then
        self.x+=dx*self.movement_boost
        self.y+=dy*self.movement_boost
        self.center={self.x+2,self.y+4}
    end
end--player:move()