local effect = import("$.potion.PotionEffectType")

function Init(abilityData)
	plugin.registerEvent(abilityData, "SCP173-cancelMove1", "PlayerMoveEvent", 0)
	plugin.registerEvent(abilityData, "SCP173-cancelMove2", "VehicleMoveEvent", 0)
	plugin.registerEvent(abilityData, "SCP173-cancelOrKill", "EntityDamageEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "SCP173-cancelMove1" then cancelMove1(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "SCP173-cancelMove2" then cancelMove2(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "SCP173-cancelOrKill" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then cancelOrKill(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("SCP173-canMove") == nil then 
		player:setVariable("SCP173-canMove", true)
	end
	
	seeCheck(player)
	addEffect(player)
end

function seeCheck(player)
	local players = util.getTableFromList(game.getPlayers())
	
	player:setVariable("SCP173-canMove", true)
	for i = 1, #players do
		if getLookingAt(players[i]:getPlayer(), player:getPlayer()) and game.targetPlayer(player, players[i], false) then player:setVariable("SCP173-canMove", false) end
	end
end

function addEffect(player)
	player:getPlayer():addPotionEffect(newInstance("$.potion.PotionEffect", {effect.SPEED, 10, 1}))
end

function cancelMove1(LAPlayer, event, ability, id)
	if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
		if game.getPlayer(event:getPlayer()):getVariable("SCP173-canMove") == false then
			event:setCancelled(true)
		end
	end
end

function cancelMove2(LAPlayer, event, ability, id)
	local passengers = util.getTableFromList(event:getVehicle():getPassengers())
	for i = 1, #passengers do
		if passengers[i]:getType():toString() == "PLAYER" then
			if game.checkCooldown(LAPlayer, game.getPlayer(passengers[i]), ability, id) then
				if game.getPlayer(passengers[i]):getVariable("SCP173-canMove") == false then
					event:getVehicle():removePassenger(passengers[i])
				end
			end
		end
	end
end

function cancelOrKill(LAPlayer, event, ability, id)
	if event:getDamager():getType():toString() == "PLAYER" and event:getEntity():getType():toString() == "PLAYER" then
		if game.checkCooldown(LAPlayer, game.getPlayer(event:getDamager()), ability, id) then
			if game.getPlayer(event:getDamager()):getVariable("SCP173-canMove") == false then event:setCancelled(true)
			elseif game.targetPlayer(LAPlayer, game.getPlayer(event:getEntity())) then event:setDamage(9999999) end
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