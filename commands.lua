-- Chat Commands
-- V1.1
--[[function dbg_cmd(msg)
    if not network_is_server() then
        djui_chat_message_create("You must be a Moderator to use this command!")
        return true
    end
    dbg = tonumber(msg)
    if tonumber(msg) then
         djui_chat_message_create("Debug set to:\\#1318ad\\ " .. tonumber(msg))
    elseif msg == "off" or msg == 0 then
         dbg = 0
         djui_chat_message_create("Disabled Debug.")
    else
         djui_chat_message_create("\\#d62727\\Invalid Value!\nOnly Numbers are Supported.")
    end
    return true
end]]

--[[function frdice_cmd(msg)
    if not network_is_server() then
        djui_chat_message_create("You must be a Moderator to use this command!")
        return true
    end
     if tonumber(msg) then
         roll_dice(gMarioStates[0], 1, tonumber(msg))
         return true
     else
         djui_chat_message_create("\\#d62727\\Invalid Value!\nOnly Numbers are Supported.")
     end
    return true
end]]

--[[function cd_cmd(num)
    if not network_is_moderator or not network_is_server() then
        djui_chat_message_create("You must be a Moderator to use this command!")
        return true
    end
    if num == "default" then
       num = 10000
    elseif tonumber(num) == 0 then
        num = 1
    elseif tonumber(num) then
        mxtimer = tonumber(num) * 500
        djui_chat_message_create("\\#757575\\Now players must wait \\#1318ad\\" .. (mxtimer / 500) .. "\\#757575\\ Seconds to roll the Dice\n(or " .. mxtimer .. " frames i think)")
    elseif num == "" then
        djui_chat_message_create("... Maybe put a Value here?")
    else
        djui_chat_message_create("\\#d62727\\Invalid Value!\nOnly Numbers are Supported.")
    end
    if timer > 0 then
        timer = mxtimer
    end
    djui_popup_create_global("\\#757575\\Dice Cooldown Now:\\#1318ad\\ " .. (mxtimer / 500) .. "\\#757575\\ Seconds.", 1)
    return true
end]]

function auto_cmd(msg)
    if tostring(msg) == "On" or tostring(msg) == "oN" or tostring(msg) == "on" then
        autodice = 1
        djui_chat_message_create("Rolling Dice Automatically")
    elseif tostring(msg) == "off" or tostring(msg) == "Off" or tostring(msg) == "OFf" or tostring(msg) == "OFF" or tostring(msg) == "OfF" then
        autodice = 0
        djui_chat_message_create("Not Rolling Dice Automatically anymore")
    else
        djui_chat_message_create("\\#8f1a1a\\Invalid Option")
    end

    return true
end

function stats_cmd()
    djui_chat_message_create("Your Stats:\nTimes you Rolled the Dice: " .. (tonumber(mod_storage_load("dicerolled")) or 0) .. "\nCoins The " .. dcn .. "\\#ffffff\\Gave You: " .. (tonumber(mod_storage_load("coins") or 0) .. ""))


    return true
end

function save_cmd()
    djui_popup_create("\\#bf8d04\\Game Saved!", 1)
    save_func()

    return true
end
