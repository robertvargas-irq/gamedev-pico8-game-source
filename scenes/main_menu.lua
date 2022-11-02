main_menu={
    selection=1,
    selections={
        'new run',
        'level sandbox'
    },
    death_msgs={
        'wish to go again?',
        'skill issue',
        'l'
    }
}

-- primary update function
function main_menu._update()
    --[[
        menu option controls
    ]]

    if btnp(globals.btn_up) then
        sound_fx.select()
        main_menu.selection=max(1,(main_menu.selection-1)%(count(main_menu.selections)+1)) end
    if btnp(globals.btn_down) then
        sound_fx.select()
        main_menu.selection=max(1,(main_menu.selection+1)%(count(main_menu.selections)+1)) end

    --[[
        select option
    ]]
    if btnp(globals.btn_right) or btnp(globals.btn_z) then
        sound_fx.ready()
        -- swap screen
        if main_menu.selection==1 then
            level.restart(1)
        end
        if main_menu.selection==2 then
            globals.screen=999
        end
    end--select

end--main_menu._update()


-- for blinking cursor
local blinker=0
local blinker_time=40

-- primary rendering function
function main_menu._draw()
    cls(0)
    camera(0,0)

    -- print title
    local msg='mAIN mENU'
    print(msg,2,2,9)
    line(2,10,2+(#msg*3),10)

    local offset=15
    for sel in all(main_menu.selections) do
        local current=sel==main_menu.selections[main_menu.selection]
        local color=7
        if current then
            -- set color to green and activate blinker
            color=11

            -- new run
            if main_menu.selection==1 then
                msg = 'let\'s begin.'
                if globals.deaths > 0 then
                    msg = main_menu.death_msgs[min(#main_menu.death_msgs,globals.deaths)]
                    -- msg='u died lel'
                end
                print('- '..msg,47,5+offset,13)
            end
            if blinker < blinker_time/2 then
                print(' 🅾️',2,5+offset,11)
            end
            blinker = (blinker+1)%blinker_time
        end

        print(sel,15,5+offset,color)
        offset+=8
    end--for
end--main_menu._draw()