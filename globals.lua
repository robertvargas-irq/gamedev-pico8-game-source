globals={
    -- system
    fps=60,

    -- screen
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

dirs={
    {1,0},
    {-1,0},
    {0,1},
    {0,-1}
}

-- buttons
btn_left,btn_right,btn_up,btn_down,btn_z,btn_x=0,1,2,3,4,5

-- utility
left_spr,right_spr,up_spr,down_spr,blocking_spr,battle_spr=203,204,205,206,207,202