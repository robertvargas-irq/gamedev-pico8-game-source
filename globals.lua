globals={
    -- system
    fps=60,

    -- buttons
    btn_left=0,
    btn_right=1,
    btn_up=2,
    btn_down=3,
    btn_z=4,
    btn_x=5,
    screen=0, -- 0: main_menu | 1: level | 2: battle | 3: merchant | 999: debug_levels

    -- utility
    left_spr=203,
    right_spr=204,
    up_spr=205,
    down_spr=206,
    blocking_spr=207,
    battle_spr=202,

    -- level generation
    current_level=1,
    max_levels=3,
    max_rooms=9,
    __start_difficulty=30,
    __enemy_chance=20,
    uniformity=20,

    -- death
    deaths=0
}

function globals.get_difficulty()
    return globals.__start_difficulty+(globals.current_level-1)*5
end

function globals.get_enemy_chance()
    return globals.__enemy_chance+(globals.get_difficulty())
end