player_manager={
    player=nil
}

function player_manager.create()
    player_manager.player=player:new({x=64,y=100,w=2,h=2,spr=8})
    return player_manager.player
end

function player_manager.get()
    assert(player_manager.player,'error: no player created in player_manager')
    return player_manager.player
end