ENT.Type = "anim"
ENT.PrintName = "Glow"
ENT.Author = "Fat Jesus"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int",0,"red")
	self:DTVar("Int",1,"green")
	self:DTVar("Int",2,"blue")
end