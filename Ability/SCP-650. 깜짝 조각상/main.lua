local material = import("$.Material")

function Init(abilityData)
	plugin.registerEvent(abilityData, "깜짝 이동", "PlayerInteractEvent", 200)
end

function onEvent(funcTable)
	if funcTable[1] == "깜짝 이동" then seeCheck(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function seeCheck(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					local players = util.getTableFromList(game.getPlayers())
					
					for i = 1, #players do
						if getLookingAt(event:getPlayer(), players[i]:getPlayer(), 0.98) then
							if not game.targetPlayer(LAPlayer, players[i]) then ability:resetCooldown(id) return 0 end
							if teleportToBack(players[i]:getPlayer(), event:getPlayer()) then return 0
							else game.sendMessage(event:getPlayer(), "§4[§cSCP-650§4] §c플레이어 뒤에 블럭이 있어 이동 할 수 없습니다.") end
						end
					end
					
					ability:resetCooldown(id)
				end
			end
		end
	end
end

function teleportToBack(target, player)
	local targetLoc = target:getLocation()
	targetLoc:setPitch(0)
	
	local startDir = targetLoc:getDirection():setY(0):normalize()
	local horizonOffset = newInstance("$.util.Vector", {startDir:getZ() * -1, 0, startDir:getX()}):normalize()
	targetLoc:add(targetLoc:getDirection():setY(0):multiply(-1))
		
	if checkMat(targetLoc:getWorld():getBlockAt(targetLoc):getType()) or checkMat(targetLoc:getWorld():getBlockAt(targetLoc:add(0, 1, 0)):getType()) then 
		return false 
	end
	
	player:teleport(targetLoc:add(0, -1, 0))
	return true 
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

function checkMat(mat)
	local name = mat:toString()
	if string.find(name, "SIGN") 			~= nil 	then return false end
	if string.find(name, "CARPET") 			~= nil 	then return false end
	if string.find(name, "PRESSURE_PLATE") 	~= nil 	then return false end
	if string.find(name, "BUTTON") 			~= nil 	then return false end
	if string.find(name, "TULIP") 			~= nil 	then return false end
	if string.find(name, "SAPLING") 		~= nil 	then return false end
	if string.find(name, "FAN") 			~= nil 	then return false end
	if string.find(name, "CORAL") 			~= nil 	then return false end
	if string.find(name, "SIGN") 			~= nil 	then return false end
	if string.find(name, "RAIL") 			~= nil 	then return false end
	if string.find(name, "_AIR") 			~= nil 	then return false end
	if string.find(name, "FLOWER") 			~= nil 	then return false end
	if string.find(name, "SLAB") 			~= nil 	then return false end
	if string.find(name, "STAIRS") 			~= nil 	then return false end
	if string.find(name, "FUNGUS") 			~= nil 	then return false end
	if string.find(name, "ROOTS") 			~= nil 	then return false end
	if string.find(name, "VINE") 			~= nil 	then return false end
	if string.find(name, "TORCH") 			~= nil 	then return false end
	if string.find(name, "SKULL") 			~= nil 	then return false end
	if string.find(name, "HEAD") 			~= nil 	then return false end
	if string.find(name, "BANNER") 			~= nil 	then return false end
	if string.find(name, "LANTERN") 		~= nil 	then return false end
	if string.find(name, "AMETHYST") 		~= nil 	then return false end
	if string.find(name, "CANDLE") 			~= nil 	then return false end
	if string.find(name, "CAMPFIRE") 		~= nil 	then return false end
	if string.find(name, "WIRE") 			~= nil 	then return false end
	if string.find(name, "DAILYLIGHT") 		~= nil 	then return false end
	if string.find(name, "DOOR") 			~= nil 	then return false end
	if name == "COBWEB" 							then return false end
	if name == "REPEATER" 							then return false end
	if name == "COMPARATOR" 						then return false end
	if name == "STONECUTTER" 						then return false end
	if name == "SCAFFOLDING" 						then return false end
	if name == "GLOW_LICHEN" 						then return false end
	if name == "NETHER_SPROUTS" 					then return false end
	if name == "LILY_OF_THE_VALLEY" 				then return false end
	if name == "SEA_PICKLE" 						then return false end
	if name == "AIR" 								then return false end
	if name == "DIRT_PATH" 							then return false end
	if name == "WATER"								then return false end
	if name == "LAVA" 								then return false end
	if name == "TALL_GRASS" 						then return false end
	if name == "LARGE_FERN" 						then return false end
	if name == "GRASS" 								then return false end
	if name == "DEAD_BUSH" 							then return false end
	if name == "FERN" 								then return false end
	if name == "SEAGRASS" 							then return false end
	if name == "TALL_SEAGRASS" 						then return false end
	if name == "LILY_PAD" 							then return false end
	if name == "DANDELION" 							then return false end
	if name == "POPPY" 								then return false end
	if name == "BLUE_ORCHID" 						then return false end
	if name == "ALLIUM" 							then return false end
	if name == "AZURE_BLUET" 						then return false end
	if name == "OXEYE_DAISY" 						then return false end
	if name == "LILAC" 								then return false end
	if name == "PEONY" 								then return false end
	if name == "ROSE_BUSH" 							then return false end
	if name == "BROWN_MUSHROOM" 					then return false end
	if name == "RED_MUSHROOM" 						then return false end
	if name == "FIRE" 								then return false end
	if name == "WHEAT" 								then return false end
	if name == "LADDER" 							then return false end
	if name == "LEVER" 								then return false end
	if name == "SNOW" 								then return false end
	if name == "SUGAR_CANE" 						then return false end
	if name == "NETHER_WART" 						then return false end
	return true
end