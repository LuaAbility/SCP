function Init(abilityData) end

function onTimer(player, ability)
	if player:getVariable("SCP451-passiveCount") == nil then 
		player:setVariable("SCP451-passiveCount", 0)
		invisible(player, true)
	end
end

function Reset(player, ability)
	invisible(player, false)
end

function invisible(player, enable)
	local players = util.getTableFromList(game.getAllPlayers())
	for i = 1, #players do
		if players[i] ~= player then
			if enable and game.targetPlayer(player, players[i], false) then player:getPlayer():hidePlayer(plugin.getPlugin(), players[i]:getPlayer())
			else player:getPlayer():showPlayer(plugin.getPlugin(), players[i]:getPlayer()) end
		end
	end
end