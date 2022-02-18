function Init(abilityData)
	plugin.registerEvent(abilityData, "치료", "EntityDamageEvent", 24000)
end

function onEvent(funcTable)
	if funcTable[1] == "치료" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then gamble(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function gamble(LAPlayer, event, ability, id)
	if event:getDamager():getType():toString() == "PLAYER" and event:getEntity():getType():toString() == "PLAYER" then
		local item = event:getDamager():getInventory():getItemInMainHand()
		if game.isAbilityItem(item, "IRON_INGOT") then
			if game.checkCooldown(LAPlayer, game.getPlayer(event:getDamager()), ability, id) then
				util.runLater(function() game.changeAbility(game.getPlayer(event:getEntity()), ability, "LA-SCP-049-HIDDEN", true) end, 1)
				game.sendMessage(event:getEntity(), "§4역병 의사 §c에게 §4[치료]§c되었습니다.")
				event:getEntity():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getEntity():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
				event:getEntity():getWorld():playSound(event:getEntity():getLocation(), import("$.Sound").ENTITY_ZOMBIE_BREAK_WOODEN_DOOR, 1, 1)
				event:getEntity():getWorld():playSound(event:getEntity():getLocation(), import("$.Sound").ENTITY_ZOMBIE_AMBIENT, 1, 1)
			end
		end
	end
end