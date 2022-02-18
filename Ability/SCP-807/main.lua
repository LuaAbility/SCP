local material = import("$.Material")
local effect = import("$.potion.PotionEffectType")

function Init(abilityData)
	plugin.registerEvent(abilityData, "SCP807-panelty", "PlayerItemConsumeEvent", 0)
	plugin.registerEvent(abilityData, "아이템 변환", "PlayerInteractEvent", 600)
end

function onEvent(funcTable)
	if funcTable[1] == "아이템 변환" then reinforce(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "SCP807-panelty" then panelty(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function reinforce(LAPlayer, event, ability, id)
	if event:getAction():toString() == "LEFT_CLICK_AIR" or event:getAction():toString() == "LEFT_CLICK_BLOCK" then
		if event:getPlayer():getInventory():getItemInMainHand() ~= nil then
			if game.isAbilityItem(event:getPlayer():getInventory():getItemInMainHand(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					local targetItem = event:getPlayer():getInventory():getItemInOffHand()
					if targetItem ~= nil and targetItem:getType():toString() ~= "AIR" then
						if string.find(targetItem:getItemMeta():getDisplayName(), "맛있는 황금사과") == nil then
							targetItem:setType(material.ENCHANTED_GOLDEN_APPLE)
							targetItem:setAmount(1)
							local itemMeta = targetItem:getItemMeta()
							
							itemMeta:setDisplayName("§6맛있는 황금사과")
							local lore = newInstance("java.util.ArrayList", {})
							lore:add("§7매우 맛있어 보인다.")
							itemMeta:setLore( lore )
							
							targetItem:setItemMeta(itemMeta)
							event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_LARGE, event:getPlayer():getLocation():add(0,1,0), 100, 0.5, 1, 0.5, 0.2)
							event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").ENTITY_SHULKER_BULLET_HURT, 0.5, 1.2)
						else game.sendMessage(event:getPlayer(), "§4[§cSCP-807§4] §c이미 특수한 황금사과로 만든 상태입니다.") ability:resetCooldown(id) end
					else game.sendMessage(event:getPlayer(), "§4[§cSCP-807§4] §c왼손에 아이템이 없습니다.") ability:resetCooldown(id) end
				end
			end
		end
	end
end

function panelty(LAPlayer, event, ability, id)
	if string.find(event:getItem():getItemMeta():getDisplayName(), "맛있는 황금사과") ~= nil then
		game.sendMessage(event:getPlayer(), "§a음~ 맛있다!")
		util.runLater(function() 
			event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_LARGE, event:getPlayer():getLocation():add(0,1,0), 100, 0.5, 1, 0.5, 0.2)
			event:getPlayer():addPotionEffect(newInstance("$.potion.PotionEffect", {effect.WITHER, 600, 9}))
		end, 400)
	end
end