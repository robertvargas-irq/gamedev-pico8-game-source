floor={
    rooms=nil,
    root=nil,
    tail=nil,
    max_rooms=0,
    r_count=0
}
floor.__index=floor

function floor:new(o)
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