local effect = import("$.potion.PotionEffectType")

function Init(abilityData)
	plugin.registerEvent(abilityData, "SCP096-addDamage", "EntityDamageEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "SCP096-addDamage" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then addDamage(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("SCP096-passiveCount") == nil then 
		player:setVariable("SCP096-passiveCount", 0)
		player:setVariable("SCP096-targetPlayerName", "")
	end
	
	local count = player:getVariable("SCP096-passiveCount")
	
	if player:getVariable("SCP096-targetPlayerName") ~= nil and player:getVariable("SCP096-targetPlayerName") ~= "" then 
		game.sendActionBarMessage(player:getPlayer(), "SCP096", "§c타겟 : " .. player:getVariable("SCP096-targetPlayerName") .. " §f/ §a남은 시간 : " .. math.floor(count / 20 + 0.5) .. "초")
		player:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, player:getPlayer():getLocation():add(0,1,0), 20, 0.25, 0.7, 0.25, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
	end
	if count <= 0 then 
		game.sendActionBarMessage(player:getPlayer(), "SCP096", "")
		seeCheck(player) 
	else 
		count = count - 1 
		if count <= 0 then game.sendMessage(player:getPlayer(), "§2[§aSCP-096§2] §a타겟 플레이어가 리셋됩니다.") end
		player:setVariable("SCP096-passiveCount", count) 
	end
end

function Reset(player, ability)
	game.sendActionBarMessageToAll("SCP096", "")
end

function seeCheck(player)
	local players = util.getTableFromList(game.getTeamManager():getOpponentTeam(player, false))
	
	player:setVariable("SCP096-targetPlayerName", nil)
	for i = 1, #players do
		if getLookingAt(players[i]:getPlayer(), player:getPlayer(), 0.75) and getLookingAt(player:getPlayer(), players[i]:getPlayer(), 0.75) and game.targetPlayer(player, players[i], false)  then
			player:setVariable("SCP096-passiveCount", 600)
			player:setVariable("SCP096-targetPlayerName", players[i]:getPlayer():getName())
			game.sendMessage(player:getPlayer(), "§2[§aSCP-096§2] §a타겟 플레이어가 §2" .. players[i]:getPlayer():getName() .. "§a님으로 설정되었습니다.")
			game.sendMessage(players[i]:getPlayer(), "§cSCP-096의 얼굴을 보았습니다!")
			players[i]:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").ENTITY_GHAST_HURT, 0.5, 0.6)
			return 0
		end
	end
end

function addDamage(LAPlayer, event, ability, id)
	if event:getDamager():getType():toString() == "PLAYER" and event:getEntity():getType():toString() == "PLAYER" then
		if game.checkCooldown(LAPlayer, game.getPlayer(event:getDamager()), ability, id) then
			if LAPlayer:getVariable("SCP096-targetPlayerName") == event:getEntity():getName() then 
				event:setDamage(event:getDamage() * 1.5)
				event:getEntity():getWorld():playSound(event:getEntity():getLocation(), import("$.Sound").ENTITY_GHAST_WARN, 0.1, 0.1)
			end
		end
	end
end

function getLookingAt(player, player1, checkDouble)
	local eye = player:getEyeLocation()
	local toEntity = player1:getEyeLocation():toVector():subtract(eye:toVector())
	local dot = toEntity:normalize():dot(eye:getDirection())
	
	if player:getWorld():getEnvironment() ~= player1:getWorld():getEnvironment() then dot = 0
	elseif player:getPlayer():getLocation():distance(player1:getLocation()) > 40 then dot = 0 end

	if not player:hasLineOfSight(player1) then dot = 0 end
	
	return dot > checkDouble
end