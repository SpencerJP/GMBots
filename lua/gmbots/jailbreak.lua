--[[

	Hello! And welcome to the GMBots base!

	To see all the functions you can do, check the Wiki on GitHub.

	I have left messages that explains what does what.
		
		
	Github Wiki: https://github.com/Noobz4Life/GMBots/wiki
]]
print("DEBUG, remove print")
-- Enums
STATE_IDLE = 1 -- when the map loads, we wait for everyone to join
STATE_SETUP = 2 -- first few seconds of the round, when everyone can still spawn and damage is disabled
STATE_PLAYING = 3 -- normal playing
STATE_LASTREQUEST = 4 -- last request taking place, special rules apply
STATE_ENDED = 5 -- round ended, waiting for next round to start
STATE_MAPVOTE = 6 -- voting for a map, will result in either a new map loading or restarting the current without reloading
BOTNames = {"Splerge", "REL", "Freaky", "Lebofly", "Gregory", "Alfred", "Garry", "Lawrence"} -- This will set what the bots will be named, every bot has "BOT" before their name, so keep that in mind.
GMBots_Transmitter = nil
GMBots_CurrentWarden = nil
GMBots_HostilePlayers = {}

-- ent.GetRebel and ent:GetRebel()
net.Receive("JB.SendRoundUpdate", function()
    local _state_enum = net.ReadInt(8)
    local _rounds_passed = net.ReadInt(32)

    if _state_enum == STATE_SETUP then
        GMBots_HostilePlayers = {}
        GMBots_CurrentWarden = nil
    end
end)

function GetTransmitter()
    local getEnt = #ents.FindByClass("jb_transmitter_state")

    if getEnt == 1 then
        return ents.FindByClass("jb_transmitter_state")[1]
    else
        return nil
    end
end

hook.Add("WeaponEquip", "CheckIfPlayerIsInPossessionOfWeapon", function(weap, ply)
    if (weap ~= "weapon_jb_fists" and weap ~= "weapon_jb_knife") then
        GMBots_HostilePlayers[ply] = true
    end
end)

timer.Create("GMBots_Jailbreak", 1, 0, function()
    GMBots_Transmitter = GetTransmitter()
    print("test timer")

    if GMBots_Transmitter ~= nil then
        timer.Remove("GMBots_Jailbreak")
    end
end)

-- This hook gets ran when a bot is added, from bot quota or the gmbots_bot_add command.
hook.Add("GMBotsBotAdded", "GamemodeBotAdded", function(bot)
    if bot and bot:IsValid() then
        bot:SetTeam(TEAM_GUARD)
        bot.interestedInPlayer = nil
    end
end)

function GMBotsStart(ply, cmd)
    if not IsValid(JB:GetWarden()) then
        ply:Debug("wander")
        ply:BotWander(cmd)
    else
        local warden = JB:GetWarden()

        if ply:GetPos():Distance(warden:GetPos()) >= 300 then
            ply:Debug("follow")
            ply:BotFollow(cmd, JB:GetWarden())
        else
            local randNum = math.Rand(1, 100)

            if (randNum == 10) then
                ply.interestedInPlayer = player.GetAll()[math.Rand(1, #player.GetAll())]
            else
                if (randNum > 95) then
                    ply:QuickWander(cmd)
                elseif (interestedInPlayer) then
                    ply:LookAtEntity(interestedInPlayer)
                end
            end
        end

        ply:Debug("don't follow")
    end
end

hook.Add("GMBotsStart", "GMBotsStart", GMBotsStart) -- This hook is basically StartCommand, but it checks if the player is a bot for you, and also handles errors.