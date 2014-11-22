AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if self.carDealerType == "fire" then
		self:SetModel("models/fearless/fireman2.mdl")
	elseif self.carDealerType == "police" then
		self:SetModel("models/Police.mdl")
	elseif self.carDealerType == "trucker" then
		self:SetModel("models/Characters/Hostage_02.mdl")
	else
		self:SetModel("models/Humans/Group02/male_09.mdl")
	end
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetUseType(SIMPLE_USE)
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:DropToFloor()
	
	self:SetMaxYawSpeed(180)

	self.chatIndicator = ents.Create("chatindicator")
	self.chatIndicator.ply = self
	self.chatIndicator:SetPos(self:GetPos() + Vector(0, 0, 85))
	self.chatIndicator:Spawn()
	self.chatIndicator:Activate()
end

function ENT:AcceptInput(name, activator, ply)
	if name == "Use" and IsValid(ply) and ply:IsPlayer() then
		if not CarDealer.cars[self.carDealerType].teams or table.HasValue(CarDealer.cars[self.carDealerType].teams, ply:Team()) then
			CarDealer.openShop(ply, self)
		else
			DarkRP.notify(ply, 1, 4, "Your current job can't use that!")
		end
	end
end