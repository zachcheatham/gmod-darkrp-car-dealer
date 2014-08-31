if not CarDealer then
	CarDealer = {}
end

util.AddNetworkString("CarDealer_OpenShop")
util.AddNetworkString("CarDealer_BuyCar")
util.AddNetworkString("CarDealer_SpawnCar")
util.AddNetworkString("CarDealer_DespawnCar")
util.AddNetworkString("CarDealer_Inventory")
util.AddNetworkString("CarDealer_UnderGlow")

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
	elseif IsValid(ply.currentCar) then
		DarkRP.notify(ply, 1, 4, "You must first pocket your current vehicle!")
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

function CarDealer.applyUnderGlow(car, color)
	if IsValid(car) then
		if color.r == 0 and color.g == 0 and color.b == 0 and IsValid(car.glow) then
			car.glow:Remove()
			car.glow = nil
		else
			if not IsValid(car.glow) then
				car.glow = ents.Create("underglow_light")
				car.glow:SetPos(car:GetPos(Vector(0, 0, -10)))
				car.glow:SetAngles(car:GetAngles() + Angle(0, 90, 0))
				car.glow:SetParent(car)
				car.glow:Spawn()
				
				car:DeleteOnRemove(car.glow)
			end
			
			car.glow.dt.red = color.r
			car.glow.dt.green = color.g
			car.glow.dt.blue = color.b
		end
	end
end

function CarDealer.openShop(ply, npc)
	CarDealer.sendInventory(ply)

	net.Start("CarDealer_OpenShop")
	net.WriteString(npc.CarDealerType)
	net.WriteEntity(npc)
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
	elseif IsValid(ply.currentCar) then
		DarkRP.notify(ply, 1, 4, "You must first pocket your current vehicle!")
	else	
		local vehicles = list.Get("Vehicles")
		local vehicle = vehicles[id]
		local teams = car.allowedTeams or CarDealer.cars[type].teams
		
		CarDealer.spawnCar(ply, type, id, vehicle, CarDealer.cars[type].noInventory, teams, car.addon)
		if not car.noPocket then
			CarDealer.applyCustomizations(ply, ply.currentCar)
		end
		
		DarkRP.notify(ply, 2, 4, "You have respawned your " .. vehicle.Name .. "!")
	end
end)

net.Receive("CarDealer_DespawnCar", function(len, ply)
	local npc = net.ReadEntity()
	if ply.currentCar and IsValid(ply.currentCar) then
		local name = ply.currentCar.VehicleTable.Name
		
		if not CarDealer.isCarNearEntity(npc, ply.currentCar) then
			DarkRP.notify(ply, 1, 4, "You must bring your " .. name .. " nearby!")
		else
			CarDealer.despawnCar(ply)
			CarDealer.despawnCarAddon(ply)
			DarkRP.notify(ply, 2, 4, "You have pocketed your " .. name .. "!")
		end
	else
		ply.currentCar = nil
		DarkRP.notify(ply, 1, 4, "You currently have no car spawned.")
	end
end)

net.Receive("CarDealer_UnderGlow", function(len, ply)
	local color = net.ReadColor()
	
	if IsValid(ply.currentCar) then
		CarDealer.applyUnderGlow(ply.currentCar, color)
		DarkRP.notify(ply, 0, 4, "Vehicle underglow updated.")
	else
		DarkRP.notify(ply, 1, 4, "You must spawn a car to apply underglow.")
	end
end)