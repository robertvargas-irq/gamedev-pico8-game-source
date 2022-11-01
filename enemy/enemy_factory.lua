enemy_factory={
    minimum_health=50
}

function enemy_factory.generate(x,y)
    return enemy:new(x,y,{
        w=2,
        h=2,
        sprite=flr(rnd(2))*2+160,
        damage_bonus=flr(rnd(globals.difficulty/10)),
        max_health=enemy_factory.minimum_health + flr(rnd(globals.difficulty))
    })
end