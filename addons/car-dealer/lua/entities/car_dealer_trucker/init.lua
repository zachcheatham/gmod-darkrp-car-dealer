AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()	
	self.BaseClass.Initialize(self)
	
	self:SetModel("models/Characters/Hostage_02.mdl")
end
