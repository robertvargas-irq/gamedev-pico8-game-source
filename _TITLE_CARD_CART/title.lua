title={
    x0=56,
    x1=25,
    y=56,
    curr_x=56,
    frames_passed=0,
    frame=0,
    print_frame=0,
    print_seconds=3,
    frames={
        {
            192,
            0.1
        },
        {
            194,
            0.075
        },
        {
            196,
            0.1
        },
        {
            224,
            0.05
        },
        {
            226,
            0.05
        },
        {
            198,
            0.1
        },
        {
            228,
            1.5
        },
        {
            228,
            0
        }
    }
}

function title.play()
	screen=500
    title.curr_x=title.x0
    sfx(63)
end

function title._update()
    -- skip with any button
    if btn(btn_z) then
        main_menu.init()
    end
end

function title._draw()
    cls(13)

    local sprite,seconds=unpack(title.frames[title.frame+1])

    -- draw background box band
    rectfill(-1,44,128,84,9)
    rect(-1,44,128,84,0)
    rect(0,0,127,127,1)

    -- draw background circle
    circfill(title.curr_x+8,title.y+8,17,1)
    circfill(title.curr_x+8,title.y+8,16,0)
    line(title.curr_x,title.y+22,title.curr_x+16,title.y+22,7)
    line(title.curr_x,title.y-6,title.curr_x+16,title.y-6,7)
    circ(title.curr_x+8,title.y+8,16,11)

    -- draw current frame
    spr(sprite,title.curr_x,title.y,2,2)

    -- move to the next frame if needed
    title.frames_passed+=1
    if (title.frames_passed > seconds*fps and title.frame+1<#title.frames) then
        title.frames_passed=0
        title.frame+=1
    end

    -- begin moving the sprite to the left if needed
    if (title.frame+1>=#title.frames) then
        if (title.curr_x>title.x1) then
            title.curr_x -= 18/fps
        else
            print('em games',title.x0+2,title.y+7,0)
            print('em games',title.x0+2,title.y+6,12)
            -- move sprite to the left
            if title.print_frame > 188 + title.print_seconds*fps then
                print('init main menu',0,64,11)
                main_menu.init()
            end
            title.print_frame+=1
        end
    end

    -- draw skip
    print('press 🅾️ to skip',2,121,6)

    -- draw curtain
    if title.print_frame>=(title.print_seconds)*fps then
        local bottom=min(188,(title.print_frame-title.print_seconds*fps))
        for i=0,bottom,2 do
            line(0,i,128,i,0)
        end
        -- trailing curtain
        rectfill(0,bottom,128,bottom-3,0)
        rectfill(0,max(0,-50+bottom),128,max(0,-40+bottom),0)
        rectfill(0,max(0,-30+bottom),128,max(0,-20+bottom),0)
        rectfill(0,0,128,max(0,-60+bottom),0)

        -- extra inc for faster curtain
        title.print_frame+=1
    end
    
end