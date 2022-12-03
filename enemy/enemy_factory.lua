enemy_factory={}
local minimum_health=50

function enemy_factory.generate(x,y)
    local diff=globals.get_difficulty()
    return enemy:new(x,y,{
        w=2,
        h=2,
        sprite=flr(rnd(3))*2+160,
        damage_bonus=flr(rnd(diff/4)),
        max_health=minimum_health -- minimum health
        +flr(rnd(diff*3)) -- random value from 0 -> current difficulty * modifier
        +flr(diff/7)     -- current difficulty / 7 (floored)
    })
end