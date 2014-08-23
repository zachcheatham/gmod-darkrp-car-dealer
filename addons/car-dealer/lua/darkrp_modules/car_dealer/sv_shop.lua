if not CarDealer then
	CarDealer = {}
end

util.AddNetworkString("CarDealer_OpenShop")
util.AddNetworkString("CarDealer_BuyCar")
util.AddNetworkString("CarDealer_SpawnCar")
util.AddNetworkString("CarDealer_DespawnCar")
util.AddNetworkString("CarDealer_Inventory")

function CarDealer.purchaseCar(ply, type, id)
	local car = CarDealer.getCarDetails(type, id)

	if not ply:canAfford(car.price) then
		DarkRP.notify(ply, 1, 4, "You cannot afford that vehicle!")
	elseif car.level and ply.hasLevel and not ply:hasLevel(car.level) then
		DarkRP.notify(ply, 1, 4, "You are not the right level for that vehicle!")
	elseif car.allowedTeams and not table.HasValue(car.allowedTeams, ply:Team()) then
		DarkRP.notify(ply, 1, 4, "You are not the right job for that vehicle!")
	elseif CarDealer.ownsVehicle(ply, type, id) then
		DarkRP.notify(ply, 1, 4, "You already own this vehicle!")
	else
		local vehicles = list.Get("Vehicles")
		local vehicle = vehicles[id]
		
		ply:addMoney(-car.price)
		if not CarDealer.cars[type].noInventory then
			CarDealer.addToInventory(ply, type, id)
		end
		
		local teams = car.allowedTeams or CarDealer.cars[type].teams
		CarDealer.spawnCar(ply, type, id, vehicle, CarDealer.cars[type].noInventory, teams, car.addon)
		
		DarkRP.notify(ply, 2, 4, "You have purchased the " .. vehicle.Name .. " for $" .. car.price .. "!")
	end
end

function CarDealer.openShop(ply, type)
	if CarDealer.inventory[ply:SteamID()] then
		net.Start("CarDealer_Inventory")
		net.WriteTable(CarDealer.inventory[ply:SteamID()])
		net.Send(ply)
	end

	net.Start("CarDealer_OpenShop")
	net.WriteString(type)
	net.Send(ply)
end

net.Receive("CarDealer_BuyCar", function(len, ply)
	local type = net.ReadString()
	local id = net.ReadString()

	CarDealer.purchaseCar(ply, type, id)
end)

net.Receive("CarDealer_SpawnCar", function(len, ply)
	local type = net.ReadString()
	local id = net.ReadString()
	local car = CarDealer.getCarDetails(type, id)
	
	if not CarDealer.ownsVehicle(ply, type, id) then
		DarkRP.notify(ply, 1, 4, "You don't own that vehicle!")
	elseif car.allowedTeams and not table.HasValue(car.allowedTeams, ply:Team()) then
		DarkRP.notify(ply, 1, 4, "You are not the right job for this vehicle!")
	else
		local vehicles = list.Get("Vehicles")
		local vehicle = vehicles[id]
		local teams = car.allowedTeams or CarDealer.cars[type].teams
		
		CarDealer.spawnCar(ply, type, id, vehicle, CarDealer.cars[type].noInventory, teams, car.addon)
		
		DarkRP.notify(ply, 2, 4, "You have respawned your " .. vehicle.Name .. "!")
	end
end)

net.Receive("CarDealer_DespawnCar", function(len, ply)
	if ply.currentCar and IsValid(ply.currentCar) then
		if not ply.currentCar.noPocket then
			local name = ply.currentCar.VehicleTable.Name
			CarDealer.despawnCar(ply)
			CarDealer.despawnCarAddon(ply)
			DarkRP.notify(ply, 2, 4, "You have pocketed your " .. name .. "!")
		else
			DarkRP.notify(ply, 1, 4, "You cannot pocket a " .. ply.currentCar.VehicleTable.Name .. "!")
		end
	else
		ply.currentCar = nil
		DarkRP.notify(ply, 1, 4, "You currently have no car spawned.")
	end
end)