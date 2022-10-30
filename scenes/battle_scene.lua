-- [scene] battle_scene
battle_scene={
    buttons_disabled=false,
    selected_action=0,
    battle=nil
}

-- configuration for separate components
local config={
    bb={-- bounding box
        x=0,
        y=127,
        w=#'[Xall] heavy'*6,
        h=-(2+6*4),
        colors={
            outline_en=11,
            outline_ds=6,
            fill=0
        }
    },
    buttons={
        x=2,
        y=126-4*6+1,
        delay=0.2,
        actions={
            {'⬅️','[X1] light'},
            {'⬆️','[X1] heavy'},
            {'➡️','[Xall] light'},
            {'⬇️','[Xall] heavy'}
        },
        colors={
            sel=11,
            en=7,
            ds=6
        }
    },
    pl={--player
        x=60,
        y=92
    }
}

-- disable buttons
local function disable_buttons()
    battle_scene.buttons_disabled = true
end

-- primary update function
function battle_scene._update()

    -- do nothing if no input
    if battle_scene.buttons_disabled then
        return
    end

    -- x1 light
    if btnp(globals.btn_left) then
        battle_scene.selected_action = 1
        wait(disable_buttons,config.buttons.delay)
    end
    -- x1 heavy
    if btnp(globals.btn_up) then
        battle_scene.selected_action = 2
        wait(disable_buttons,config.buttons.delay)
    end
    
    -- xAll light
    if btnp(globals.btn_right) then
        battle_scene.selected_action = 3

        -- attack all enemies
        wait(disable_buttons,config.buttons.delay)
    end
    -- xAll heavy
    if btnp(globals.btn_down) then
        battle_scene.selected_action = 4
        wait(disable_buttons,config.buttons.delay)
    end

end--_update()

-- render button bounding box
local function render_button_box()
    rectfill(
        config.bb.x,
        config.bb.y,
        config.bb.x+config.bb.w,
        config.bb.y+config.bb.h,
        config.bb.colors.fill
    )

    -- grey out box if buttons are disabled
    local color = config.bb.colors.outline_en
    if battle_scene.buttons_disabled then
        color = config.bb.colors.outline_ds
    end
    rect(
        config.bb.x,
        config.bb.y,
        config.bb.x+config.bb.w,
        config.bb.y+config.bb.h,
        color
    )
end

-- render player buttons
local function render_buttons()
    -- get default color
    local color = config.buttons.colors.en
    if battle_scene.buttons_disabled then
        color = config.buttons.colors.ds
    end

    -- draw each button to the screen
    local offset = 0
    for i,a in ipairs(config.buttons.actions) do
        -- swap color if selected
        local swap = nil
        if not battle_scene.buttons_disabled
        and battle_scene.selected_action == i then
            swap = config.buttons.colors.sel
        end

        -- print button to the screen
        local button,action = unpack(a)
        print(button..' '..action,config.buttons.x,config.buttons.y+offset,swap or color)
        offset+=6
    end
end


-- primary draw function
function battle_scene._draw()
    -- background
    -- TODO: make this based on the level's color
    cls(1)

    -- draw enemies
    local enemies = battle_scene.battle.enemies
    for en in all(enemies) do
        en:_draw()
    end

    -- draw player sprite
    spr(player.spr+7,config.pl.x,config.pl.y)

    -- draw button rows
    render_button_box()
    render_buttons()

end--_draw()