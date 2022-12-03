-- room handler

room={}

-- generate a new room
-- @param x: room x coordinate
-- @param y: room y coordinate
-- @param config: room configuration
-- @property config.difficulty
--        0: safe
--        n: difficulty scale
-- @property config.room_difficulty
--        0->100
-- @property config.enemy_chance
--        0->100
function room.new(x,y,config)
    local o={
        hostile=config.enemy_chance>0 and __has_enemies(config.enemy_chance),
        enemy_count=0,
        x=x,
        y=y,
        diff=config.room_difficulty or globals.get_difficulty(),
        visited=false,
        peeked=false
    }
    -- if enemies, generate
    if o.hostile then
        o.enemy_count=__enemy_count(o.diff)
        o.enemies={}

        -- arrange in upside-down U
        local start_x,start_y,neg,start_i,en_count=64,64,-1,2,o.enemy_count
        local is_even=en_count%2==0

        -- add the first enemy if not even
        if not is_even then
            add(o.enemies,enemy_factory.generate(start_x,start_y))
        end

        -- then add the rest
        if is_even then
            start_i=1
        end
        local inc=0
        for i=start_i,en_count,2 do
            
            -- get new pos
            local x,y=start_x,start_y

            -- scatter by 2
            for r=0,1 do
                if i+r<=en_count then
                    local curr=i+r
                    -- handle second row for > 5 enemies
                    if (is_even and curr%5==0)
                    or (not is_even and curr%6==0) then
                        start_y,inc+=129,3
                    end

                    -- add to the room's enemy list
                    x,y,neg=start_x+(i-inc)*10*neg, start_y+i*-10, -neg
                    add(o.enemies,enemy_factory.generate(x,y))
                end
            end--inner for
        end--parent for
    end -- if
    return o

end--room.new()

-- decide if a room has enemies
-- enemy_chance: chance of enemy spawn
-- returns: true if enemies are
--          present
function __has_enemies(enemy_chance)
    if enemy_chance==0 then return false end
	local roll=rnd(100)
	return roll < (enemy_chance)
end--_has_enemies()

-- calculate the number of enemies in the room
-- room_difficulty: room difficulty
-- returns: enemy count from 1-3 inclusive
function __enemy_count(room_difficulty)
    return max(1,min(7,
        flr(rnd(3))+1+flr(room_difficulty/100*2+current_level)
    ))
end--__enemy_count()

function enqueue_adjacent(floor,root,queue,alr_visited)
    
    -- track rooms generated to ensure that AT LEAST 1 room is generated
    -- the starting_dir is randomized from 1-4 inclusive in order to provide
    -- pseudo-randomness
    local rooms_generated=0
    local starting_dir=flr(rnd(4))+1

    -- enqueue surrounding dirs
    for i in ipairs(dirs) do
        -- only enqueue if rnd within increasing chance
        -- if i==grntd_dir or rnd(100)<=i*uniformity then
        if rooms_generated==0 or rnd(100)<=rooms_generated*uniformity then
            -- modify dir with starting_dir offset accounting for lua starting at index 1
            local dir=((starting_dir+i-1)%count(dirs))+1
            local dx,dy=unpack(dirs[dir])
            local nx=root.x+dx
            local ny=root.y+dy
            
            -- only enqueue if not already generated
            if alr_visited[nx..':'..ny]==nil then
                list.pushleft(queue, {
                    nx,
                    ny
                })

                -- inc rooms_generated
                rooms_generated+=1
            end
        end
    end
end--enqueue_adjacent()

function generate_adjacent(floor,root)
	
	local queue=list.new()
	local alr_visited={}
    alr_visited[root.x..':'..root.y]=true

    -- enqueue root's surrounding rooms
    enqueue_adjacent(floor,root,queue,alr_visited)

	-- iterate through each possibility
	--print('beginning possibilities...',0,0)
    local r=1
	-- while not list.empty(queue) do
    while r~=nil do
        
        -- ensure r is valid
		r=list.popright(queue)
        if r==nil then break end
		local x,y=unpack(r)

        -- generate room and enqueue adjacent sides
        if (_should_generate(floor,x,y)) then

            -- generate and add to rooms in active
            local new_r=room.new(x,y,{
                difficulty=globals.get_difficulty(),
                room_difficulty=globals.room_difficulty,
                enemy_chance=globals.get_enemy_chance()
            })
            floor:add_room(new_r)
            alr_visited[x..':'..y]=true
            
            enqueue_adjacent(floor,new_r,queue,alr_visited)
            
        end
	end
end--generate_adjacent()

-- see if room should be skipped
function _skip_room()
    local rand=rnd(100)
    return rand < 90
end--_skip_room()

-- fully generate room then enquque adjacents
function _should_generate(floor,x,y)

	-- check if max room count has exceeded
	if floor.r_count > floor.max_rooms then
        return false
    end

    return true

end--_should_generate()

function room.populate_decor(r)
    r.decor={}
    for x=8,112,8 do
        for y=8,112,8 do
            local tile=flr(rnd(95-60))+60
            if tile>82 then
                if r.decor[x]==nil then
                    r.decor[x]={}
                end
                r.decor[x][y]=tile
            end--skip
        end--y
    end--x
end--room.populate_decor()