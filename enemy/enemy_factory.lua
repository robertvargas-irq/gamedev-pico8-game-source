enemy_factory={
    minimum_health=50
}

function enemy_factory.generate(x,y)
    return enemy:new(x,y,{
        w=2,
        h=2,
        sprite=flr(rnd(3))*2+160,
        damage_bonus=flr(rnd(globals.get_difficulty()/4)),
        max_health=enemy_factory.minimum_health -- minimum health
        +flr(rnd(globals.get_difficulty()*3)) -- random value from 0 -> current difficulty * modifier
        +flr(globals.get_difficulty()/7)     -- current difficulty / 7 (floored)
    })
end