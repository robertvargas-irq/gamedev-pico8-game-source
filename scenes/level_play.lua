-- [scene] level_play
-- Handles the actual movement inside the map.

level_play={
    player=nil
}

function level_play.init()
    player_manager.player:spawn(64,64)
    globals.screen=1
end--level_play.init()

-- primary update function
function level_play._update()
    if btn(globals.btn_up) then
        player_manager.player:move(0,-1)
    elseif btn(globals.btn_down) then
        player_manager.player:move(0,1)
    elseif btn(globals.btn_left) then
        player_manager.player:move(-1,0)
    elseif btn(globals.btn_right) then
        player_manager.player:move(1,0)
    else
        player_manager.player:move(0,0)
    end
    
    -- if player is standing on a movement sprite, swap screen
    local px=player_manager.player.x+2*player_manager.player.w
    local py=player_manager.player.y+4*player_manager.player.h
    local tile=mget(px/8,py/8)
    if fget(tile,1) then
        
        -- left
        if fget(tile,2) then
            player_manager.player.x+=100
            level.active.active_room[1]-=1 end
        -- right
        if fget(tile,3) then
            player_manager.player.x-=100
            level.active.active_room[1]+=1 end
        -- up
        if fget(tile,4) then
            player_manager.player.y+=100
            level.active.active_room[2]-=1 end
        -- down
        if fget(tile,5) then
            player_manager.player.y-=100
            level.active.active_room[2]+=1 end
        
        reload(0x1000, 0x1000, 0x2000)
    end

    -- if player moved into a battle block, initiate battle
    local in_battle_block=fget(tile,6)
    if in_battle_block then
        local r = level.active:get_active_room()
        battle_manager.get(r.x,r.y):start()
    end

end--level_player._update()

-- primary rendering function
function level_play._draw()
    -- get room
    local r = level.active:get_active_room()
    -- regenerate room if not properly generated
    if not r then return level.generate() end
    cls(3)
    
    camera(0,0)
    local rx,ry=unpack(level.active.active_room)
    level_play.render_room(rx,ry)
    level_play.render_decor(rx,ry)
    floor_enemies.set_battle_tiles()
    map(0,0,0,0,16,16,1)
    -- print('standing on:     '..mget(player_manager.player.x/8,player_manager.player.y/8),10,10)
    -- print('current room:    '..level.active.active_room[1]..','..level.active.active_room[2])
    -- print('hostiles present:'..#(level.active:get_active_room().enemies or {}))

    -- render hostiles in the room
    floor_enemies._draw()

    -- finally, render player on top
    player_manager.player:render()

end--level_player._draw()

local mid=56
local p_wall_1=48
local p_wall_2=72
function level_play.render_room(x,y)
    -- render corners from TOP ROW -> BOTTOM ROW
    spr(64,0,0,1,1,false,false)
    spr(64,120,0,1,1,true,false)
    spr(64,0,120,1,1,false,true)
    spr(64,120,120,1,1,true,true)
    -- set map collision
    mset(0,0,globals.blocking_spr)
    mset(120/8,0,globals.blocking_spr)
    mset(0,120/8,globals.blocking_spr)
    mset(120/8,120/8,globals.blocking_spr)

    -- render walls
    for i=8,112,8 do
        -- render path walls
        if i==p_wall_1 then
            -- left and right upper
            spr(82,0,p_wall_1,1,1,false,true)
            spr(82,120,p_wall_1,1,1,true,true)
            -- set map collision
            mset(0,p_wall_1/8,globals.blocking_spr)
            mset(120/8,p_wall_1/8,globals.blocking_spr)

            -- top and bottom left-most
            spr(81,p_wall_1,0,1,1,false,false)
            spr(81,p_wall_1,120,1,1,false,true)
            -- set map collision
            mset(p_wall_1/8,0,globals.blocking_spr)
            mset(p_wall_1/8,120/8,globals.blocking_spr)
        -- render adjacent path walls
        elseif i==p_wall_2 then
            -- left and right lower
            spr(82,0,p_wall_2,1,1,false,false)
            spr(82,120,p_wall_2,1,1,true,false)
            -- set map collision
            mset(0,p_wall_2/8,globals.blocking_spr)
            mset(120/8,p_wall_2/8,globals.blocking_spr)

            -- top and bottom right-most
            spr(81,p_wall_2,0,1,1,true,false)
            spr(81,p_wall_2,120,1,1,true,true)
            -- set map collision
            mset(p_wall_2/8,0,globals.blocking_spr)
            mset(p_wall_2/8,120/8,globals.blocking_spr)
        -- render walls solidly if not at the half-way point
        elseif i~=mid and i~=mid+8 then
            -- top and bottom rows
            spr(65,i,0,1,1,false,false)
            spr(65,i,120,1,1,false,true)
            -- set map collision
            mset(i/8,0,globals.blocking_spr)
            mset(i/8,120/8,globals.blocking_spr)

            -- left and right columns
            spr(66,0,i,1,1,false,false)
            spr(66,120,i,1,1,true,false)
            -- set map collision
            mset(0,i/8,globals.blocking_spr)
            mset(120/8,i/8,globals.blocking_spr)
        -- half-way point; check if pathways are available
        else
            local dirs={
            --   dx dy   x1  y1     x2    y2  sprite
                {-1, 0,   0,mid,     0,mid+8, globals.left_spr }, -- left
                { 1, 0, 120,mid,   120,mid+8, globals.right_spr}, -- right
                { 0,-1, mid,  0, mid+8,    0, globals.up_spr   }, -- up
                { 0, 1, mid,120, mid+8,  120, globals.down_spr } -- down
            }
            -- check each direction for an adjacent room
            for dir in all(dirs) do
                -- if there is NOT a room adjacent, spawn rock sprites
                local dx,dy,i_x1,i_y1,i_x2,i_y2,sprite=unpack(dir)
                if level.active:get_room(x+dx,y+dy)==nil then
                    spr(2,i_x1,i_y1,1,1)
                    spr(2,i_x2,i_y2,1,1)
                    -- set map collision
                    mset(i_x1/8,i_y1/8,globals.blocking_spr)
                    mset(i_x2/8,i_y2/8,globals.blocking_spr)
                -- room adjacent, spawn tele-pads
                else
                    spr(67,i_x1,i_y1,1,1)
                    spr(67,i_x2,i_y2,1,1)
                    mset(i_x1/8,i_y1/8,sprite)
                    mset(i_x2/8,i_y2/8,sprite)
                end--if
            end--for
        end--if
    end--for
    
end--level_play.render_room()

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
                tile = tile[y]
            end
            if tile then
                srand(time())
                local flip=flr(rnd(1))+1==1
                spr(tile,x,y,1,1,flip,false)
            end
        end--y
    end--x
end--level_play.render_decor()