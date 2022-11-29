player_manager={}
local p
function player_manager.create()
    p=player:new({x=64,y=100,w=2,h=2,spr=8})
    return p
end

function player_manager.get()
    return p
end