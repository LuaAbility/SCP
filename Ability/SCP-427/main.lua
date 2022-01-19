local attribute = import("$.attribute.Attribute")

function Init(abilityData)
	plugin.registerEvent(abilityData, "SCP427-heal", "PlayerInteractEvent", 1200)
end

function onEvent(funcTable)
	if funcTable[1] == "SCP427-heal" then heal(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	
	if player:getVariable("SCP427-count") == nil then 
		player:setVariable("SCP427-count", 0) 
		player:setVariable("SCP427-maxCount", util.random(5, 8)) 
	end
	
	local count = player:getVariable("SCP427-count")
	if count >= 7 then game.sendActionBarMessage(player:getPlayer(), "§a능력 사용 횟수 §6: §4" .. player:getVariable("SCP427-count") .. "회")
	elseif count >= 4 then game.sendActionBarMessage(player:getPlayer(), "§a능력 사용 횟수 §6: §c" .. player:getVariable("SCP427-count") .. "회")
	else game.sendActionBarMessage(player:getPlayer(), "§a능력 사용 횟수 §6: §b" .. player:getVariable("SCP427-count") .. "회") end
	player:getPlayer():setFoodLevel(10)
end

function heal(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			local maxHealth = event:getPlayer():getAttribute(attribute.GENERIC_MAX_HEALTH):getValue()
			if event:getPlayer():getHealth() < maxHealth then
				if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
					if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
						event:setCancelled(true)
						event:getPlayer():setHealth(maxHealth)
						LAPlayer:setVariable("SCP427-count", LAPlayer:getVariable("SCP427-count") + 1) 
						
						if LAPlayer:getVariable("SCP427-count") >= LAPlayer:getVariable("SCP427-maxCount") then
							event:getPlayer():setHealth(0)
							event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getPlayer():getLocation():add(0,1,0), 1000, 0.5, 1, 0.5, 0.9)
							event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").ENTITY_WITHER_DEATH, 0.5, 1.0)
							game.sendMessage(event:getPlayer(), "§4[§cSCP-427§4] §c능력 사용 횟수가 임계점에 도달하여 사망합니다.")
							LAPlayer:setVariable("SCP427-count", nil) 
						else
							event:getPlayer():getWorld():spawnParticle(import("$.Particle").VILLAGER_HAPPY, event:getPlayer():getLocation():add(0,1,0), 200, 0.5, 1, 0.5, 0.9)
							event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").ENTITY_PLAYER_LEVELUP, 0.5, 0.5)
						end
					end
				end
			end
		end
	end
end