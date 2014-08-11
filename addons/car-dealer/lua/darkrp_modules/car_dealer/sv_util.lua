if not CarDealerShop then
	CarDealerShop = {}
end

function CarDealer.getCarDetails(type, id)
	for _, v in ipairs(CarDealer.cars[type].cars) do
		if v.id == id then
			return v
		end
	end
end

function CarDealer.spawnCar(ply, vehicle, noPocket, teams)	
	CarDealer.despawnCar(ply)

	local position = ply:GetPos() + ply:GetForward() * -150
	
	local ent = ents.Create(vehicle.Class)
	ent:SetModel(vehicle.Model)
	if vehicle.KeyValues then
		for k, v in pairs(vehicle.KeyValues) do
			ent:SetKeyValue(k, v)
		end
	end
	ent:SetPos(position)
	ent.VehicleName = vehicle.Name
	ent.VehicleTable = vehicle
	ent:Spawn()
	ent:Activate()
	ent.SID = ply.SID
	ent.Owner = ply
	ent.OwnerID = ply:SteamID()
	ent.ClassOverride = vehicle.Class
	if vehicle.Members then
		table.Merge(ent, vehicle.Members)
	end
	ent:CPPISetOwner(ply)
	ent:keysOwn(ply)
	ent:keysLock()
	
	--Custom
	if noPocket then
		ent.noPocket = noPocket
	end
	
	if teams then
		ent.allowedTeams = teams
	end
	
	ply.currentCar = ent
end

function CarDealer.despawnCar(ply)
	if IsValid(ply) then
		if ply.currentCar and IsValid(ply.currentCar) then
			-- TODO: Save customizations!
			ply.currentCar:Remove()
		end
		
		ply.currentCar = nil
	end
end