floor={
    graph=nil,
    rooms=nil,
    root=nil,
    tail=nil,
    max_rooms=0,
    r_count=0,
    active_room=nil
}
floor.__index=floor

function floor:new(o)
    if not o then o={} end
    o.graph={} -- x->y->room
    o.rooms={}
    o.root={}
    o.tail={}
    o.active_room={0,0}
    return setmetatable(o or {}, self)
end--floor:new()

function floor:generate()
    -- create new room as root
    local r=room.new(0,0,{
        room_difficulty=0,
        enemy_chance=0
    })
    add(self.rooms,r)
    self:add_room(r)
    self.root=r

    -- generate the remaining rooms
    generate_adjacent(self,r)

    -- make final floor tail
    self.tail=self.rooms[#self.rooms]
    
    -- remove enemies from root and tail
    self.tail.enemies=nil
    self.tail.__enemy_count=0
    self.tail.__has_enemies=false    

end--floor:generate()

function floor:add_room(r)
    -- add to list of rooms and inc count
    add(self.rooms,r)
    self.r_count+=1

    -- if x value does not exist,
    -- create new table to support y
    if self.graph[r.x]==nil then
        self.graph[r.x]={}
    end
    
    -- map to the correct graph
    self.graph[r.x][r.y]=r

end--floor:addroom(r)

function floor:get_room(x,y)
    if self.graph[x]==nil then return nil end
    return self.graph[x][y]
end--floor:get_room()

function floor:get_active_room()
    local rx=self.active_room[1]
    local ry=self.active_room[2]
    return self:get_room(rx,ry)
end--floor:get_active_room()

function floor:get_root()
    return self:get_room(0,0)
end--floor:get_root()

function floor:get_tail()
    if not self.tail then return nil end
    return self:get_room(self.tail.x,self.tail.y)
end--floor:get_tail()

function floor:is_tail(x,y)
    local t=self:get_tail()
    if not t then return false end
    return t.x==x and t.y==y
end

function floor:set_active_room(x,y)
    self.active_room[1],self.active_room[2]=x,y
    self:get_room(x,y).visited=true
    for dir in all(dirs) do
        local r=self:get_room(x+dir[1],y+dir[2])
        if r then
            r.peeked=true
        end 
    end
end

function floor:shift_active_room(dx,dy)
    local nx=self.active_room[1]+dx
    local ny=self.active_room[2]+dy
    self:set_active_room(nx,ny)
    if self:is_tail(nx,ny) then
        sound_fx.merchant_reached()
    end
end