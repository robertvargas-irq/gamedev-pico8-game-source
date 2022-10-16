floor={
    rooms={},
    root={},
    tail={},
    max_rooms=0,
    r_count=0
}
floor.__index=floor

function floor:new(o)
    return setmetatable(o or {}, self)
end--floor:new()

function floor:generate()
    -- create new room as root
    local r=room.new(0,0,0)
    add(level.active.rooms,r)
    self.root=r
    self.max_rooms=max_rooms

    -- generate the remaining rooms
    generate_adjacent(self)
    
end--floor:generate()