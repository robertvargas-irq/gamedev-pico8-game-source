-- level handler

level={}
level.active={
    rooms={},
    root={},
    tail={},
    max_rooms=0,
    r_count=0
}
level.debug={}
function level.debug.printsprites()

    for i in ipairs(level.active.rooms) do
        local room=level.active.rooms[i]
        local x=room.x
        local y=room.y

        -- hostile or not
        if room.hostile then
            pset(x,y,8)
        else
            pset(x,y,9)
        end

        -- beginning and end
        if x==level.active.root.x
        and y==level.active.root.y then
            pset(x,y,11)
        elseif x==level.active.tail.x
        and y==level.active.tail.y then
            pset(x,y,12)
        end
    end
end--printsprites()

function level.generate(max_rooms)

    local r=room.new(0,0,0)
    add(level.active.rooms,r)
    level.active.root=r
    level.active.max_rooms=max_rooms

    -- generate the remaining rooms
    generate_adjacent(r)

end