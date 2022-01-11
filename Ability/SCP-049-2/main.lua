function Init(abilityData)
	plugin.registerEvent(abilityData, "SCP049-cancelDamage", "EntityDamageEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "SCP049-cancelDamage" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then cancelDamage(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function cancelDamage(LAPlayer, event, ability, id)
	if event:getDamager():getType():toString() == "PLAYER" and event:getEntity():getType():toString() == "PLAYER" then
		if game.hasAbility(game.getPlayer(event:getEntity()), "LA-SCP-049") then
			if game.checkCooldown(LAPlayer, game.getPlayer(event:getDamager()), ability, id) then
				event:setCancelled(true)
			end
		end
	end
end