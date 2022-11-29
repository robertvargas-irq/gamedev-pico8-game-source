-- [scene] level_play
-- Handles the actual movement inside the map.

level_play={
    player=nil,

}
local spr_off=32
local backgrounds={3,13}
local function update_sprite_offset()
    spr_off=(current_level-1)*32
end

function level_play.init()
    screen=1
    update_sprite_offset()
    music_room()
end--level_play.init()

-- primary update function
function level_play._update()
    local moving=false
    local vel=1
    local p=player_manager.get()
    if ((btn(btn_up) or btn(btn_down))
    and (btn(btn_left) or btn(btn_right)))
    then
        vel=0.60
    end
    if btn(btn_up) then
        moving=true
        p:move(0,-vel)
    elseif btn(btn_down) then
        moving=true
        p:move(0,vel)
    end
    if btn(btn_left) then
        moving=true
        p:move(-vel,0)
    elseif btn(btn_right) then
        moving=true
        p:move(vel,0)
    end
    if not moving then
        p:move(0,0)
    end
    
    -- if player is standing on a movement sprite, swap screen
    local px=p.x+2*p.w
    local py=p.y+4*p.h
    local tile=mget(px/8,py/8)
    if fget(tile,1) then
        
        -- left
        if fget(tile,2) then
            p.x+=100
            level.active:shift_active_room(-1,0) end
        -- right
        if fget(tile,3) then
            p.x-=100
            level.active:shift_active_room(1,0) end
        -- up
        if fget(tile,4) then
            p.y+=100
            level.active:shift_active_room(0,-1) end
        -- down
        if fget(tile,5) then
            p.y-=100
            level.active:shift_active_room(0,1) end
        
        reload(0x1000, 0x1000, 0x2000)
    end

    -- if player moved into a battle block, initiate battle
    local in_battle_block=fget(tile,6)
    if in_battle_block then
        local r=level.active:get_active_room()
        -- if tail, then finish the floor
        if level.active:is_tail(r.x,r.y) then
            level.next()
            return
        -- not tail, begin battle
        else
            battle_manager.get(r.x,r.y):start()
        end
    end

end--level_player._update()

-- primary rendering function
function level_play._draw()
    -- get room
    local r=level.active:get_active_room()
    cls(backgrounds[current_level])
    
    camera(0,0)
    local r=level.active:get_active_room()
    level_play.render_room(r.x,r.y)
    level_play.render_decor(r.x,r.y)
    floor_enemies.set_battle_tiles()
    map(0,0,0,0,16,16,1)

    -- draw spawn fountain or tail merchant
    level_play.render_fountain(r.x,r.y)
    level_play.render_merchant(r.x,r.y)

    -- render hostiles in the room
    floor_enemies._draw()

    -- render player on top
    player_manager.get():render()

    -- render ui
    minimap._draw()

end--level_player._draw()

local spawn_fountain={69,70}
local tail_merchant=0
local mid=56
local p_wall_1=48
local p_wall_2=72
local tp_x=68
local tp_y=67
local wall_x=65
local wall_y=66
local corner_x=81
local corner_y=82
local l_dirs={
--   dx dy   x1  y1     x2    y2  sprite
    {-1, 0,   0,mid,     0,mid+8, left_spr }, -- left
    { 1, 0, 120,mid,   120,mid+8, right_spr}, -- right
    { 0,-1, mid,  0, mid+8,    0, up_spr   }, -- up
    { 0, 1, mid,120, mid+8,  120, down_spr }  -- down
}
function level_play.render_room(x,y)
    -- render corners from TOP ROW -> BOTTOM ROW
    spr(spr_off+64,0,0,1,1,false,false)
    spr(spr_off+64,120,0,1,1,true,false)
    spr(spr_off+64,0,120,1,1,false,true)
    spr(spr_off+64,120,120,1,1,true,true)
    -- set map collision
    mset(0,0,blocking_spr)
    mset(120/8,0,blocking_spr)
    mset(0,120/8,blocking_spr)
    mset(120/8,120/8,blocking_spr)

    -- render walls
    for i=8,112,8 do
        -- render walls solidly if not at the half-way point
        if i<mid-8 or i>mid+16 then
            -- top and bottom rows
            spr(spr_off+wall_x,i,0,1,1,false,false)
            spr(spr_off+wall_x,i,120,1,1,false,true)
            
            -- left and right columns
            spr(spr_off+wall_y,0,i,1,1,false,false)
            spr(spr_off+wall_y,120,i,1,1,true,false)

        -- half-way point; check if pathways are available
        elseif i==mid-8 then

            -- check each direction for an adjacent room
            for dir in all(l_dirs) do
                -- if there is NOT a room adjacent, spawn wall sprites
                local dx,dy,i_x1,i_y1,i_x2,i_y2,sprite=unpack(dir)
                if level.active:get_room(x+dx,y+dy)==nil then
                    -- use wall sprite as blocker
                    if dx==1 then
                        -- edges
                        spr(spr_off+wall_y,i_x1,i_y1-8,1,1,true)
                        spr(spr_off+wall_y,i_x2,i_y2+8,1,1,true)

                        -- middle
                        spr(spr_off+wall_y,i_x1,i_y1,1,1,true)
                        spr(spr_off+wall_y,i_x2,i_y2,1,1,true)
                    elseif dx==-1 then
                        -- edges
                        spr(spr_off+wall_y,i_x1,i_y1-8,1,1)
                        spr(spr_off+wall_y,i_x2,i_y2+8,1,1)

                        -- middle
                        spr(spr_off+wall_y,i_x1,i_y1,1,1)
                        spr(spr_off+wall_y,i_x2,i_y2,1,1)
                    elseif dy==1 then
                        -- edges
                        spr(spr_off+wall_x,i_x1-8,i_y1,1,1,false,true)
                        spr(spr_off+wall_x,i_x2+8,i_y2,1,1,false,true)

                        -- middle
                        spr(spr_off+wall_x,i_x1,i_y1,1,1,false,true)
                        spr(spr_off+wall_x,i_x2,i_y2,1,1,false,true)
                    else --dy==-1
                        -- edges
                        spr(spr_off+wall_x,i_x1-8,i_y1,1,1)
                        spr(spr_off+wall_x,i_x2+8,i_y2,1,1)

                        -- middle
                        spr(spr_off+wall_x,i_x1,i_y1,1,1)
                        spr(spr_off+wall_x,i_x2,i_y2,1,1)
                    end
                    -- set map collision
                    mset(i_x1/8,i_y1/8,blocking_spr)
                    mset(i_x2/8,i_y2/8,blocking_spr)
                -- there is a room adjacent, spawn tele-pads
                else
                    if dx==1 then
                        -- edges
                        spr(spr_off+corner_y,i_x1,i_y1-8,1,1,true,true)
                        spr(spr_off+corner_y,i_x2,i_y2+8,1,1,true)

                        -- middle
                        spr(spr_off+tp_x,i_x1,i_y1,1,1,true)
                        spr(spr_off+tp_x,i_x2,i_y2,1,1,true)
                        
                    elseif dx==-1 then
                        -- edges
                        spr(spr_off+corner_y,i_x1,i_y1-8,1,1,false,true)
                        spr(spr_off+corner_y,i_x2,i_y2+8,1,1)
                        
                        -- middle
                        spr(spr_off+tp_x,i_x1,i_y1,1,1)
                        spr(spr_off+tp_x,i_x2,i_y2,1,1)
                        
                    elseif dy==1 then
                        -- edges
                        spr(spr_off+corner_x,i_x1-8,i_y1,1,1,false,true)
                        spr(spr_off+corner_x,i_x2+8,i_y2,1,1,true,true)

                        -- middle
                        spr(spr_off+tp_y,i_x1,i_y1,1,1)
                        spr(spr_off+tp_y,i_x2,i_y2,1,1)
                    else --dy==-1
                        -- edges
                        spr(spr_off+corner_x,i_x1-8,i_y1,1,1)
                        spr(spr_off+corner_x,i_x2+8,i_y2,1,1,true)

                        -- middle
                        spr(spr_off+tp_y,i_x1,i_y1,1,1,false,true)
                        spr(spr_off+tp_y,i_x2,i_y2,1,1,false,true)
                    end
                    mset(i_x1/8,i_y1/8,sprite)
                    mset(i_x2/8,i_y2/8,sprite)
                end--if
            end--for
        end--if
    end--for
    
end--level_play.render_room()

local ftn_cycle=0
local ftn_frame=0
local ftn_frame_switch=30
function level_play.render_fountain(x,y)

    -- if not the root don't render
    if x~=0 or y~=0 then return end

    -- render spawn fountain
    spr(spawn_fountain[ftn_frame+1],60,60)
    ftn_cycle+=1
    if ftn_cycle >= ftn_frame_switch then
        ftn_frame=(ftn_frame+1) % #spawn_fountain
        ftn_cycle=0
    end
end

function level_play.render_merchant(x,y)
    -- if not the tail, don't render
    if not level.active:is_tail(x,y) then return end

    -- render merchant shop
    spr(0,56,56,2,2)

    -- render bounding box
    for x=56,64,4 do
        for y=56,64,4 do
            mset(x/8,y/8,battle_spr)
        end
    end
end

-- render any decorations in the room itself
function level_play.render_decor(x,y)
    local r=level.active:get_room(x,y)
    if not r then return end

    -- populate the room with decor if none is present
    if r.decor==nil then
        room.populate_decor(r)
    end
    for x=8,112,8 do
        for y=8,112,8 do
            local tile=r.decor[x]
            if tile then
                tile=tile[y]
            end
            if tile then
                srand(time())
                local flip=flr(rnd(1))+1==1
                spr(spr_off+tile,x,y,1,1,flip,false)
            end
        end--y
    end--x
end--level_play.render_decor()