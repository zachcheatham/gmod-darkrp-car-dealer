if not CarDealerShop then
	CarDealerShop = {}
end

function CarDealer.spawnCar(ply, type, id, vehicle, noPocket, teams, addon)
	if addon then
		CarDealer.despawnCarAddon(ply)
	else
		CarDealer.despawnCar(ply)
	end

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
	
	
	--Custom
	ent.carDealerCar = true
	ent.carDealerType = type
	ent.carDealerCarID = id
	if noPocket then
		ent.noPocket = noPocket
	end
	
	if teams then
		ent.allowedTeams = teams
	end
	
	if addon then
		ply.currentCarAddon = ent
	else
		ply.currentCar = ent
	end
	
	-- Lock the car last cause been noticing bugs
	ent:keysOwn(ply)
	ent:keysLock()
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

function CarDealer.despawnCarAddon(ply)
	if IsValid(ply) then
		if ply.currentCarAddon and IsValid(ply.currentCarAddon) then
			ply.currentCarAddon:Remove()
		end
		
		ply.currentCarAddon = nil
	end
end

function CarDealer.destroyCar(ent)
	if IsValid(ent) and ent.carDealerCar then		
		local ply = ent.Owner
		local steamID = ent.OwnerID
		local id = ent.carDealerCarID
		local type = ent.carDealerType

		table.RemoveByValue(CarDealer.inventory[steamID][type], id)
		CarDealer.saveInventory(steamID)
		
		if IsValid(ply) then
			DarkRP.notify(ply, 1, 4, "Your " .. ent.VehicleName .. " has been destroyed!")
		end
	end
end