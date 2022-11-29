-- visual effect
--[[
    handles any visual effects on screen
]]

fx={
    curr_frame=1,
    frame_buffer=0,
    cycles_made=0
}
fx.__index=fx

function fx:new(x,y,w,h,frames,frame_cycle,cycles,flip_x,flip_y)
    o={}
    o.x=x
    o.y=y
    o.w=w
    o.h=h
    o.flip_x=flip_x or false
    o.flip_y=flip_y or false
    o.frames=frames
    o.frame_cycle=frame_cycle
    o.cycles=cycles
    return setmetatable(o,self)
end

function fx:clone()
    return fx:new(self.x,self.y,self.w,self.h,self.frames,self.frame_cycle,self.cycles,self.flip_x,self.flip_y)
end

function fx:animate()
    fx_handler.add(self)
end

function fx:render()
    spr(self.frames[self.curr_frame],self.x,self.y,self.w,self.h,self.flip_x,self.flip_y)
end

function fx:_update()

    -- update current frame on the end of the frame cycle
    if self.frame_buffer>=self.frame_cycle then
        self.cycles_made+=1
        self.curr_frame+=1
    end
    self.frame_buffer+=1

    -- reset curent frame if over the length of frames
    if self.curr_frame > #self.frames then
        self.curr_frame=1
    end

end