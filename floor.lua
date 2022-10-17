floor={
    graph=nil,
    rooms=nil,
    root=nil,
    tail=nil,
    max_rooms=0,
    r_count=0
}
floor.__index=floor

function floor:new(o)
    self.graph={} -- x->y->room
    self.rooms={}
    self.root={}
    self.tail={}
    return setmetatable(o or {}, self)
end--floor:new()

function floor:generate()
    -- create new room as root
    local r=room.new(0,0,0)
    add(self.rooms,r)
    self.root=r

    -- generate the remaining rooms
    generate_adjacent(self,r)
    -- generate_from_root(self)

end--floor:generate()

function floor:add_room(r)
    -- if room already exists, do nothing
    if self:room_exists(r.x,r.y) then return end

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

function floor:room_exists(x,y)
    return self.graph[x]~=nil and self.graph[x][y]~=nil
end--floor:room_exists()

function floor:get_room(x,y)
    if self.graph[x]==nil then return nil end
    return self.graph[x][y]
end--floor:get_room()