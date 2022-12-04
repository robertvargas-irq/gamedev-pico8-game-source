globals={
    -- system
    fps=60,

    -- death
    deaths=0
}

function globals.get_difficulty()
    return __start_difficulty+(current_level-1)*15
end

function globals.get_enemy_chance()
    return __enemy_chance+(globals.get_difficulty())
end

dirs={
    {1,0},
    {-1,0},
    {0,1},
    {0,-1}
}

-- system
fps=60

-- buttons
btn_left,btn_right,btn_up,btn_down,btn_z,btn_x=0,1,2,3,4,5

-- utility
left_spr,right_spr,up_spr,down_spr,blocking_spr,battle_spr=203,204,205,206,207,202

-- level generation
current_level,max_levels,max_rooms,__start_difficulty,__enemy_chance,uniformity=1,3,29,30,20,9

-- screen
screen=0 -- 0: main_menu | 1: level | 2: battle | 3: merchant | 999: debug_levels
