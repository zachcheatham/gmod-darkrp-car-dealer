AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/Humans/Group02/male_09.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
 
	self:SetMaxYawSpeed( 180 )
end

function ENT:AcceptInput(name, activator, ply)
	if name == "Use" and IsValid(ply) and ply:IsPlayer() then
		if not CarDealer.cars[self.CarDealerType].teams or table.HasValue(CarDealer.cars[self.CarDealerType].teams, ply:Team()) then
			CarDealer.openShop(ply, self.CarDealerType)
		else
			DarkRP.notify(ply, 1, 4, "Your current job can't use that!")
		end
	end
end