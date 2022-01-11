function Init(abilityData) end

function onTimer(player, ability) 
	if player:getVariable("SCP507-passiveCount") == nil then 
		player:setVariable("SCP507-passiveCount", 0) 
		player:setVariable("SCP507-randomPassive", math.random(1200, 6000)) 
	end
	local count = player:getVariable("SCP507-passiveCount")
	local maxCount = player:getVariable("SCP507-randomPassive")
	if count >= maxCount then 
		count = 0
		shuffle(player)
		player:setVariable("SCP507-randomPassive", math.random(1200, 6000)) 
	end
	count = count + 2
	player:setVariable("SCP507-passiveCount", count)
end

function shuffle(player) 
	local players = util.getTableFromList(game.getPlayers())

	for i = 1, 100 do
		local randomIndex = math.random(1, #players)
		local temp = players[randomIndex]
		players[randomIndex] = players[1]
		players[1] = temp
	end
	
	for i = 1, #players do
		if players[i] ~= player then
			local loc = players[i]:getPlayer():getLocation():add(math.random(-10, 10), 0, math.random(-10, 10))
			if loc:getWorld():getBlockAt(loc:getX(), loc:getY() + 1, loc:getZ()):getType():toString() ~= "AIR" or
			loc:getWorld():getBlockAt(loc:getX(), loc:getY() + 2, loc:getZ()):getType():toString() ~= "AIR" then
				loc:setY(loc:getWorld():getHighestBlockYAt(loc:getX(), loc:getZ()))
			end
			
			game.sendMessage(player:getPlayer(), "§2[§aSCP-507§2] §a무작위 위치로 이동합니다.")
			player:getPlayer():teleport(loc)
			return 0
		end
	end
end