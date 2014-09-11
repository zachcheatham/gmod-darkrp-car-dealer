--[[local function loadNPCs()
	if file.Exists("car_dealer/npc_positions.txt", "DATA") then

		local positions = util.JSONToTable(file.Read("car_dealer/npc_positions.txt", "DATA"))
		
		for _, data in ipairs(positions) do
			local ent = ents.Create(data.class)
			ent:SetPos(Vector(data.pos.x, data.pos.y, data.pos.z))
			ent:SetAngles(Angle(data.angles.pitch, data.angles.yaw, data.angles.roll))
			ent:Spawn()
			ent:PhysWake()
		end
	end
	
	CarDealer.npcsLoaded = true
end
hook.Add("InitPostEntity", "CarDealer_SpawnNPC", loadNPCs)
concommand.Add("cardealer_load", loadNPCs)

local function saveLocations(ply)
	if not ply:IsSuperAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE, "You are not a superadmin.")
	else
		local saveTable = {}
		for _, ent in ipairs(ents.GetAll()) do
			if string.sub(ent:GetClass(), 1, 10) == "car_dealer" or ent:GetClass() == "chopshop_employee" then
				local position = ent:GetPos()
				local angles = ent:GetAngles()
			
				local data = {}
				data.class = ent:GetClass()
				data.pos = {x=position.x, y=position.y, z=position.z}
				data.angles = {pitch=angles.pitch, yaw=angles.yaw, roll=angles.roll}
				
				table.insert(saveTable, data)
			end
		end
		
		if table.Count(saveTable) > 0 then
			file.Write("car_dealer/npc_positions.txt", util.TableToJSON(saveTable))
		else
			file.Delete("car_dealer/npc_positions.txt")
		end
	
		ply:PrintMessage(HUD_PRINTCONSOLE, "Saved car dealer positions!")
	end
end
concommand.Add("cardealer_savepos", saveLocations)]]--

local npcData = false
local nextNPCID = 0

local function loadData()
	if file.Exists("car_dealer/" .. game.GetMap() .. "_npc_data.txt", "DATA") then
		npcData = util.JSONToTable(file.Read("car_dealer/" .. game.GetMap() .. "_npc_data.txt", "DATA"))
	else
		ServerLog("[Car Dealer] No NPC data for this map found. NPCs will not be loaded.")
	end
end
loadData()

local function saveData()
	if npcData then
		file.Write("car_dealer/" .. game.GetMap() .. "_npc_data.txt", util.TableToJSON(npcData))
	else
		file.Delete("car_dealer/" .. game.GetMap() .. "_npc_data.txt")
	end
end

local function respawnNPCs(ply)
	if not ply or ply:IsSuperAdmin() then
		for _, ent in ipairs(ents.FindByClass("car_dealer")) do
			ent:Remove()
		end
		
		for _, ent in ipairs(ents.FindByClass("chopshop_employee")) do
			ent:Remove()
		end
	
		if npcData and npcData.dealers then
			for id, npc in pairs(npcData.dealers) do
				local ent = ents.Create("car_dealer")
				
				ent.carDealerType = npc.type
				ent.carDealerID = id
				
				if nextNPCID >= id then
					nextNPCID = id + 1
				end
				
				if npc.spawnLocations then
					ent.carDealerSpawnPoints = npc.spawnLocations
				end
				
				ent:SetPos(npc.position)
				ent:SetAngles(npc.angles)
				ent:Spawn()
				ent:PhysWake()
			end
		end
		
		if npcData and npcData.chopshops then
			for _, npc in ipairs(npcData.chopshops) do
				local ent = ents.Create("chopshop_employee")
				ent:SetPos(npc.position)
				ent:SetAngles(npc.angles)
				ent:Spawn()
				ent:PhysWake()
			end
		end
	end
end
hook.Add("InitPostEntity", "CarDealer_SpawnNPC", respawnNPCs)
concommand.Add("cardealer_respawnnpcs", respawnNPCs)

local function createNPC(ply, cmd, args)
	if ply:IsSuperAdmin() then
		if table.Count(args) > 0 then
			local trace = ply:GetEyeTrace()

			if trace.HitWorld then
				local position = trace.HitPos
				local angles = ply:GetAngles() + Angle(0, -180, 0)
				angles:Normalize()
				local id = nextNPCID
				
				nextNPCID = nextNPCID + 1
				
				if not npcData then
					npcData = {}
				end
				
				if not npcData.dealers then
					npcData.dealers = {}
				end
				
				npcData.dealers[id] = {type = args[1], position = position, angles = angles}
				saveData()
			
				local ent = ents.Create("car_dealer")
				ent.carDealerType = args[1]
				ent.carDealerID = id

				ent:SetPos(position)
				ent:SetAngles(angles)
				ent:Spawn()
				ent:PhysWake()
				
				ply:ChatPrint("Created Car Dealer with the type \"" .. ent.carDealerType .. "\" and an id of " .. ent.carDealerID .. ".")
			else
				ply:ChatPrint("Please aim at the world.")
			end
		else
			ply:ChatPrint("You must specify a Car Dealer type.")
		end
	end
end
concommand.Add("cardealer_createnpc", createNPC)

local function removeNPC(ply, cmd, args)
	if ply:IsSuperAdmin() then
		if table.Count(args) > 0 then
			local id = tonumber(args[1])
			
			for _, ent in ipairs(ents.FindByClass("car_dealer")) do
				if ent.carDealerID == id then
					ent:Remove()
				end
			end
			
			ply:ChatPrint("Car Dealer removed.")
		else
			ply:ChatPrint("Please specify the Car Dealer ID!")		
		end
	end
end
concommand.Add("cardealer_removenpc", removeNPC)

local function createSpawnPoint(ply, cmd, args)
	if ply:IsSuperAdmin() then
		if table.Count(args) > 0 then
			local id = tonumber(args[1])	
			local npc = false
			
			for _, ent in ipairs(ents.FindByClass("car_dealer")) do
				if ent.carDealerID == id then
					npc = ent
				end
			end
			
			if npc then			
				local trace = ply:GetEyeTrace()
				
				if trace.HitWorld then
					local position = trace.HitPos
					local angle = ply:GetAngles():SnapTo("y", 90)
					angle = Angle(0, angle.y - 90, 0)
					angle:Normalize()

					local spawnPoint = {position = position, angle = angle}
					
					if not npcData.dealers[id].spawnLocations then
						npcData.dealers[id].spawnLocations = {}
					end
					table.insert(npcData.dealers[id].spawnLocations, spawnPoint)
					saveData()
					
					if not npc.carDealerSpawnPoints then
						npc.carDealerSpawnPoints = {}
					end
					table.insert(npc.carDealerSpawnPoints, spawnPoint)
					
					ply:ChatPrint("Created vehicle spawn point for Car Dealer id " .. id .. ".")
				else
					ply:ChatPrint("Please aim at the world.")
				end
			else
				ply:ChatPrint("There is no Car Dealer with the id " .. id .. "!")	
			end
		else
			ply:ChatPrint("Please specify the Car Dealer ID!")	
		end
	end
end
concommand.Add("cardealer_createspawnpoint", createSpawnPoint)

local function createChopNPC(ply, cmd, args)
	if ply:IsSuperAdmin() then
		local trace = ply:GetEyeTrace()

		if trace.HitWorld then
			local position = trace.HitPos
			local angles = ply:GetAngles() + Angle(0, -180, 0)
			angles:Normalize()
			
			if not npcData then
				npcData = {}
			end
			
			if not npcData.chopshops then
				npcData.chopshops = {}
			end
			
			table.insert(npcData.chopshops, {position = position, angles = angles})
			saveData()
		
			local ent = ents.Create("chopshop_employee")
			ent:SetPos(position)
			ent:SetAngles(angles)
			ent:Spawn()
			ent:PhysWake()
			
			ply:ChatPrint("Created Chop Shop Employee.")
		else
			ply:ChatPrint("Please aim at the world.")
		end
	end
end
concommand.Add("cardealer_createchopnpc", createChopNPC)