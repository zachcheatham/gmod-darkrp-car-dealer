include("shared.lua")

function ENT:Think()
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = self.dt.red
		dlight.g = self.dt.green
		dlight.b = self.dt.blue
		dlight.Brightness = 8
		dlight.Size = 120
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 1
        dlight.Style = 0
	end
end