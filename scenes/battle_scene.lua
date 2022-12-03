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
        h=-32
    },
    buttons={
        x=2,
        y=126-5*6+1,
        delay=0.2,
        actions={
            {'❎','cycle enemies','',''},
            {'⬅️','X1  |light','light','x1'},
            {'➡️','X1  |heavy','heavy','x1'},
            {'⬆️','Xall|light','light','all'},
            {'⬇️','Xall|heavy','heavy','all'}
        }
    },
    pl={--player
        x=60,
        y=84
    }
}

function battle_scene.get_player_pos()
    return config.pl
end

-- disable buttons
local function disable_buttons()
    battle_scene.buttons_disabled=true
    battle_scene.selected_action=0
    player_manager.get().is_current_turn=false
end

-- primary update function
function battle_scene._update()

	-- if player reaches 0 health return to the main menu
	if player_manager:get()~=nil then
		if player_manager:get().health<=0 then
            battle_scene.battle:stop()
            globals.deaths+=1
			main_menu.init()
            return
		end
	end

    -- if it is the player's turn, then buttons are reenabled
    if player_manager.get().is_current_turn then
        battle_scene.buttons_disabled=false
        if battle_scene.selected_enemy>=#battle_scene.battle.enemies then
            battle_scene.selected_enemy=0
        end
    else
        disable_buttons()
    end

    -- do nothing if no input
    if battle_scene.buttons_disabled then
        return
    end

    -- cycle enemies
    if btnp(btn_x) and #battle_scene.battle.enemies>1 then
        battle_scene.selected_enemy+=1
        sound_tip()
    end

    -- x1 light
    if btnp(btn_left) then
        battle_scene.selected_action=1

        -- play select sfx and attack
        sound_select()
        wait(function()
            player_manager.get():light_one(battle_scene.selected_enemy+1)
            wait(function()
                battle_scene.battle:advance()
            end,config.delays.first_enemy_attack)
        end,config.delays.player_attack)

        disable_buttons()
    end
    -- x1 heavy
    if btnp(btn_right) then
        battle_scene.selected_action=2

        -- play select sfx and attack
        sound_select()
        wait(function()
            player_manager.get():heavy_one(battle_scene.selected_enemy+1)
            wait(function()
                battle_scene.battle:advance()
            end,config.delays.first_enemy_attack)
        end,config.delays.player_attack)

        disable_buttons()
    end
    
    -- xAll light
    if btnp(btn_up) then
        battle_scene.selected_action=3

        -- attack all enemies
        sound_select()
        wait(function()
            player_manager.get():light_all()
            wait(function()
                if battle_scene.battle ~= nil then
                    battle_scene.battle:advance()
                end
            end,config.delays.first_enemy_attack+(#battle_scene.battle.enemies-1)/5)
        end,config.delays.player_attack)

        disable_buttons()
    end
    -- xAll heavy
    if btnp(btn_down) then
        battle_scene.selected_action=4

        -- attack all enemies
        sound_select()
        wait(function()
            player_manager.get():heavy_all()
            wait(function()
                battle_scene.battle:advance()
            end,config.delays.first_enemy_attack+(#battle_scene.battle.enemies-1)/5)
        end,config.delays.player_attack)

        disable_buttons()
    end

end--_update()

-- render button bounding box
local function render_button_box()
    -- render primary box
    rectfill(
        0,
        127,
        127,
        95,
        0
    )
    
    -- grey out box if buttons are disabled
    local color=11
    if battle_scene.buttons_disabled then
        color=6
    end
    rect(
        0,
        127,
        127,
        95,
        color
    )

    -- draw health box
    rect(103,79,127,95,color)
    rectfill(104,80,126,96,0)
end

-- render player buttons
local function render_buttons()
    -- get default color
    local color=7
    if battle_scene.buttons_disabled then
        color=6
    end

    -- draw health
    local pl=player_manager.get()
    print(pl.health,114,81,color)
    print('♥',105,85,color+1)
    line(113,87,125,87,color)
    print(pl:get_max_health(),114,89,color)

    -- draw each button to the screen
    local offset=0
    for i,a in ipairs(config.buttons.actions) do
        -- swap color if selected
        local swap=nil

        -- print button to the screen
        local button,action,weight,target=unpack(a)
        local bx,by=config.buttons.x,config.buttons.y
        if i > 1 then
            local acc=pl.acc_mod[weight][target]+pl:get_acc_bonus()
            local sign='+'
            if acc < 1 then
                sign='-'
            end
            acc=abs(1-acc)
            print(button,bx,by+offset+1,swap or 8)
            print(button..' '..action..'|DMG '..(pl.damage[weight][target]+pl:get_bonus_damage())..'|ACC '
            ..sign..flr(acc*100)..'%',
            bx,by+offset,swap or color)
        else
            if not battle_scene.buttons_disabled then
                if #battle_scene.battle.enemies<=1 then
                    swap=5
                else
                    swap=3
                end
            end
            if #battle_scene.battle.enemies>1 then
                print(button,bx,by+offset+1,11)
            end
            print(button..' '..action,
            bx,by+offset,swap or color)
        end
        offset+=6
    end
end

-- render background
local function render_background()
    local l=30*sqrt(level.active:get_active_room().enemy_count)
    for i=0,40,4 do
        line(64+l+i,0,64+i+i,128,5)
        line(64-l-i,0,64-i-i,128,5)
    end
end

-- primary draw function
local bg_c={1,1,0}
function battle_scene._draw()
    -- background
    cls(bg_c[current_level])
    render_background()

    -- draw enemies
    local player,enemies=player_manager.get(),battle_scene.battle.enemies
    for i,en in ipairs(enemies) do
        en:_draw()
        local en_x,en_y,en_w,en_h=en.x,en.y,en.w,en.h
        local loc_x,loc_y=en_x-2*en_w,en_y+7*en_h

        -- print enemy damage with offset
        local correction_x,correction_y=0,0
        if i>3 then
            correction_x=(i%2==0) and 16 or -16
            correction_y=8
        end
        print(1+en.damage_bonus,en_x+correction_x,en_y-15.5*en_h+correction_y,0)
        print(1+en.damage_bonus,en_x+correction_x,en_y-16*en_h+correction_y,2)
        spr(236,loc_x-6+correction_x,en_y-16*en_h-4+correction_y,2,1)
        -- print enemy selectors
        if player.is_current_turn then
            -- selected enemy
            if i==battle_scene.selected_enemy+1 then
                spr(up_spr,loc_x,en_y+3*en_h+1,1,1)
                if #enemies>1 then
                    print('❎',loc_x+1,loc_y+3,3)
                    print('❎',loc_x+1,loc_y+2,11)
                end
            end
            -- print (x) swap
            if #enemies>1 and (i==battle_scene.selected_enemy+2 or (i==1 and battle_scene.selected_enemy==#enemies-1)) then
                spr(up_spr+16,loc_x,en_y+3*en_h+1,1,1)
            end
        end
    end

    -- draw player sprite
    spr(34,config.pl.x-4,config.pl.y,player.w,player.h)

    -- draw button rows
    render_button_box()
    render_buttons()

    -- render health
    local offset,offset_cnt,bonuses=8,1,{
        
        { -- temp Acc
            'tmp⧗',
            '%acc',
            10,
            player.bonuses.temp.accuracy
        },
        { -- temp Damage
            'tmp⧗',
            'dmg',
            10,
            player:get_temp_bonus_damage()
        },
        { -- temp Health
            'tmp⧗',
            'hp',
            10,
            player:get_temp_bonus_health()
        },

        { -- perm Acc
            '★',
            '%acc',
            11,
            player.bonuses.perm.accuracy
        },
        { -- perm Damage
            '★',
            'dmg',
            11,
            player:get_perm_bonus_damage()
        },
        { -- perm Health
            '★',
            'hp',
            11,
            player:get_perm_bonus_health()
        }
    }

    for b in all(bonuses) do
        local flair,type,clr,bonus=unpack(b)
        if bonus>0 then
            local s=flair..'+'..bonus..type
            print(s,2,96-offset*offset_cnt,0)
            print(s,2,97-offset*offset_cnt,clr)
            offset_cnt+=1    
        end
    end

end--_draw()