CarDealer.inventory = {}

function CarDealer.ownsVehicle(ply, type, id)
	if not CarDealer.inventory[ply:SteamID()] then
		return false
	end
	
	if not CarDealer.inventory[ply:SteamID()][type] then
		return false
	end
	
	return table.HasValue(CarDealer.inventory[ply:SteamID()][type], id)
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
	
	table.insert(CarDealer.inventory[ply:SteamID()][type], id)
	CarDealer.saveInventory(ply:SteamID())
end

function CarDealer.saveInventory(steamID)	
	if not CarDealer.inventory[steamID] then
		return
	end
	
	if not file.Exists("car_dealer", "DATA") then
		file.CreateDir("car_dealer")
	end
	
	local steamIDF = string.Replace(steamID, ":", "-")
	file.Write("car_dealer/" .. steamIDF .. ".txt", util.TableToJSON(CarDealer.inventory[steamID]))
end

function CarDealer.loadInventory(ply)
	local steamID = string.Replace(ply:SteamID(), ":", "-")

	if not file.Exists("car_dealer/" .. steamID .. ".txt", "DATA") then
		return
	end

	local json = file.Read("car_dealer/" .. steamID .. ".txt", "DATA")
	local tbl = util.JSONToTable(json)
	
	CarDealer.inventory[ply:SteamID()] = tbl
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