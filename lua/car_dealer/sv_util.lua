if not CarDealerShop then
	CarDealerShop = {}
end

------------------
-- CAR SPAWNING --
------------------

function CarDealer.spawnCar(ply, npc, id, car, vehicle)
	if car.addon then
		CarDealer.despawnCarAddon(ply)
	else
		CarDealer.despawnCar(ply)
	end

	local position = Vector(0,0,0)
	local angle = Angle(0,0,0)
		
	if npc.carDealerSpawnPoints then
		local spawnPoint, id = table.Copy(table.Random(npc.carDealerSpawnPoints))
		position = spawnPoint.position + Vector(0, 0, 100)
		angle = spawnPoint.angle
	else
		position = ply:GetPos() + ply:GetForward() * -150
	end
		
	local ent = ents.Create(vehicle.Class)
	ent:SetModel(vehicle.Model)
	if vehicle.KeyValues then
		for k, v in pairs(vehicle.KeyValues) do
			ent:SetKeyValue(k, v)
		end
	end
	
	ent:SetPos(position)
	ent:SetAngles(angle)
	ent.VehicleName = id
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
	ent.carDealerType = npc.carDealerType
	ent.carDealerCarID = id
	
	local noPocket = car.noInventory or CarDealer.cars[npc.carDealerType].noInventory
	if noPocket == true then
		ent.noPocket = noPocket
	end
	
	local teams = car.allowedTeams or CarDealer.cars[npc.carDealerType].teams
	if teams then
		ent.allowedTeams = teams
	end
	
	if car.addon then
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
			if not ply.currentCar.noPocket then
				CarDealer.saveCustomizations(ply, ply.currentCar)
			end
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

------------------
-- SHOP HELPERS --
------------------
function CarDealer.ownsVehicle(ply, type, id)
	if not CarDealer.inventory[ply:SteamID()] then
		return false
	end
	
	if not CarDealer.inventory[ply:SteamID()][type] then
		return false
	end
		
	return (CarDealer.inventory[ply:SteamID()][type][id] ~= nil)
end

----------------------
-- DISTANCE HELPERS --
----------------------

function CarDealer.isCarNearEntity(ent, vehicle)
	return (ent:GetPos():Distance(vehicle:GetPos()) < 500)
end

function CarDealer.getNearbyCars(ent)
	local cars = {}
	
	for _, e in ipairs(ents.FindInSphere(ent:GetPos(), CarDealer.chopDistance)) do
		if e.carDealerCar then
			local car = {ent=e, type=e.carDealerType, id=e.carDealerCarID, owner=e.Owner}
			table.insert(cars, car)
		end
	end
	
	return cars
end
