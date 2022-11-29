minimap={
    x0=2,
    x1=22,
    y0=105,
    y1=125
}

function minimap._update()

end

local blink_frame=0
local blink_cycles=45
local blink_on=false
function minimap._draw()

    -- draw box and decorative sprite
    rectfill(minimap.x0,minimap.y0,minimap.x1,minimap.y1,0)
    rect(minimap.x0-1,minimap.y0-1,minimap.x1+1,minimap.y1+1,7)
    spr(222,minimap.x0-2,minimap.y1-5)

    local start_r=level.active:get_active_room()
    local diam_x=minimap.x1-minimap.x0
    local diam_y=minimap.y1-minimap.y0

    -- radius
    local rad_x=flr(diam_x/2)
    local rad_y=flr(diam_y/2)
    
    -- if no active level print debug message
    assert(level.active~=nil,'no active level generated')
    
    -- start from top left of the minimap and print in blocks of 3
    local f=level.active
    for dx=-rad_x/2+2,rad_x/2-2 do
        for dy=-rad_y/2+2,rad_y/2-2 do
            local possible_r=f:get_room(start_r.x+dx,start_r.y+dy)
            if possible_r~=nil then
                if possible_r.visited then
                    local clr=7 -- white
                    if (possible_r.x+possible_r.y)%2==0 then
                        clr=6 -- gray
                    end

                    -- if start room
                    if possible_r.x==0 and possible_r.y==0 then
                        clr=12 -- cyan
                    end

                    -- if tail room
                    if f:is_tail(possible_r.x,possible_r.y) then
                        clr=10 -- yellow
                    end

                    -- if room is hostile
                    if possible_r.enemies and #possible_r.enemies > 0 then
                        clr=8 -- hostile
                    end

                    -- if currently in the room
                    if dx==0 and dy==0 then

                        -- apply whether in blink or not
                        if blink_on then
                            clr=5 -- dark gray
                        else
                            clr=11 -- green
                        end

                        -- advance blinking effect
                        blink_frame+=1
                        if blink_frame>=blink_cycles then
                            blink_frame=0
                            blink_on=not blink_on
                        end
                    end

                    -- set minimap square
                    rectfill(
                        minimap.x0+rad_x+dx*3-1,
                        minimap.y0+rad_y+dy*3-1,
                        minimap.x0+rad_x+dx*3+1,
                        minimap.y0+rad_y+dy*3+1,
                        clr
                    )
                    rect(
                        minimap.x0+rad_x+dx*3-1,
                        minimap.y0+rad_y+dy*3-1,
                        minimap.x0+rad_x+dx*3+1,
                        minimap.y0+rad_y+dy*3+1,
                        level.get_accent_color()
                    )
                -- if room was seen in a room that was visited
                elseif possible_r.peeked then
                    -- set minimap square
                    rectfill(
                        minimap.x0+rad_x+dx*3-1,
                        minimap.y0+rad_y+dy*3-1,
                        minimap.x0+rad_x+dx*3+1,
                        minimap.y0+rad_y+dy*3+1,
                        5
                    )
                end--end visited or peeked
            end--end valid room if
        end--end dy for
    end--end dx for

    -- print outline for current room
    rect(
        minimap.x0+rad_x-1,
        minimap.y0+rad_y-1,
        minimap.x0+rad_x+1,
        minimap.y0+rad_y+1,
        3
    )

end