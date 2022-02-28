function Init(abilityData) end

function onTimer(player, ability) 
	
	if player:getVariable("SCP507-passiveCount") == nil then 
		player:setVariable("SCP507-passiveCount", 0) 
		player:setVariable("SCP507-randomPassive", util.random(400, 1200)) 
	end
	local count = player:getVariable("SCP507-passiveCount")
	local maxCount = player:getVariable("SCP507-randomPassive")
	if count >= maxCount then 
		count = 0
		shuffle(player)
		player:setVariable("SCP507-randomPassive", util.random(400, 1200)) 
	end
	count = count + 2
	player:setVariable("SCP507-passiveCount", count)
end

function shuffle(player) 
	local players = util.getTableFromList(game.getPlayers())
	
	for i = 1, 100 do
		
		local randomIndex = util.random(1, #players)
		local temp = players[randomIndex]
		players[randomIndex] = players[1]
		players[1] = temp
	end
	
	for i = 1, #players do
		if players[i] ~= player then
			local loc = players[i]:getPlayer():getLocation():add(util.random(-10, 10), 0, util.random(-10, 10))
			if checkMat(loc:getWorld():getBlockAt(loc:add(0, 1, 0)):getType()) or checkMat(loc:getWorld():getBlockAt(loc:add(0, 2, 0)):getType()) then
				loc:setY(loc:getWorld():getHighestBlockYAt(loc:getX(), loc:getZ()))
			end
			
			game.sendMessage(player:getPlayer(), "§2[§aSCP-507§2] §a무작위 위치로 이동합니다.")
			player:getPlayer():teleport(loc)
			return 0
		end
	end
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