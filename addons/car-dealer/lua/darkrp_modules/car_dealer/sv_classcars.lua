if not CarDealerShop then
	CarDealerShop = {}
end

local function playerChangedTeam(ply, oldTeam, newTeam)
	if ply.currentCar and ply.currentCar.allowedTeams then
		if not table.HasValue(ply.currentCar.allowedTeams) then
			ply.currentCar:Remove()
		end
	end
end
hook.Add("OnPlayerChangedTeam", "CarDealer_PlayerChangedTeam", playerChangedTeam)