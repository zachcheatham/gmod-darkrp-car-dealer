-------------------
-- DATA HANDLING --
-------------------

CarDealer.inventory = {}
function CarDealer.addToInventory(ply, type, id)
	if CarDealer.ownsVehicle(ply, type, id) then
		return
	end
	
	if not CarDealer.inventory[ply:SteamID()] then
		CarDealer.inventory[ply:SteamID()] = {}
	end
	
	if not CarDealer.inventory[ply:SteamID()][type] then
		CarDealer.inventory[ply:SteamID()][type] = {}
	end
	
	CarDealer.inventory[ply:SteamID()][type][id] = {}
	CarDealer.saveInventory(ply:SteamID())
end

function CarDealer.removeFromInventory(steamID, type, id)
	CarDealer.inventory[steamID][type][id] = nil
end

function CarDealer.saveInventory(steamID)	
	if not CarDealer.inventory[steamID] then
		return
	end
	
	if not file.Exists("car_dealer", "DATA") then
		file.CreateDir("car_dealer")
	end
	
	local steamID2 = string.Replace(steamID, ":", "-")
	file.Write("car_dealer/" .. steamID2 .. ".txt", util.TableToJSON(CarDealer.inventory[steamID]))
end

function CarDealer.loadInventory(ply)
	local steamID = string.Replace(ply:SteamID(), ":", "-")

	if not file.Exists("car_dealer/" .. steamID .. ".txt", "DATA") then
		return
	end

	local json = file.Read("car_dealer/" .. steamID .. ".txt", "DATA")
	local tbl = util.JSONToTable(json)

	if tbl then
		for typ, cars in pairs(tbl) do
			local remove = {}
			for id, car in pairs(cars) do
				if type(car) == "string" then
					table.insert(remove, car)
					cars[car] = {}
				end
			end
			for _, v in pairs(remove) do
				table.RemoveByValue(cars, v)
			end
		end
	end
	
	CarDealer.inventory[ply:SteamID()] = tbl
end

function CarDealer.sendInventory(ply)
	if CarDealer.inventory[ply:SteamID()] then
		local inventory = {}
		
		for typ, cars in pairs(CarDealer.inventory[ply:SteamID()]) do
			inventory[typ] = {}
			
			for id, _ in pairs(cars) do
				table.insert(inventory[typ], id)
			end
		end
	
		net.Start("CarDealer_Inventory")
		net.WriteTable(inventory)
		net.Send(ply)
	end
end

function CarDealer.saveCustomizations(ply, car)
	if car.carDealerCar then 
		local customizationsTable = {}
		local id = car.carDealerCarID
		local type = car.carDealerType

		customizationsTable.color = car:GetColor()
		--customizationsTable.bodygroups = car:GetBodyGroups()
		customizationsTable.skin = car:GetSkin()
		
		for _, bg in ipairs(car:GetBodyGroups()) do
			if not customizationsTable.bodygroups then
				customizationsTable.bodygroups = {}
			end
			
			customizationsTable.bodygroups[bg.id] = car:GetBodygroup(bg.id)
		end

		if car.glow then
			customizationsTable.underglow = {red=car.glow.dt.red, green=car.glow.dt.green, blue=car.glow.dt.blue}
		end
		
		CarDealer.inventory[ply:SteamID()][type][id].customizations = customizationsTable
		CarDealer.saveInventory(ply:SteamID())
	end
end

local function playerAuthed(ply, steamID, uniqueID)
	CarDealer.loadInventory(ply)
end
hook.Add("PlayerAuthed", "CarDealer_PlayerAuthed", playerAuthed)

local function playerDisconnected(ply)
	CarDealer.inventory[ply:SteamID()] = nil
end
hook.Add("PlayerAuthed", "CarDealer_PlayerAuthed", playerAuthed)

-- Fix for players losing inventories when DarkRP gets reloaded
local function loadAll()
	for _, ply in ipairs(player.GetAll()) do
		CarDealer.loadInventory(ply)
	end
end
loadAll()

-------------
-- ACTIONS --
-------------
function CarDealer.destroyCar(ent)
	if IsValid(ent) and ent.carDealerCar then	
		local ply = ent.Owner
		local steamID = ent.OwnerID
		local id = ent.carDealerCarID
		local type = ent.carDealerType

		CarDealer.removeFromInventory(steamID, type, id)
		CarDealer.saveInventory(steamID)
		
		if IsValid(ply) then
			DarkRP.notify(ply, 1, 4, "Your " .. ent.VehicleName .. " has been destroyed!")
		end
	end
end

function CarDealer.unpocketCar(ply, npc, id)
	local type = npc.carDealerType
	local car = CarDealer.getCarDetails(type, id)

	if not CarDealer.ownsVehicle(ply, type, id) then
		DarkRP.notify(ply, 1, 4, "You don't own that vehicle!")
	elseif car.allowedTeams and not table.HasValue(car.allowedTeams, ply:Team()) then
		DarkRP.notify(ply, 1, 4, "You are not the right job for this vehicle!")
	elseif car.vip and ply.isVIP and not ply:isVIP() then
		DarkRP.notify(ply, 1, 4, "That vehicle is VIP only!")
	elseif IsValid(ply.currentCar) then
		DarkRP.notify(ply, 1, 4, "You must first pocket your current vehicle!")
	else	
		local vehicles = list.Get("Vehicles")
		local vehicle = vehicles[id]
		local teams = car.allowedTeams or CarDealer.cars[type].teams
		
		CarDealer.spawnCar(ply, npc, id, car, vehicle)
		if not car.noPocket then
			CarDealer.applyCustomizations(ply, ply.currentCar)
		end
		
		DarkRP.notify(ply, 2, 4, "You have respawned your " .. vehicle.Name .. "!")
	end
end

function CarDealer.pocketCar(ply, npc)
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
end