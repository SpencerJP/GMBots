hook.Add("StartCommand","GMBots_CustomHookBotStart",function(bot,cmd)
	if bot and bot.Bot and cmd then
		local success,err = pcall(function()
			cmd:ClearButtons()
			hook.Run( "GMBotsStart",bot,cmd )
		end)
		if not success then bot:Error(err) end
	end
end)