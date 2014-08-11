if not CarDealerShop then
	CarDealerShop = {}
end

print "sv_shop"

util.AddNetworkString("CarDealer_OpenShop")
util.AddNetworkString("CarDealer_BuyCar")
util.AddNetworkString("CarDealer_SpawnCar")
util.AddNetworkString("CarDealer_DespawnCar")
util.AddNetworkString("CarDealer_Inventory")

function CarDealer.purchaseCar(ply, type, id)
	local car = CarDealer.getCarDetails(type, id)

	if ply:canAfford(car.price) then
		if not ply.hasLevel or ply:hasLevel(car.level) then
			if not CarDealer.ownsVehicle(ply, type, id) then
				local vehicles = list.Get("Vehicles")
				local vehicle = vehicles[id]
				
				ply:addMoney(-car.price)
				if not CarDealer.cars[type].noInventory then
					CarDealer.addToInventory(ply, type, id)
				end
				CarDealer.spawnCar(ply, vehicle, CarDealer.cars[type].noInventory, CarDealer.cars[type].teams)
				
				DarkRP.notify(ply, 2, 4, "You have purchased the " .. vehicle.Name .. " for $" .. car.price .. "!")
			else
				DarkRP.notify(ply, 1, 4, "You already own this vehicle!")
			end
		else
			DarkRP.notify(ply, 1, 4, "You are not the right level for that vehicle!")
		end
	else
		DarkRP.notify(ply, 1, 4, "You cannot afford that vehicle!")
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

	if CarDealer.ownsVehicle(ply, type, id) then
		local vehicles = list.Get("Vehicles")
		local vehicle = vehicles[id]
		CarDealer.spawnCar(ply, vehicle)
		
		DarkRP.notify(ply, 2, 4, "You have respawned your " .. vehicle.Name .. "!")
	else
		DarkRP.notify(ply, 1, 4, "You don't own that vehicle!")
	end
end)

net.Receive("CarDealer_DespawnCar", function(len, ply)
	if ply.currentCar and IsValid(ply.currentCar) then
		if not ply.currentCar.noPocket then
			local name = ply.currentCar.VehicleTable.Name
			CarDealer.despawnCar(ply)
			DarkRP.notify(ply, 2, 4, "You have pocketed your " .. name .. "!")
		else
			DarkRP.notify(ply, 1, 4, "You cannot pocket a " .. ply.currentCar.VehicleTable.Name .. "!")
		end
	else
		ply.currentCar = nil
		DarkRP.notify(ply, 1, 4, "You currently have no car spawned.")
	end
end)