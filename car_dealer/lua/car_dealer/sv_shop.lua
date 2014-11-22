if not CarDealer then
	CarDealer = {}
end

util.AddNetworkString("CarDealer_OpenShop")
util.AddNetworkString("CarDealer_BuyCar")
util.AddNetworkString("CarDealer_SpawnCar")
util.AddNetworkString("CarDealer_DespawnCar")
util.AddNetworkString("CarDealer_Inventory")
util.AddNetworkString("CarDealer_UnderGlow")

function CarDealer.purchaseCar(ply, npc, id)
	local type = npc.carDealerType
	local car = CarDealer.getCarDetails(type, id)

	if car.allowedTeams and not table.HasValue(car.allowedTeams, ply:Team()) then
		DarkRP.notify(ply, 1, 4, "You are not the right job for that vehicle!")
	elseif car.vip and ply.isVIP and not ply:isVIP() then
		DarkRP.notify(ply, 1, 4, "That vehicle is VIP only!")
	elseif car.level and ply.hasLevel and not ply:hasLevel(car.level) then
		DarkRP.notify(ply, 1, 4, "You are not the right level for that vehicle!")
	elseif CarDealer.ownsVehicle(ply, type, id) then
		DarkRP.notify(ply, 1, 4, "You already own this vehicle!")
	elseif not ply:canAfford(car.price) then
		DarkRP.notify(ply, 1, 4, "You cannot afford that vehicle!")
	elseif IsValid(ply.currentCar) then
		DarkRP.notify(ply, 1, 4, "You must first pocket your current vehicle!")
	else
		local vehicles = list.Get("Vehicles")
		local vehicle = vehicles[id]
		
		ply:addMoney(-car.price)
		if not CarDealer.cars[type].noInventory then
			CarDealer.addToInventory(ply, type, id)
		end
		
		CarDealer.spawnCar(ply, npc, id, car, vehicle)

		DarkRP.notify(ply, 2, 4, "You have purchased the " .. vehicle.Name .. " for $" .. car.price .. "!")
	end
end

--------------------
-- CUSTOMIZATIONS --
--------------------
function CarDealer.applyCustomizations(ply, car)
	if car.carDealerCar then
		local id = car.carDealerCarID
		local typ = car.carDealerType
		
		if CarDealer.inventory[ply:SteamID()][typ][id].customizations then
			local customizations = CarDealer.inventory[ply:SteamID()][typ][id].customizations
			if customizations.color then
				car:SetColor(customizations.color)
			end
			if customizations.bodygroups then
				for id, v in ipairs(customizations.bodygroups) do
					if type(v) == "number" then
						car:SetBodygroup(id, v)
					end
				end
			end
			if customizations.skin then
				car:SetSkin(customizations.skin)
			end
			if customizations.underglow then
				CarDealer.applyUnderGlow(car, Color(customizations.underglow.red, customizations.underglow.green, customizations.underglow.blue))
			end
		end
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

----------------
-- NETWORKING --
----------------

function CarDealer.openShop(ply, npc)
	CarDealer.sendInventory(ply)

	net.Start("CarDealer_OpenShop")
	net.WriteString(npc.carDealerType)
	net.WriteEntity(npc)
	net.Send(ply)
end

net.Receive("CarDealer_BuyCar", function(len, ply)
	local npc = net.ReadEntity()
	local id = net.ReadString()

	CarDealer.purchaseCar(ply, npc, id)
end)

net.Receive("CarDealer_SpawnCar", function(len, ply)
	local npc = net.ReadEntity()
	local id = net.ReadString()
	
	CarDealer.unpocketCar(ply, npc, id)
end)

net.Receive("CarDealer_DespawnCar", function(len, ply)
	local npc = net.ReadEntity()
	CarDealer.pocketCar(ply, npc)
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

-----------
-- HOOKS --
-----------

local function playerChangedTeam(ply, oldTeam, newTeam)
	if ply.currentCar and ply.currentCar.allowedTeams then
		if not table.HasValue(ply.currentCar.allowedTeams) then
			CarDealer.despawnCar(ply)
		end
	end
	
	if ply.currentCarAddon and ply.currentCarAddon.allowedTeams then
		if not table.HasValue(ply.currentCarAddon.allowedTeams) then
			CarDealer.despawnCarAddon(ply)
		end
	end
end
hook.Add("OnPlayerChangedTeam", "CarDealer_PlayerChangedTeam", playerChangedTeam)

local function playerSellVehicle(ply, ent)
	if ent.carDealerCar then
		return false, "You must sell your vehicle at the Car Dealer!"
	end
end
hook.Add("playerSellVehicle", "CarDealer_SellVehicle", playerSellVehicle)

local function playerBuyVehicle(ply, ent)
	if ent.carDealerCar then
		return false, "Someone else owns this by the Car Dealer!"
	end
end
hook.Add("playerBuyVehicle", "CarDealer_BuyVehicle", playerBuyVehicle)

function playerInitialSpawn(ply)
    for entID, ent in ipairs(ents.FindByClass("prop_vehicle_jeep")) do
		if ent.carDealerCar and ent.OwnerID == ply:SteamID() then
			ent.Owner = ply
			ent.SID = ply.SID
			
			timer.Simple(5, function() 
				ent:keysOwn(ply)
			end)
			
			ply.currentCar = ent
		end
	end
end
hook.Add("PlayerInitialSpawn", "CarDealer_OwnVehicles", playerInitialSpawn)