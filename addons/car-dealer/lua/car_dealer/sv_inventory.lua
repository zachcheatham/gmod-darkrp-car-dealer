CarDealer.inventory = {}

function CarDealer.ownsVehicle(ply, type, id)
	if not CarDealer.inventory[ply:SteamID()] then
		return false
	end
	
	if not CarDealer.inventory[ply:SteamID()][type] then
		return false
	end
		
	return (CarDealer.inventory[ply:SteamID()][type][id] ~= nil)
end

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