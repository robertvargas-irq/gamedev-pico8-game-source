-- [scene] merchant
merchant_scene={}

local m={
    sprite=32,
    w=2,
    h=2,
    clr_choices={1,2,4,9,15},
    clr=2,
    dialogue={
        -- level 1 start
        {
            "aH, ABOUT TIME MY COURIER\nSHOWED UP.",
            "hERE, GREEN ONE, PLEASE\nDELIVER THIS TO SIRUS,\nONLY odin COULD IMAGINE\nHOW UPSET HE'D BE IF IT\nARRIVED LATE.",
            "hURRY ALONG NOW."
        },
        -- level 2 start
        {},
        -- level 3 start
        {},
        -- level 3 end - game over
        {}
    }
}

-- current dialogue option
local dialogue=1
local hat=0
local collar=18

-- display a merchant's dialogue on screen
function merchant_scene.speak(text)
    print(text,14,5,7)
end

function merchant_scene.advance_dialogue()

    -- if dialogue is finished, reset counter and begin game
    local d=m.dialogue[current_level]
    if dialogue>=#d then
        dialogue=1
        -- end game if last dialogue
        if current_level==4 then
            main_menu.init()
            return
        end
        level_play.init()
    end
    
    dialogue+=1

end

function merchant_scene.init()
    m.clr=rnd(m.clr_choices)
    screen=3
    dialogue=1

    -- fenrir sprite
    if current_level==4 then
        m.sprite=174
        m.clr=6
        hat=158
        collar=142
    else
        m.sprite=32
        hat=0
        collar=18
    end
end

function merchant_scene._update()
    -- advance dialogue on circle press
    if btnp(btn_z) then
        sound_ready()
        merchant_scene.advance_dialogue()
    end
end

function merchant_scene._draw()
    cls()

    rectfill(56,57,71,65,m.clr) -- merchant skin
    rectfill(61,76,66,72,m.clr) -- merchant neck
    spr(m.sprite,56,56,2,2) -- merchant head
    spr(hat,56,48,2,1) -- hat
    spr(collar,56,72,2,1) -- collar

    rectfill(4,79,123,128,4) -- primary wood
    rectfill(4,80,123,80,15) -- counter aux board
    rectfill(4,78,123,78,15) -- counter
    rectfill(4,125,123,125,15) -- bottom aux board
    rectfill(4,127,123,127,15) -- bottom board

    -- wooden boards
    for i=4,123,5 do
        rectfill(i,80,i,126,15)
    end
    rectfill(123,80,123,126,15)

    -- stand poles
    rectfill(4,78,9,0,5)
    rectfill(123,78,118,0,5)

    -- speak text
    merchant_scene.speak(m.dialogue[current_level][dialogue])
end
