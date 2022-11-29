-- level handler

level={
    accent_colors={4,13,2}
}
level.active=nil

-- start a new level
function level.start(l)
    globals.current_level=l
    level.generate(globals.max_rooms+(globals.current_level-1)*5)
    player_manager.get():spawn(60,54)
    merchant_scene.init()
end

-- go to the next level
function level.next()
    level.start(min(globals.max_levels + 1,globals.current_level+1))
    player_manager.get():clear_temp_bonuses()
end

-- level accent color
function level.get_accent_color()
    return level.accent_colors[globals.current_level]
end

-- generate a brand new level with the given max_rooms
function level.generate(max_rooms)

    -- reset level
    local new_floor=floor:new({max_rooms=globals.max_rooms})
    new_floor:generate()
    level.active=new_floor

    battle_manager.clear()
    level.active:set_active_room(0,0)
    floor_enemies.switch_room(0,0)

end