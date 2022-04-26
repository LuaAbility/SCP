function Init(abilityData)
	plugin.registerEvent(abilityData, "능력 봉인", "PlayerInteractEvent", 2400)
end

function onEvent(funcTable)
	if funcTable[1] == "능력 봉인" then enableAbility(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("SCP055-useAbility") == nil then 
		player:setVariable("SCP055-useAbility", 0)
	end
	
	local count = player:getVariable("SCP055-useAbility")
	if count > 0 then 
		seeCheck(player) 
		count = count - 1
		if count <= 0 then unlockAbility(player) end
	end
	player:setVariable("SCP055-useAbility", count)
end

function Reset(player, ability)
	if player:getVariable("SCP055-useAbility") ~= nil and player:getVariable("SCP055-useAbility") > 0 then unlockAbility(player) end
	game.sendActionBarMessageToAll("SCP055", "")
end

function seeCheck(player)
	local players = util.getTableFromList(game.getTeamManager():getOpponentTeam(player, false))
	
	for i = 1, #players do
		if getLookingAt(players[i]:getPlayer(), player:getPlayer()) and game.targetPlayer(player, players[i], false) then 
			players[i]:setVariable("abilityLock", true) 
			game.sendActionBarMessage(players[i]:getPlayer(), "SCP055", "§c능력 봉인됨!")
		else 
			players[i]:setVariable("abilityLock", false)
			game.sendActionBarMessage(players[i]:getPlayer(), "SCP055", "")			
		end
	end
end

function unlockAbility(player)
	game.sendMessage(player:getPlayer(), "§2[§aSCP-055§2] §a능력 시전 시간이 종료되었습니다. (능력 봉인)")
	player:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_LARGE, player:getPlayer():getLocation():add(0,1,0), 100, 0.5, 1, 0.5, 0.2)
	player:getPlayer():getWorld():playSound(player:getPlayer():getLocation(), import("$.Sound").BLOCK_BEACON_ACTIVATE, 0.5, 1)
	local players = util.getTableFromList(game.getTeamManager():getOpponentTeam(player, false))
	for i = 1, #players do
		players[i]:removeVariable("abilityLock")
	end
	
	game.sendActionBarMessageToAll("SCP055", "")
end

function enableAbility(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getPlayer():getInventory():getItemInMainHand() ~= nil then
			if game.isAbilityItem(event:getPlayer():getInventory():getItemInMainHand(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					LAPlayer:setVariable("SCP055-useAbility", 600)
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_LARGE, event:getPlayer():getLocation():add(0,1,0), 100, 0.5, 1, 0.5, 0.2)
					event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").BLOCK_BEACON_DEACTIVATE, 2, 1)
				end
			end
		end
	end
end

function getLookingAt(player, player1)
	local eye = player:getEyeLocation()
	local toEntity = player1:getEyeLocation():toVector():subtract(eye:toVector())
	local dot = toEntity:normalize():dot(eye:getDirection())
	
	if player:getWorld():getEnvironment() ~= player1:getWorld():getEnvironment() then dot = 0
	elseif player:getPlayer():getLocation():distance(player1:getLocation()) > 40 then dot = 0 end

	if not player:hasLineOfSight(player1) then dot = 0 end
	
	return dot > 0.6
end