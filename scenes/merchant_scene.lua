-- [scene] merchant
merchant_scene={}

local m={
    sprite=32,
    x=56,
    y=56,
    w=2,
    h=2,
    clr_choices={1,2,4,9,15},
    clr=2,
    speech_x=14,
    speech_y=5
}

local stand={
    x0=4,
    x1=123,
    board_w=5
}

function merchant_scene.speak(text)
    print(text,m.speech_x,m.speech_y,7)
end

function merchant_scene.init()
    m.clr=rnd(m.clr_choices)
    globals.screen=3
end

function merchant_scene._update()

end

function merchant_scene._draw()
    cls()
    -- pset(64,64,1)
    rectfill(m.x,m.y+1,m.x+15,m.y+9,m.clr) -- merchant skin
    rectfill(m.x+5,m.y+20,m.x+10,m.y+16,m.clr) -- merchant neck
    spr(m.sprite,m.x,m.y,2,2) -- merchant head
    spr(0,m.x,m.y-8,2,1) -- hat
    spr(18,m.x,m.y+16,2,1) -- collar

    rectfill(stand.x0,79,stand.x1,128,4) -- primary wood
    rectfill(stand.x0,80,stand.x1,80,15) -- counter aux board
    rectfill(stand.x0,78,stand.x1,78,15) -- counter
    rectfill(stand.x0,125,stand.x1,125,15) -- bottom aux board
    rectfill(stand.x0,127,stand.x1,127,15) -- bottom board

    -- wooden boards
    for i=stand.x0,stand.x1,stand.board_w do
        rectfill(i,80,i,126,15)
    end
    rectfill(stand.x1,80,stand.x1,126,15)

    -- stand poles
    rectfill(stand.x0,78,stand.x0+5,0,5)
    rectfill(stand.x1,78,stand.x1-5,0,5)

    -- speak text
    merchant_scene.speak('tHANK YOU FOR DELIVERING \nTHIS PACKAGE SAFELY TO ME.\n\niT MUST HAVE BEEN QUITE \nTHE JOURNEY, i APPRECIATE\nYOUR DEDICATION.')
end
