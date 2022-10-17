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
    local self={
        hostile=__has_enemies(config.enemy_chance),
        enemy_count=0,
        x=x,
        y=y,
        diff=config.difficulty,
        left=nil,
        right=nil,
        up=nil,
        down=nil
    }
    -- if enemies, generate
    if self.hostile then
        self.enemy_count=__enemy_count(config.room_difficulty)
        -- ! TODO: GENERATE ENEMY TYPES
    end
    return self

end--room.new()

-- decide if a room has enemies
-- enemy_chance: chance of enemy spawn
-- returns: true if enemies are
--          present
function __has_enemies(enemy_chance)
	local roll=rnd(100)
	return roll < (enemy_chance)
end--_has_enemies()

-- calculate the number of enemies in the room
-- ! TODO: CALCULATE BASED ON DIFFICULTY
-- room_difficulty: room difficulty
-- returns: enemy count from 1-3 inclusive
function __enemy_count(room_difficulty)
    return max(1,min(3,
        flr(rnd(3))+1+flr(room_difficulty/100*3)
    ))
end--__enemy_count()

function enqueue_adjacent(floor,root,queue,alr_visited,dirs)
    
    -- track rooms generated to ensure that AT LEAST 1 room is generated
    -- the starting_dir is randomized from 1-4 inclusive in order to provide
    -- pseudo-randomness
    local rooms_generated=0
    local starting_dir=flr(rnd(4))+1

    -- enqueue surrounding dirs
    for i in ipairs(dirs) do
        -- only enqueue if rnd within increasing chance
        -- if i==grntd_dir or rnd(100) <= i*globals.uniformity then
        if rooms_generated==0 or rnd(100) <= rooms_generated*globals.uniformity then
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
	local dirs={
		{-1,0},
		{1,0},
		{0,-1},
		{0,1}
	}

    -- enqueue first room
    enqueue_adjacent(floor,root,queue,alr_visited,dirs)

	-- iterate through each possibility
	--print('beginning possibilities...',0,0)
    local r=1
	-- while not list.empty(queue) do
    while r ~= nil do
        
        -- ensure r is valid
		r=list.popright(queue)
        if r==nil then break end
		local x,y=unpack(r)

        -- generate room and enqueue adjacent sides
        if (_should_generate(floor,x,y)) then

            -- generate and add to rooms in active
            local new_r=room.new(x,y,{
                difficulty=globals.difficulty,
                room_difficulty=globals.room_difficulty,
                enemy_chance=globals.enemy_chance
            })
            floor:add_room(new_r)
            alr_visited[x..':'..y]=true
            
            enqueue_adjacent(floor,new_r,queue,alr_visited,dirs)

            -- if queue empty, set new room as "end" room and exit
            if queue[1]==nil then
                floor.tail=new_r
            end


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