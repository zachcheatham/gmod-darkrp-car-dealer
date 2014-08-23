local function loadNPCs()
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
			if string.sub(ent:GetClass(), 1, 10) == "car_dealer" then
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
concommand.Add("cardealer_savepos", saveLocations)