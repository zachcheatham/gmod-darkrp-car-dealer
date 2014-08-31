if not CarDealer then
	CarDealer = {}
end

util.AddNetworkString("CarDealer_OpenChopShop")
util.AddNetworkString("CarDealer_StartChop")
util.AddNetworkString("CarDealer_ChopState")

local choppingCars = {}

local function sendChopStart(ply)
	net.Start("CarDealer_ChopState")
	net.WriteBit(true)
	net.Send(ply)
end

local function sendChopStop(ply)
	net.Start("CarDealer_ChopState")
	net.WriteBit(false)
	net.Send(ply)
end

-- Hate to use a think hook but yeah
local function thinkAboutChopping()
	for id, chopData in pairs(choppingCars) do
		local remove = false
		if not IsValid(chopData.ply) then
			remove = true
		elseif not IsValid(chopData.npc) then
			DarkRP.notify(chopData.ply, 1, 4, "The Chop Shop NPC was removed while dismantling.")
			remove = true
		elseif not IsValid(chopData.car) then
			DarkRP.notify(chopData.ply, 1, 4, "The vehicle being dismantled was removed.")
			remove = true
		elseif chopData.npc:GetPos():Distance(chopData.ply:GetPos()) > CarDealer.chopDistance then
			DarkRP.notify(chopData.ply, 1, 4, "You left while the vehicle was being dismantled.")
			remove = true
		elseif chopData.npc:GetPos():Distance(chopData.car:GetPos()) > CarDealer.chopDistance then
			DarkRP.notify(chopData.ply, 1, 4, "The vehicle was moved away while it was being dismantled.")
			remove = true
		end
		
		if remove then
			-- Remove progress bar
			if IsValid(chopData.ply) then
				sendChopStop(chopData.ply)
			end
			
			-- Destroy the chop
			timer.Destroy("CarDealer_Chop" .. id)
			choppingCars[id] = nil
			if table.Count(choppingCars) < 1 then
				hook.Remove("CarDealer_Chopping")
			end
		end
	end
end

function CarDealer.openChopShop(ply, npc)
	local cars = CarDealer.getNearbyCars(npc)
	net.Start("CarDealer_OpenChopShop")
	net.WriteEntity(npc)
	net.WriteTable(cars)
	net.Send(ply)
end

function CarDealer.startChopping(ply, npc, ent)
	-- Validate all the things
	if not IsValid(npc) then
		DarkRP.notify(ply, 1, 4, "The Chop Shop was removed!")
	elseif not IsValid(ent) then
		DarkRP.notify(ply, 1, 4, "That vehicle no longer exists!")
	elseif not ent.carDealerCar then
		DarkRP.notify(ply, 1, 4, "That vehicle wasn't bought with a car dealer!")
	elseif choppingCars[ply:EntIndex()] then
		DarkRP.notify(ply, 1, 4, "You are already having a vehicle dismantled!")
	else
		-- Validate the positions
		local position = npc:GetPos()
		if position:Distance(ply:GetPos()) > CarDealer.chopDistance then
			DarkRP.notify(ply, 1, 4, "You must be near the Chop Shop!")
		elseif position:Distance(ent:GetPos()) > CarDealer.chopDistance then
			DarkRP.notify(ply, 1, 4, "The vehicle has to be bear the Chop Shop!")
		else
			-- Create the position think hook
			if table.Count(choppingCars) < 1 then
				hook.Add("Think", "CarDealer_Chopping", thinkAboutChopping)
			end
			
			-- Add chop details to think hook
			choppingCars[ply:EntIndex()] = {npc=npc, ply=ply, car=ent}
		
			-- Notify player that we started the chop
			sendChopStart(ply)
			DarkRP.notify(ply, 0, 4, "Vehicle is now being dismantled.")
			
			-- Wait until chopping is done
			timer.Create("CarDealer_Chop" .. ply:EntIndex(), CarDealer.chopTime, 1, function()
				local value = CarDealer.getCarDetails(ent.carDealerType, ent.carDealerCarID).price * CarDealer.chopValue

				-- Remove the chop validator
				choppingCars[ply:EntIndex()] = nil
				if table.Count(choppingCars) < 1 then -- Remove the hook if no other chops are occuring
					hook.Remove("Think", "CarDealer_Chopping")
				end
				
				-- Verify all the things
				if IsValid(ply) then
					if not IsValid(npc) then
						DarkRP.notify(ply, 1, 4, "The Chop Shop NPC was removed while dismantling.")
					elseif not IsValid(ent) then
						DarkRP.notify(ply, 1, 4, "The vehicle being dismantled was removed.")
					elseif position:Distance(ply:GetPos()) > CarDealer.chopDistance then
						DarkRP.notify(ply, 1, 4, "You left while the vehicle was being dismantled.")
					elseif position:Distance(ent:GetPos()) > CarDealer.chopDistance then
						DarkRP.notify(ply, 1, 4, "The vehicle was moved away while it was being dismantled.")
					else				
						-- Remove the car
						if ent.carDealerCar and not ent.noPocket then
							CarDealer.destroyCar(ent)
						end
						ent:Remove()
						
						-- Notify the player
						sendChopStop(ply)
						DarkRP.notify(ply, 0, 4, "Vehicle has been dismantled! You made $" .. value .. ".")
					end
				end
			end)
		end
	end
end

net.Receive("CarDealer_StartChop", function(len, ply)
	local npc = net.ReadEntity()
	local car = net.ReadEntity()
	
	CarDealer.startChopping(ply, npc, car)
end)