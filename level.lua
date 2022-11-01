-- level handler

level={
    accent_colors={
        4,
        13,
        2
    }
}
level.active=nil
level.debug={}

-- start a new level
function level.start(l)
    globals.current_level = l
    level.generate(globals.max_rooms + (globals.current_level - 1) * 5)
    player_manager.get():spawn(60,54)
    level_play.init()
end

-- go to the next level
function level.next()
    level.start(min(globals.max_levels,globals.current_level + 1))
end

function level.get_accent_color()
    return level.accent_colors[globals.current_level]
end

-- debug the level by printing out each level as a pixel
-- color-coded to their hostility and start/end status.
--    hostile -> red
--       safe -> yellow
--      start -> green
--        end -> blue
function level.debug.printsprites()
    -- if no active level print debug message
    if level.active==nil then
        return print('no active level generated',-52,0,5)
    end

    -- print out each active room onto the screen
    for i in ipairs(level.active.rooms) do
        local room=level.active.rooms[i]
        local x=room.x
        local y=room.y

        -- hostile or not
        if room.hostile then
            color=8--red
            if room.enemy_count==2 then color=9 end
            if room.enemy_count==1 then color=10 end
            pset(x,y,color) --red
        else
            pset(x,y,5) --gray
        end

        -- start and end rooms
        if x==level.active.root.x
        and y==level.active.root.y then
            pset(x,y,11) --green
        elseif x==level.active.tail.x
        and y==level.active.tail.y then
            pset(x,y,0) --black
        end
    end
end--printsprites()

-- generate a brand new level with the given max_rooms
function level.generate(max_rooms)

    -- reset level
    local new_floor=floor:new({max_rooms=globals.max_rooms})
    new_floor:generate()
    level.active=new_floor

    level.active:set_active_room(0,0)
    floor_enemies.switch_room(0,0)

end