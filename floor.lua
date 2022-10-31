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
    self.graph={} -- x->y->room
    self.rooms={}
    self.root={}
    self.tail={}
    self.active_room={0,0}
    return setmetatable(o or {}, self)
end--floor:new()

function floor:generate()
    -- create new room as root
    local r=room.new(0,0,{
        difficulty=0,
        room_difficulty=0,
        enemy_chance=0
    })
    add(self.rooms,r)
    self.root=r

    -- generate the remaining rooms
    generate_adjacent(self,r)

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
    local rx,ry=unpack(self.active_room)
    return self:get_room(rx,ry)
end--floor:get_active_room()

function floor:get_root()
    return self:get_room(0,0)
end--floor:get_root()

function floor:get_tail()
    return self:get_room(self.tail.x,self.tail.y)
end--floor:get_tail()

function floor:is_tail(x,y)
    local t = self:get_tail()
    return t.x == x and t.y == y
end

function floor:set_active_room(x,y)
    self.active_room={x,y}
end