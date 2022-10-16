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

function debug_levels._update()

    -- menu option controls
    if btnp(globals.btn_up) then
        debug_levels.selection=max(1,(debug_levels.selection+1)%(count(debug_levels.selections)+1)) end
    if btnp(globals.btn_down) then
        debug_levels.selection=max(1,(debug_levels.selection)%(count(debug_levels.selections)+1)) end
    
    -- menu option modifiers
    if btnp(globals.btn_left) then
        globals[debug_levels.selections[debug_levels.selection]]-=1 end
    if btnp(globals.btn_right) then
        globals[debug_levels.selections[debug_levels.selection]]+=1 end
    
    -- swap between config and render
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

function debug_levels._draw()

    -- if not configuring, the program will render
    if not configuring then
        cls(2)
    	camera(-30,-30)
        level.debug.printsprites()
        print('press z to regenerate room',-28,128-37)
        return
    end--not configuring

    -- display configuration menu
    cls(4)
    camera(0,0)
    local offset=0
    for sel in all(debug_levels.selections) do
        if sel==debug_levels.selections[debug_levels.selection] then
            print('--> ',0,5+offset)
        end

        print(sel,10,5+offset)
        offset+=8
    end--for
end--debug_levels._draw()