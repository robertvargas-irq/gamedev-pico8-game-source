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
            'aH, ABOUT TIME MY COURIER\nSHOWED UP.',
            'wELCOME BACK FROM YOUR\nEVENTFUL JOURNEY THROUGH\nTHE NEW WORLD.',
            'hERE, GREEN ONE, PLEASE\nDELIVER THIS TO sirus,\nONLY odin COULD IMAGINE\nHOW UPSET HE\'D BE IF IT\nARRIVED LATE.',
            'i DON\'T PAY YOU TO STAND\nAROUND.',
            'hURRY ALONG NOW.',
            'tHE FOREST ISN\'T FRIENDLY\nCOME SUNDOWN.'
        },
        -- level 2 start
        {
            "hM? oF COURSE MY NAME IS\nsirus.",
            "a PACKAGE? oH! i'VE BEEN\nWAITING FOR THESE.",
            'HM-HM-HMMM.....',
            'ER. wHY ARE YOU STILL\nSTANDING THERE?',
            'oH! rIGHT, i HAVE OUTBOUND\nMAIL.',
            'odin\'S SON HAS BEEN\nNAGGING ABOUT HIS CLOTHES\nBEING TOO LARGE...',
            '...SO i TAILOR-FIT THESE.',
            'iF HE REFUSES THE NEW\nCLOTHES...',
            '...TELL HIM TO FIND\nSOMEONE ELSE TO DO HIS\nTAILORING.',
            'mAY THE TRAILS OF\nchimera mountain\nBE FRIENDLY TO YOU.'
        },
        -- level 3 start
        {
            'mUST HAVE BEEN QUITE\nTHE HIKE UP HERE.',
            'tHIS BEST BE MY CLOTHES.',
            'hM...',
            'iT MUST HAVE SHRUNK\nON THE WAY HERE.\n\ntRAGIC.',
            'ANYWHO.',
            'i HAVE SOMETHING TO\nSHIP OUT.',
            'mY FATHER WISHES THIS\nTO BE SENT WITH THE\nLOWEST POSTAGE COST.',
            'yOU\'RE THE BEST IN\nHIS PRICE RANGE.',
            'pLEASE. bE EXTRA CAREFUL\nWITH THIS...',
            '...OR ELSE HE\'LL COME FOR\nME.',
            'AND i\'M NOT TALKING ABOUT\nMY FATHER.'
        },
        -- level 3 end - game over
        {
            'wHO LET YOU IN?',
            'a PACKAGE?',
            'wAIT RIGHT THERE.',
            '...',
            '...',
            'mY TREAT!',
            'tHANK YOU DELICIOUS PERS-\ni MEAN-\n\nlOVELY COURIER.',
            'pLEASE SEE YOUR WAY OUT.\naND PLEASE MIND THE BONES-',
            '-i WAS A BIT HUNGRY.',
            'tHE LAST COURIER WAS NOT\nIN UNIFORM.\n\nIT WAS MY MISTAKE.',
            'TATA FOR NOW.'
        }
    }
}

-- current dialogue option
local dialogue,hat,collar,voice,shop_music=1,0,18,8,11

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
        return
    end
    sfx(voice)
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
        voice=12
        shop_music=10
    else
        m.sprite=32
        hat=0
        collar=18
        voice=8
        shop_music=11
    end

    music(-1,500)
    music(shop_music)
    sfx(voice)
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
