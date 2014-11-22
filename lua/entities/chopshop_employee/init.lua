AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/odessa.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:DropToFloor()
	self:SetUseType(SIMPLE_USE)
	self:SetMaxYawSpeed(180)
	
	self.chatIndicator = ents.Create("chatindicator")
	self.chatIndicator.ply = self
	self.chatIndicator:SetPos(self:GetPos() + Vector(0, 0, 85))
	self.chatIndicator:Spawn()
	self.chatIndicator:Activate()
end

function ENT:AcceptInput(name, activator, ply)
	if name == "Use" and IsValid(ply) and ply:IsPlayer() then
		if table.HasValue(CarDealer.chopShopAllowed, ply:Team()) then
			CarDealer.openChopShop(ply, self)
		else
			DarkRP.notify(ply, 1, 4, "Your current job can't use that!")
		end
	end
end