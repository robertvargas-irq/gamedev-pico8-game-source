-- room handler

room={}

-- generate a new room
-- @param x: room x coordinate
-- @param y: room y coordinate
-- @param diff: room difficulty
--        0: safe
--        n: difficulty scale
function room.new(x,y,diff)
    local self={
        hostile=__has_enemies(diff),
        x=x,
        y=y,
        diff=diff,
        left=nil,
        right=nil,
        up=nil,
        down=nil
    }
    level.active.r_count=level.active.r_count+1
    return self

end--room.new()

-- decide if a room has enemies
-- diff: enemy difficulty
-- returns: true if enemies are
--          present
function __has_enemies(diff)
	local roll=rnd(100)
	return roll < (diff)
end--_has_enemies()

function enqueue_adjacent(root,queue,alr_visited,dirs)
    
    -- ensure at least one direction is generated
    -- ! ITERATE ON IMPLEMENTATION : Not always guaranteed; need incoming direction.
    -- ! IDEA : Check global (x,y) for an adjacent room then reconsider not enqueuing.
    local grntd_dir=flr(rnd(4)+1)

    -- enqueue surrounding dirs
    for i in ipairs(dirs) do
        -- only enqueue if rnd within increasing chance
        if i==grntd_dir or rnd(100) <= i*globals.uniformity then
            local dx,dy=unpack(dirs[i])
            local nx=root.x+dx
            local ny=root.y+dy
            
            -- only enqueue if not already generated
            if alr_visited[nx..':'..ny]==nil then
                list.pushleft(queue, {
                    nx,
                    ny
                })
            end
        end
    end
end--enqueue_adjacent()

function generate_adjacent(root)
	
	local queue=list.new()
	local alr_visited={}
	local dirs={
		{-1,0},
		{1,0},
		{0,-1},
		{0,1}
	}

    -- enqueue first room
    enqueue_adjacent(root,queue,alr_visited,dirs)

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
        if (_should_generate(x,y)) then

            -- generate and add to rooms in active
            local new_r=room.new(x,y,globals.difficulty)
            add(level.active.rooms,new_r)
            alr_visited[x..':'..y]=true
            
            enqueue_adjacent(new_r,queue,alr_visited,dirs)

            -- if queue empty, set new room as "end" room and exit
            if queue[1]==nil then
                level.active.tail=new_r
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
function _should_generate(x,y)

	local act=level.active

	-- check if max room count has exceeded
	if act.r_count > act.max_rooms then
        return false
    end

    return true

end--_should_generate()