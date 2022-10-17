-- level handler

level={}
level.active=nil
level.debug={}

-- set the current active level
-- level: {rooms:{}, root:{}, tail:{}, max_rooms:int, r_count:int}
function level.setactive(level)
    -- ensure level is properly defined
    assert(level~=nil, 'level.active cannot be nil')
    level.active=level
    return level
end--level.setactive()

-- debug the level by printing out each level as a pixel
-- color-coded to their hostility and start/end status.
--    hostile -> red
--       safe -> yellow
--      start -> green
--        end -> blue
function level.debug.printsprites()
    -- if no active level print debug message
    if level.active==nil then
        return print('no active level generated',-22,0,5)
    end

    -- print out each active room onto the screen
    for i in ipairs(level.active.rooms) do
        local room=level.active.rooms[i]
        local x=room.x
        local y=room.y

        -- hostile or not
        if room.hostile then
            pset(x,y,8) --red
        else
            pset(x,y,9) --yellow
        end

        -- start and end rooms
        if x==level.active.root.x
        and y==level.active.root.y then
            pset(x,y,11) --green
        elseif x==level.active.tail.x
        and y==level.active.tail.y then
            pset(x,y,12) --blue
        end
    end
end--printsprites()

-- generate a brand new level with the given max_rooms
function level.generate(max_rooms)

    -- reset level
    new_floor=floor:new({max_rooms=globals.max_rooms})
    new_floor:generate()
    level.active=new_floor

end