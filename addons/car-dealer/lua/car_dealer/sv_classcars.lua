if not CarDealerShop then
	CarDealerShop = {}
end

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