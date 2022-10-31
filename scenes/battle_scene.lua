-- [scene] battle_scene
battle_scene={
    buttons_disabled=false,
    selected_action=0,
    selected_enemy=0,
    battle=nil
}

-- configuration for separate components
local config={
    delays={
        player_attack=0.2,
        first_enemy_attack=0.05
    },
    bb={-- bounding box
        x=0,
        y=127,
        w=#'[Xall] heavy -##'*5,
        h=-(2+6*5),
        colors={
            outline_en=11,
            outline_ds=6,
            fill=0
        }
    },
    buttons={
        x=2,
        y=126-5*6+1,
        delay=0.2,
        actions={
            {'❎','cycle enemies','',''},
            {'⬅️','[X1] light  ','light','x1'},
            {'⬆️','[X1] heavy  ','heavy','x1'},
            {'➡️','[Xall] light','light','all'},
            {'⬇️','[Xall] heavy','heavy','all'}
        },
        colors={
            sel=11,
            en=7,
            ds=6
        }
    },
    pl={--player
        x=56,
        y=84
    }
}

function battle_scene.get_player_pos()
    return config.pl
end

-- disable buttons
local function disable_buttons()
    battle_scene.buttons_disabled = true
    battle_scene.selected_action = 0
    player_manager.get().is_current_turn = false
end

-- primary update function
function battle_scene._update()

    -- if it is the player's turn, then buttons are reenabled
    if player_manager.get().is_current_turn then
        battle_scene.buttons_disabled = false
        if battle_scene.selected_enemy >= #battle_scene.battle.enemies then
            battle_scene.selected_enemy = 0
        end
    else
        disable_buttons()
    end

    -- do nothing if no input
    if battle_scene.buttons_disabled then
        return
    end

    -- cycle enemies
    if btnp(globals.btn_x) then
        battle_scene.selected_enemy += 1
        sound_fx.tip()
    end

    -- x1 light
    if btnp(globals.btn_left) then
        battle_scene.selected_action = 1

        -- play select sfx and attack
        sound_fx.select()
        wait(function()
            player_manager.get():light_one(battle_scene.selected_enemy + 1)
            wait(function()
                battle_scene.battle:advance()
            end,config.delays.first_enemy_attack)
        end,config.delays.player_attack)

        disable_buttons()
    end
    -- x1 heavy
    if btnp(globals.btn_up) then
        battle_scene.selected_action = 2

        -- play select sfx and attack
        sound_fx.select()
        wait(function()
            player_manager.get():heavy_one(battle_scene.selected_enemy + 1)
            wait(function()
                battle_scene.battle:advance()
            end,config.delays.first_enemy_attack)
        end,config.delays.player_attack)

        disable_buttons()
    end
    
    -- xAll light
    if btnp(globals.btn_right) then
        battle_scene.selected_action = 3

        -- attack all enemies
        sound_fx.select()
        wait(function()
            player_manager.get():light_all()
            wait(function()
                battle_scene.battle:advance()
            end,config.delays.first_enemy_attack)
        end,config.delays.player_attack)

        disable_buttons()
    end
    -- xAll heavy
    if btnp(globals.btn_down) then
        battle_scene.selected_action = 4

        -- attack all enemies
        sound_fx.select()
        wait(function()
            player_manager.get():heavy_all()
            wait(function()
                battle_scene.battle:advance()
            end,config.delays.first_enemy_attack)
        end,config.delays.player_attack)

        disable_buttons()
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
        local button,action,weight,target = unpack(a)
        if i > 1 then
            print(button..' '..action..' -'..player_manager.get().damage[weight][target],
            config.buttons.x,config.buttons.y+offset,swap or color)
        else
            if not battle_scene.buttons_disabled then
                if #battle_scene.battle.enemies <= 1 then
                    swap = 5
                else
                    swap = 3
                end
            end
            print(button..' '..action,
            config.buttons.x,config.buttons.y+offset,swap or color)
        end
        offset+=6
    end
end


-- primary draw function
function battle_scene._draw()
    -- background
    -- TODO: make this based on the level's color
    cls(1)

    -- draw enemies
    local player = player_manager.get()
    local enemies = battle_scene.battle.enemies
    for i,en in ipairs(enemies) do
        en:_draw()
        if en.damage_bonus > 0 then
            print('★'..en.damage_bonus,en.x-2*en.w,en.y-16*en.h,2)
        end
        if player.is_current_turn and i == battle_scene.selected_enemy + 1 then
            spr(globals.up_spr,en.x-2*en.w,en.y+2*en.h,1,1)
        end
    end

    -- draw player sprite
    spr(34,config.pl.x,config.pl.y,player.w,player.h)

    -- draw button rows
    render_button_box()
    render_buttons()

    -- render health
    print('♥ '..player.health..'/'..player.max_health,config.bb.x+config.bb.w + 4,120,7)

end--_draw()