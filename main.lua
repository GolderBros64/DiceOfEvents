-- name: \\#fcba03\\Dice \\#ffffff\\of \\#fcba03\\Events \\#8a8a8a\\(v1.0)
-- incompatible:
-- description: By Golderbros64 \\#545454\\(\\#fcba03\\@YTGolder\\#ffffff\\ On YT!\\#545454\\)\n\n\n Beta Testers: Pol
-- deluxe: true

GST = gGlobalSyncTable
GPT = gPlayerSyncTable

-- Vars
dicerolled = tonumber(mod_storage_load("dicerolled")) or 0
coinsgot = tonumber(mod_storage_load("coins")) or 0

rng = 0
autodice = tonumber(mod_storage_load("autodice")) or 0
done = 1
rantimer = 0
canttmr = 0
ranval = 0
firstcut = 1
fireb = A_BUTTON
firet = 0
firetx = "h"
infire = 2
mxtimer = 7500
ovrtimer = 0
ovrtmp = 0
sptmr = 0
spmove = ACT_TRIPLE_JUMP
sprep = ACT_SPECIAL_TRIPLE_JUMP
spsaid = 1
m = gMarioStates[0]
cantsaid = 0
lastrng = 0
mxrn = 22 -- -------------------- MAX RNG RESULT(mxrn - 1)
sptimer = 0
spsaid = 1
ovrsaid = 1
dbg = 0
txtsent = 0
timer = 500
btTimer = 0
tutorial = 3
zbutton = 1
abutton = 1
bbutton = 1
dcbt = 0
achal = 0
highgrav = 0
lowgrav = 0
gravtimer = 0
gravsaid = 1
allergy = "water"
allergytmr = 0
allergysaid = 1
savetmr = 1
loc = LEVEL_BOB

--Main Functions
--- @param m MarioState
function on_hud_render(m)
    if dbg == 1 then
        dbgtxt_txt("No Cooldown!", 255, 218, 51, FONT_MENU)
    end
    if dbg == 2 then
        dbgtxt_txt("Timer: " .. timer .. " ", 19, 24, 173, FONT_MENU)
    end
    if dbg == 98 then
        dbgtxt_txt("Tutorial: " .. tutorial .. " ", 255, 255, 255, FONT_MENU)
    end
    if dbg == 3 or dbg == 31 then
        dbgtxt_txt("Button Timer: " .. btTimer  .. " ", 255, 255, 255, FONT_MENU)
    end
    if dbg == 5 then
        dbgtxt_txt("Infinite HP!", 0, 125, 0, FONT_MENU)
    end
    if dbg == 51 then
        dbgtxt_txt("No Cooldown & Infinite HP!", 0, 127, 150, FONT_MENU)
    end
    if dbg == 6 then
        dbgtxt_txt("RanTimer: " .. rantimer .. " ", 200, 200, 200, FONT_MENU)
    end
    if dbg == 7 then
        dbgtxt_txt("Fire Timer: " .. firet  .. " ", 255, 255, 255, FONT_MENU)

    end
    if dbg == 8 then
        dbgtxt_txt("Over Timer: " .. ovrtimer  .. " ", 255, 255, 255, FONT_MENU)

    end
    if dbg == 10 then
        dbgtxt_txt("sptimer: " .. sptimer  .. " ", 255, 255, 255, FONT_MENU)
    end

    -- Overlay Effects non Debug

    if ovrtimer > 0 then
        fulloverlay_disp(ovrtmp)
        Overlay_Effects(gMarioStates[0], ovrtmp)
        if (gMarioStates[0].action == 939532992 or gMarioStates[0].action == 805315794 or gMarioStates[0].action == 805315266 or gMarioStates[0].action == 805315809) then
            ovrtimer = 0
        else
            ovrtimer = ovrtimer - 1
        end
        ovrsaid = 0
    elseif ovrtimer == 0 and ovrsaid == 0 then
        ovrsaid = 1
        djui_chat_message_create("\\#666666\\The effect faded away...")
    end
    if achal == 1 then
        txt_at("A Button Challenge", 255, 255, 255, 73, 87, 2, 2)
    end

    -- SAVING SYSTEM DONT DELETE --
    if savetmr ~= 0 then
        savetmr = savetmr - 1
        if savetmr == 0 then
            save_func()
            savetmr = 50
        end
    end
    
    return true
end


--- @param m MarioState
function on_set_mario_action(m)
    if dbg == 4 then
        djui_popup_create("Act: " .. m.action .. "\n( " .. tostring(m.action) .. " )", 2)
    end
end

function before_phys_step()
    local m = gMarioStates[0]
    if gravtimer ~= 0 then
        -- Credits to Emerald for this :3
        if highgrav == 1 then
            if m.vel.y > 0 then
                m.vel.y = m.vel.y / 1.06
            else
                m.vel.y = m.vel.y * 1.06
            end
        end
        -- ^^ and this
        if lowgrav == 1 then
            if m.vel.y > 0 then
                if  m.action ~= ACT_TWIRLING
                and m.action ~= ACT_GETTING_BLOWN
                and m.action ~= ACT_FLYING_TRIPLE_JUMP
                and m.action ~= ACT_SHOT_FROM_CANNON
                and m.action ~= ACT_LAVA_BOOST then
                    m.vel.y = m.vel.y * 1.03
                    if m.action ~= ACT_SIDE_FLIP or m.action ~= ACT_TRIPLE_JUMP or m.action ~= ACT_SPECIAL_TRIPLE_JUMP then
                        if m.vel.y > 75 then
                            m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
                            m.vel.y = -1
                        end
                    else
                        if m.vel.y > 45 then
                            m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
                            m.vel.y = -1
                        end
                    end

                end
            else
                if m.action == ACT_GROUND_POUND then
                    m.vel.y = m.vel.y / 1.025
                else
                    m.vel.y = m.vel.y / 1.05
                end
            end
        end 
    end

end


--- @param m MarioState
function before_mario_update(m)
   if zbutton == 0 then
    m.controller.buttonPressed = m.controller.buttonPressed & ~Z_TRIG
    m.controller.buttonDown = m.controller.buttonDown & ~Z_TRIG
   end
   if abutton == 0 or achal == 1 and not(gMarioStates[0].action == ACT_IN_CANNON) then
    m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
   end
   if bbutton == 0 then
    m.controller.buttonPressed = m.controller.buttonPressed & ~B_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~B_BUTTON
   end
   if dbg == 9 then
    djui_popup_create("HP:\n" .. gMarioStates[0].health .. "", 2)
   end

end



--Dependent Functions

--- @param m MarioState
function mario_update(m)

    button_func()
    if achal == 1 then
        achal_func(gMarioStates[0])
    end
    if (gMarioStates[0].controller.buttonPressed == D_JPAD or autodice == 1) and timer == 0 and gMarioStates[0].health > 0 then
        if gMarioStates[0].action ~= ACT_IN_CANNON then
            done = 0
            roll_dice(gMarioStates[0], 0, 0)
            txtsent = 0
            cantsaid = 0
        else
            cantsaid = 0
            if not autodice == 1 then
                djui_chat_message_create("\\#d62727\\You Can't Roll The \\#bf8d04\\Dice\\#d62727\\ inside Cannons!")
            end
        end
    elseif gMarioStates[0].controller.buttonPressed == D_JPAD and timer > 0 and cantsaid == 0 then
        cantsaid = 1
        djui_chat_message_create("\\#d62727\\You Can't Roll The \\#bf8d04\\Dice\\#d62727\\!")
    end
    if timer ~= 0 then
        timer = timer - 1
        if timer - 1 == 0 then
            timer = 0
        end
    end
    if btTimer ~= 0 then
        btTimer = btTimer - 1
        if btTimer < 1 then
            btTimer = 0
        end
    end
    if firet ~= 0 then
        firet = firet - 1
        infire = 1
        if firet < 1 then
            firet = 0
            button1cl_func()
            infire = 0
        end
        if (gMarioStates[0].action == 939532992 or gMarioStates[0].action == 805315794 or gMarioStates[0].action == 805315266 or gMarioStates[0].action == 805315809) then
            firet = 0
            button1cl_func()
        end
    end
    if sptimer ~= 0 then
        sptimer = sptimer - 1
    end
    if gravtimer ~= 0 then
        gravtimer = gravtimer - 1
    end
    if sptimer < 0 then
        sptimer = 0
    end
    if timer == 0 and txtsent == 0 and done == 1 and (dbg ~= 1 or dbg ~= 31) and autodice == 0 then
        txtsent = 1
        djui_chat_message_create("\\#ffda33\\You can roll The \\#bf8d04\\Dice\\#ffda33\\!")
        if dcbt == 0 then
            djui_chat_message_create("\\#8a8a8a\\(Press 'D-Pad Down' to Roll the Dice!)")
            dcbt = 1
        end
    end
    if dbg == 1 then
        timer = 0
    end

    reset_timer(gMarioStates[0])
    debug_fnc(gMarioStates[0])

    -- AlwaysCheck Functions
    if firet ~= 0 then
        fire_breath(m, fireb)
    end
    if sptimer ~= 0 then
        special_moves(gMarioStates[0])
        spsaid = 0
    end
    if spsaid == 0 and sptimer == 0 then
        djui_chat_message_create("\\#adadad\\(\\#fbffe0\\Special Move \\#adadad\\Disabled!)")
        spsaid = 1
    end
    if gravtimer ~= 0 then
        gravtimer = gravtimer - 1
        gravsaid = 0
        if gravtimer == 0 and gravsaid == 0 then
            djui_chat_message_create("\\#adadad\\(Your Gravity Modifier has been Disabled!)")
            gravsaid = 1
        end

    end
    if allergytmr ~= 0 then
        allergytmr = allergytmr - 1
        allergysaid = 0
        allergy_func()
        if allergytmr == 0 and allergysaid == 0 then
            djui_chat_message_create("You are no longer allergic to " .. allergy .. "\\#ffffff\\!")
            allergysaid = 1
            allergy = ""
        end
    end

end

--- @param m MarioState
function Overlay_Effects(m, eff)
    if eff == 0 then

    elseif eff == 1 then
        if m.action ~= ACT_FLAG_IDLE then
            m.health = m.health - 2
        else
            m.health = m.health - 4
        end
        if m.health < 250 then
            ovrtimer = 91
        end
    end


end

function allergy_func()
    if allergy == "\\#1854b5\\Water" then
        if (gMarioStates[0].action == 939532992 or gMarioStates[0].action == 805315794 or gMarioStates[0].action == 805315266 or gMarioStates[0].action == 805315809) then
            gMarioStates[0].health = 0
        end
    end
end

function achal_func(h)
    if gMarioStates[0].action == ACT_STAR_DANCE_EXIT or gMarioStates[0].action == ACT_STAR_DANCE_NO_EXIT or gMarioStates[0].action == ACT_STAR_DANCE_WATER then
        achal = 0
    end
end

--[[function ran_timer_fcn(eff)
    if eff == "sleep" then
        set_mario_action(m, ACT_SLEEPING, 0) 
        if rantimer > 0 then
            rantimer = rantimer - 1
        end
    end
end]]

function fulloverlay_disp(eff)
    -- render to native screen space
    djui_hud_set_resolution(RESOLUTION_DJUI)

    -- set location
    local x = 0
    local y = 0

    -- set width/height
    local w = 10000000
    local h = 10000000

    -- determine effect
    if eff == 0 then
        djui_hud_set_color(0, 0, 0, 200)
    elseif eff == 1 then
        djui_hud_set_color(120, 40, 0, 180)
    elseif eff == 2 then
        djui_hud_set_color(0, 255, 0, 95)
    elseif eff == 3 then
        djui_hud_set_color(0, 0, 100, 100)
    elseif eff == 4 then
        djui_hud_set_color(0, 0, 0, 0)
    end

    -- render effect
    djui_hud_render_rect(x, y, w, h)

    -- adjust location and size
    x = x + 16
    y = y + 16
    w = w - 32
    h = h - 32
end
function dbgtxt_txt(txt, r, g, b, fnt)
   -- set text and scale
   local text = txt
   local scale = 1
   if fnt == "" then
    fnt = FONT_MENU
   end


   -- render to native screen space, with the MENU font
   djui_hud_set_resolution(RESOLUTION_DJUI)
   djui_hud_set_font(fnt)

   -- get width of screen and text
   local screenWidth = djui_hud_get_screen_width()
   local width = djui_hud_measure_text(text) * scale

   -- get height of screen and text
   local screenHeight = djui_hud_get_screen_height()
   local height = 64 * scale

   -- set location
   local x = screenWidth - width
   local y = screenHeight - height

   -- set color and render
   djui_hud_set_color(r, g, b, 255)
   djui_hud_print_text(text, x, y, scale)
end

function txt_at(txt, r, g, b, xx, yy, sc, fnt)
    -- set text and scale
    local text = txt
    local scale = sc

    -- render to native screen space, with the MENU font
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(fnt)

    -- get width of screen and text
    local screenWidth = djui_hud_get_screen_width()
    local width = djui_hud_measure_text(text) * scale

    -- get height of screen and text
    local screenHeight = djui_hud_get_screen_height()
    local height = yy * scale

    -- set location
    local x = xx
    local y = yy

    -- set color and render
    djui_hud_set_color(r, g, b, 255)
    djui_hud_print_text(text, x, y, scale)

end


-- Extra Functions for Cleanup
--- @param m MarioState
function reset_timer(m)
    if (timer == 0 or timer < 1) then
        timer = 0
    end
    if (btTimer == 0 or btTimer < 1) then
        btTimer = 0
    end
end

function debug_fnc(m)
    if dbg == 1 or dbg == 31 or dbg == 51 then
        timer = 0
    end
    if dbg == 5 or dbg == 51 then
        m.health = 2048
    end
end

function button_func()
   if btTimer == 0 then
        if zbutton == 0 then
           zbutton = 1
           djui_chat_message_create("\\#ffffff\\Your \\#8433f5\\Z Button\\#ffffff\\ Has Been Enabled!")
        elseif abutton == 0 then
            abutton = 1
            djui_chat_message_create("\\#ffffff\\Your \\#2cf590\\A Button\\#ffffff\\ Has Been Enabled!")
        elseif bbutton == 0 then
            bbutton = 1
            djui_chat_message_create("\\#ffffff\\Your \\#6bc9b0\\B Button\\#ffffff\\ Has Been Enabled!")
        end
    end
end
function button1cl_func()
    if firet == 0 then
        if fireb == Z_TRIG and infire == 1 then
            djui_chat_message_create("\\#ffffff\\Your \\#8433f5\\Z Button\\#ffffff\\ Has Been \\#fa2828\\Unflamed\\#ffffff\\!")
        elseif fireb == A_BUTTON and infire == 1 then
        djui_chat_message_create("\\#ffffff\\Your \\#2cf590\\A Button\\#ffffff\\ Has Been \\#fa2828\\Unflamed\\#ffffff\\!")
        elseif fireb == B_BUTTON and infire == 1 then
        djui_chat_message_create("\\#ffffff\\Your \\#6bc9b0\\B Button\\#ffffff\\ Has Been \\#fa2828\\Unflamed\\#ffffff\\!")
        end
    end
end
--- @param m MarioState
function goomba_horde(num, m)
    if num < 1 then
        num = 1
    end
    m.invincTimer = 30
    repeat
        local o = spawn_sync_object(id_bhvGoomba, E_MODEL_GOOMBA, (m.pos.x + random_linear_offset(-60, 60)), m.pos.y, (m.pos.z + random_linear_offset(-60, 60)), nil)
        o.oIntangibleTimer = 2000
        num = num - 1
        if num < 1 then
            num = 0
        end
    until num == 0
    num = 0
end
function fire_breath(m, fireb)
    if not gMarioStates[0] then return end
    if m.controller.buttonPressed == fireb then
        local o = spawn_non_sync_object(id_bhvFlameLargeBurningOut, E_MODEL_RED_FLAME, m.pos.x, m.pos.y, m.pos.z, nil)
        o.oIntangibleTimer = -1
    end
end

function special_moves(m)
    if m.action == spmove then
        set_mario_action(m, sprep, 0)
    end
    if sptimer == 0 and spsaid == 1 then
        spsaid = 0
        djui_chat_message_create("\\#adadad\\(\\#fbffe0\\Special Move \\#adadad\\Disabled!)")

    elseif sptimer > 0 then
        spsaid = 1
    end



end


function save_func()
    mod_storage_save("autodice", tostring(autodice))
    mod_storage_save("dicerolled", tostring(dicerolled))
    mod_storage_save("coins", tostring(coinsgot))



    return true
end

-----------
-- HOOKS --
-----------

--hook_chat_command("dbg", "[Val|off]", dbg_cmd)
hook_chat_command("auto", "[On|Off]Rolls the Dice Automatically", auto_cmd)
--hook_chat_command("dice", "[val] Forces a specific event", frdice_cmd)
--hook_chat_command("cd", "[Num] Sets the Cooldown for the Dice \n(put in seconds, 0 = 1)", cd_cmd)
hook_chat_command("save", "Triggers the Save Early", save_cmd)
hook_chat_command("stats", "See your Stats 'WIP: See everyone's Stats in your lobby'.", stats_cmd)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, on_set_mario_action)
hook_event(HOOK_BEFORE_PHYS_STEP, before_phys_step)