-- [scene] debug_levels
debug_levels={
    configuring=true,
    selection=1,
    selections={
        'max_rooms',
        'difficulty',
        'uniformity'
    },
    generation_lock=false
}

-- primary update function
function debug_levels._update()

    --[[
        menu option controls
    ]]

    if btnp(globals.btn_up) then
        debug_levels.selection=max(1,(debug_levels.selection-1)%(count(debug_levels.selections)+1)) end
    if btnp(globals.btn_down) then
        debug_levels.selection=max(1,(debug_levels.selection+1)%(count(debug_levels.selections)+1)) end
    
    --[[
        menu option modifiers
    ]]

    -- increment count (shift as a modifier)
    local inc=1
    if btn(globals.btn_z,1) then inc=5 end
    if btn(globals.btn_right,1) then inc=10 end

    -- decrement current option
    if btnp(globals.btn_left) then
        globals[debug_levels.selections[debug_levels.selection]]-=inc end
    if btnp(globals.btn_right) then
        globals[debug_levels.selections[debug_levels.selection]]+=inc end
    
    --[[
        menu swap and regeneration
    ]]

    -- swap menus
    if btnp(globals.btn_x) then
        configuring=not configuring
    end

    -- regenerate room
    if btnp(globals.btn_z) then
        if not debug_levels.generation_lock then
            debug_levels.generation_lock=true
            level.generate(globals.max_rooms)
            debug_levels.generation_lock=false
        end
    end

end--debug_levels._update()

-- for blinking cursor
local blinker=0
local blinker_time=20

-- primary rendering function
function debug_levels._draw()

    -- if not configuring, the program will render
    if not configuring then
        cls(2)
    	camera(-30,-30)
        level.debug.printsprites()
        print('press x to go to debug menu',-28,128-47,7)
        print('press z to regenerate room',-28,128-37,7)
        return
    end--not configuring

    -- display configuration menu
    cls(12)
    camera(0,0)

    -- print title
    local msg='level debug menu'
    print(msg,2,2,9)
    line(2,10,2+(#msg*3),10)

    local offset=15
    for sel in all(debug_levels.selections) do
        local current=sel==debug_levels.selections[debug_levels.selection]
        local color=7
        if current then
            -- set color to green and activate blinker
            color=11
            if blinker < blinker_time/2 then
                print('--> ',2,5+offset,10)
            end
            blinker = (blinker+1)%blinker_time
        end
        
        print(sel..'\t=\t'..globals[sel],15,5+offset,color)
        offset+=8
    end--for

    -- print footer
    print('hold shift to increment +/- 5',2,128-37,7)
    print('hold f to increment +/- 10',2,128-27,7)
    print('press x to change to room view',2,128-17,1)
    print('press z to regenerate room',2,128-7,1)

end--debug_levels._draw()