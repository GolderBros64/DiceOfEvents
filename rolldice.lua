-- Text Vars
bless = "\\#1cd6bd\\The\\#12a302\\ Dice \\#1cd6bd\\Blessed You!"
curse = "\\#d61c1c\\The\\#de0000\\ Dice\\#d61c1c\\ Cursed You!"
chal = "\\#d61c1c\\The \\#bf8d04\\Dice \\#d61c1c\\Challenged \\#ffffff\\You\\#d61c1c\\!\\#ffffff\\"

ab = "\\#2cf590\\A Button\\#ffffff\\"
bb = "\\#6bc9b0\\B Button\\#ffffff\\"
zb = "\\#8433f5\\Z Button\\#ffffff\\"

-- Dice
dcn = "\\#bf8d04\\Dice "
dcb = "\\#de0000\\Dice "
dcg = "\\#12a302\\Dice "

--- @param m MarioState
function roll_dice(m, frc, val)
    if not gMarioStates[0] then return end
    if m.action ~= ACT_IN_CANNON or m.health ~= 0 then
        timer = mxtimer
    if frc == 0 then
        rng = random_linear_offset(0, mxrn)
        if rng == lastrng then
            rng = random_linear_offset(0, mxrn)
        else
            lastrng = rng
        end
    else
        rng = tonumber(val)
        lastrng = 0
    end
    dicerolled = dicerolled + 1

    if rng == 0 then -- kill Player 
    if not mhExists == true then
        m.health = 0
        set_mario_action(m, ACT_FREEFALL, 0)
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
        djui_chat_message_create("The " .. dcb .. "\\#bf0202\\Killed \\#ffffff\\you!")
    else
        m.health = m.health / 2
        set_mario_action(m, ACT_FREEFALL, 0)
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
        m.invincTimer = 60
        djui_chat_message_create("The " .. dcb .. "\\#bf0202\\Halved \\#ffffff\\your HP!")
    end
    elseif rng == 1 then -- heal 1 hp
        if  m.health < 2176 then
            m.health = m.health + 256
            djui_chat_message_create("The " .. dcg .. "\\#ffffff\\Healed you by \\#12a302\\1.0\\#ffffff\\ HP!")
        else
            djui_chat_message_create("The " .. dcg .. "\\#ffffff\\Tried to heal you...\nBut you were full health.")
        end
    elseif rng == 2 then -- dmg 1 hp
        m.health = m.health - 256
        set_mario_action(m, ACT_FREEFALL, 0)
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
        m.invincTimer = 60
        djui_chat_message_create("The ".. dcb .. "\\#ffffff\\Damaged you by\\#de0000\\ 1.0 \\#ffffff\\HP!")
    elseif rng == 3 then -- Disable Z Button
        zbutton = 0
        btTimer = 25000
        djui_chat_message_create("" .. curse .. "\n\\#fa2828\\Your " .. zb .. " \\#fa2828\\Has Been Disabled!")
    elseif rng == 4 then -- Cut Timers in Half
        if timer ~= 0 then
            timer = timer / 2 
        end
        if btTimer ~= 0 then
            btTimer = btTimer / 2
        end
        if firet ~= 0 then
            firet = firet / 2
        end
        if firstcut == 1 and tutorial == 0 then
            firstcut = 0
            tutorial = 1
        end
        djui_chat_message_create("" .. bless .. "\n\\#6bc9b0\\All Running Timers Cut in Half!")
    elseif rng == 5 then -- Stun the Player
        set_mario_action(m, ACT_FREEFALL, 0)
        set_mario_action(m, 131622, 0) -- bowser stun action
        djui_chat_message_create("The " .. dcb .. "\\#ebd128\\Stunned\\#ffffff\\ You!")
    elseif rng == 6 then
        local o = spawn_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, m.pos.x, m.pos.y, m.pos.z, nil)
            o.oIntangibleTimer = -1
        djui_chat_message_create("The " .. dcb .. "\\#ffffff\\Exploded You!")
    elseif rng == 7 then -- Damage Random Val
        ranval = random_linear_offset(0, 9) * 272
        if (ranval / 272) ~= 0 then
            set_mario_action(m, ACT_FREEFALL, 0)
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
            m.invincTimer = 60
        end
        if mhExists == true then
            if mhApi.isHardMode == 1 then
                ranval = 272
            else
                ranval = ranval / 2
            end
        end
        if (ranval / 272) == 0 then
            djui_chat_message_create("The ".. dcn .. "\\#ffffff\\did \\#666666\\Nothing...")
        elseif (ranval / 272) == 8 then
            if not mhExists == true then
                djui_chat_message_create("The ".. dcb .. "\\#bf0202\\Killed \\#ffffff\\you!")
            else
                ranval = 7 * 272
            end
        else
            djui_chat_message_create("The ".. dcb .. "\\#ffffff\\Damaged you by\\#de0000\\ " .. (ranval / 272) .. "\\#ffffff\\ HP!")
        end
         m.health = m.health - ranval
    elseif rng == 8 then -- Horde o' Goombas
        goomba_horde(random_linear_offset(1, 4), m)
        djui_chat_message_create("The " .. dcb .. "\\#ffffff\\Summoned Some \\#9c5110\\Goombas\\#ffffff\\!")
    elseif rng == 9 then
        fireb = random_linear_offset(0, 3)
        firet = 9999
        firet = timer + 7500
        infire = 1
        if fireb == 0 then
           fireb = A_BUTTON
           firetx = " \\#2cf590\\A Button\\#ffffff\\ "
        elseif fireb == 1 then
            fireb = Z_TRIG
            firetx = " \\#8433f5\\Z Button\\#ffffff\\ "
        elseif fireb == 2 then
            fireb = B_BUTTON
            firetx = " \\#6bc9b0\\B Button\\#ffffff\\ "
        end
        djui_chat_message_create("" .. curse .. "\n\\#fa2828\\Your" .. firetx .. "\\#fa2828\\has been Flamed!")
    elseif rng == 10 then -- player gains a life
        if not mhExists then
            gMarioStates[0].numLives = gMarioStates[0].numLives + 1
            play_sound_if_no_flag(gMarioStates[0], SOUND_GENERAL_COLLECT_1UP, 0)
            djui_chat_message_create("" .. bless .. "\\#1cd6bd\\\nYou Gained a Life!")
        else
            if mhApi.getTeam == 1 then
                roll_dice(gMarioStates[0], 1, 13)
            else
                djui_chat_message_create("The ".. dcn .. "\\#ffffff\\did \\#666666\\Nothing...")
            end
        end
    elseif rng == 11 then -- overlay fire
        if not mhExists then
            ovrtimer = 4500
            ovrtmp = 1
            djui_chat_message_create("\\#fa2828\\You Feel Hot...\nVery Hot!")
        else
            roll_dice(gMarioStates[0], 0, 0)
        end
        
    elseif rng == 12 then -- dash
            m.pos.y = m.pos.y + 60
            set_mario_action(m, ACT_DIVE, 0)
            m.forwardVel = 90
            djui_chat_message_create("\\#ffffff\\The " .. dcn .. "\\#ffffff\\Made you \\#9effe7\\Dash\\#ffffff\\ Foward!") 
    elseif rng == 13 then -- heal random
        if  m.health < 2176 then
            ranval = random_linear_offset(0, 9) * 272
            m.health = m.health + ranval
            if (ranval / 272) ~= 0 then
                play_character_sound(m, CHAR_SOUND_HAHA)
            end
            if (ranval / 272) == 0 then
                djui_chat_message_create("The ".. dcn .. "\\#ffffff\\did \\#666666\\Nothing...")
            elseif (ranval / 272) == 8 then
                djui_chat_message_create("The ".. dcg .."\\#32bf22\\Fully Healed \\#ffffff\\you!")
            else
                djui_chat_message_create("The ".. dcg .. "\\#ffffff\\Healed you by\\#32bf22\\ " .. (ranval / 272) .. "\\#ffffff\\ HP!")
            end 
        else
            djui_chat_message_create("The " .. dcg .. "\\#ffffff\\Tried to heal you...\nBut you were full health.")
        end
    elseif rng == 14 then -- bonk
        set_mario_action(m, ACT_FREEFALL, 0)
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
        djui_chat_message_create("\\#ffffff\\The " .. dcn .. "\\#ffffff\\Made you \\#9effe7\\Bonk\\#ffffff\\!") 
    elseif rng == 15 then -- Give coins -Suggested by Pol
        local i = random_linear_offset(1, 31)
        m.numCoins = m.numCoins + i
        djui_chat_message_create("\\#ffffff\\The ".. dcn .. "\\#ffffff\\Gave you \\#bf8d04\\" .. i .." Coins\\#ffffff\\!")
        if i > 10 and i < 20 then
            play_character_sound(m, CHAR_SOUND_HAHA)
        elseif i < 10 and i > 4 then
            play_character_sound(m, CHAR_SOUND_PUNCH_WAH)
        elseif i < 4 or i == 4 then
            play_character_sound(m, CHAR_SOUND_YAH_WAH_HOO)
        elseif i > 20 then
            play_character_sound(m, CHAR_SOUND_YAHOO)
        end
        if m.numCoins > 99 and m.numCoins < 100 then
            m.numCoins = 99
        end
        coinsgot = coinsgot + i
    elseif rng == 16 then -- special triple -Suggested by Pol
        sptimer = 20000
        spmove = ACT_TRIPLE_JUMP
        sprep = ACT_SPECIAL_TRIPLE_JUMP
        djui_chat_message_create("\\#bf8d04\\Special Triple Jump \\#ffffff\\Unlocked!\n\\#666666\\(for a limited time)")
    elseif rng == 17 then -- A Button challenge
    if not mhExists then
        if achal == 0 then
            achal = 1
            achaltmr = 150000
            djui_chat_message_create("" .. chal .. "\nYour " .. ab .. " has been disabled Until you Get a Star!\n\\#666666\\(Or Wait 5 Minutes)")
        else
            roll_dice(gMarioStates[0], 0, 0)
            achaltmr = 0
        end
    else
        roll_dice(gMarioStates[0], 1, 3)
    end
    elseif rng == 18 then
        m.squishTimer = 350
        djui_chat_message_create("\\#ffffff\\The " .. dcb .. "\\#bf8d04\\Squished\\#ffffff\\ You!")

    elseif rng == 19 then -- lowgrav
    if not mhExists == true then
        djui_chat_message_create("\\#ffffff\\The " .. dcn .. " \\#ffffff\\Gave you \\#bf8d04\\Low Gravity\\#ffffff\\!")
        lowgrav = 1
        gravtimer = 10000 
    else
        roll_dice(gMarioStates[0], 1, 18)

    end
    elseif rng == 20 then -- water allergy
        allergy = "\\#1854b5\\Water"
        djui_chat_message_create("You are now Allergic to \\#1854b5\\Water\\#ffffff\\!\n\\#8a8a8a\\(Dont touch it or you will die)")
        allergytmr = 30000
        if mhExists == true then
            allergytmr = 5000
        end
    elseif rng == 21 then -- Teleport -- Last 1.0 feature!
        if not mhExists == true then
            local tmp = random_linear_offset(4, 21) -- with 22(or up to 21) the game would have tpd you to Stage ID 25 resulting in no teleport
            --djui_popup_create("Act: " .. tmp .. "", 1)
            warp_to_level(tmp, 1, 0)
            --[[ 9 = BOB | 8 = SSL | 5 = CCM | 4 = BBH | 10 = SL | 7 = HMC | 11 = WDW | 6 = MainFloor | 13 = THI | 14 = TTC | 15 = RR | 12 = JRB | 
            -- | 17 = BITDW | 18 = VCUTM | 22 = LLL | 21 = BITS | 19 = BITFS | 16 = CG | 20 = TSA | 24 = WF | 23 = DDD | ]]
            if tmp == 9 then
                loc = "\\#4a4a4a\\Bomb Omb \\#098500\\Battlefield"
            elseif tmp == 4 then
                loc = "\\#8d29cc\\Big Boo's Haunt"
            elseif tmp == 10 then
                loc = "\\#96ecff\\Snowman's Land"
            elseif tmp == 7 then
                loc = "\\#8aba18\\Hazy Maze Cave"
            elseif tmp == 11 then
                loc = "\\#1f6fd1\\Wet Dry World"
            elseif tmp == 6 then
                loc = "\\#ff4545\\Castle Main Floor"
            elseif tmp == 13 then
                loc = "\\#cf9729\\Tiny \\#ab1f00\\Huge \\#006ead\\Island"
            elseif tmp == 14 then
                loc = "\\#ffaa00\\Tick Tock Clock"
            elseif tmp == 15 then
                loc = "\\#ff0000\\R\\#ffa500\\a\\#ffff00\\i\\#00ff00\\n\\#0000ff\\b\\#4b0082\\o\\#7f00ff\\w \\#e3e3e3\\Ride"
            elseif tmp == 12 then
                loc = "\\#312ed1\\Jolly Roger Bay"
            elseif tmp == 5 then
                loc = "\\#61b3ed\\Cool Cool Mountain"
            elseif tmp == 8 then
                loc = "\\#e1e35d\\Shifting \\#c2b280\\Sand \\#e1e35d\\Land"
            elseif tmp == 17 then
                loc = "\\#ff0000\\Bowser \\#adadad\\In The \\#666666\\Dark \\#adadad\\World"
            elseif tmp == 18 then
                loc = "\\#a7b7c7\\Vanish Cap \\#949494\\Under The Moat"
            elseif tmp == 22 then
                loc = "\\#b80000\\Lethal Lava Land"
            elseif tmp == 21 then
                loc = "\\#ff0000\\Bowser \\#8c8c8c\\In The \\#451878\\Sky"
            elseif tmp == 19 then
                loc = "\\#ff0000\\Bowser \\#878787\\In The \\#b81818\\Fire Sea"
            elseif tmp == 16 then
                loc = "\\#30bf26\\Castle Grounds"
            elseif tmp == 20 then
                loc = "\\#21268a\\The Secret \\#164ad9\\Aquarium"
            elseif tmp == 24 then
                loc = "\\#8c8d8f\\Whomp's \\#cc631d\\Fortress"
            elseif tmp == 23 then
                loc = "\\#0043de\\Dire Dire Docks"
            else
                loc = "\\#666666\\Unknown?"
            end
            djui_chat_message_create("The " .. dcn .. "\\#ffffff\\Teleported you to " .. loc .. "\\#ffffff\\!")
        else
            roll_dice(gMarioStates[0], 0, 0)
        end
    else
        djui_chat_message_create("\\#666666\\Nothing Happend... Strange.")
    end






    if (dbg ~= 1 or dbg ~= 31) and tutorial ~= 0 and frc == 0 and autodice == 0 then
        if rng == 4 then
            djui_chat_message_create("\\#8a8a8a\\(Wait \\#6bc9b0\\" .. (mxtimer / 1000) .. "\\#8a8a8a\\ seconds to Roll the dice again!)")
        else
            djui_chat_message_create("\\#8a8a8a\\(Wait " .. (mxtimer / 500) .. " seconds to Roll the dice again!)")
        end
        if done == 0 then
            tutorial = tutorial - 1
        end
        if frc ~= 0 then
            timer = 0
        end
    end
    done = 1

elseif gMarioStates[0].action == ACT_IN_CANNON then
    timer = mxtimer
        if not autodice == 1 then
            djui_chat_message_create("\\#d62727\\You Can't Roll The \\#bf8d04\\Dice\\#d62727\\ inside Cannons!")
        end
    end
end

