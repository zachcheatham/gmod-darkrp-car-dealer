include("shared.lua")

local color1, color2 = Color(0, 0, 0, 200), Color(234, 206, 106, 255)

local function drawDealerTip()
	localplayer = localplayer or LocalPlayer()
	local hudText = "I work for the Chop Shop.\nPress E on me to dismantle a nearby vehicle!"
	local x, y
	local npc = localplayer:GetEyeTrace().Entity

	if IsValid(npc) and npc:IsNPC() and npc:GetClass() == "chopshop_employee" and localplayer:GetPos():Distance(npc:GetPos()) < GAMEMODE.Config.minHitDistance then
		x, y = ScrW() / 2, ScrH() / 2 + 30

		draw.DrawNonParsedText(hudText, "TargetID", x + 1, y + 1, color1, 1)
		draw.DrawNonParsedText(hudText, "TargetID", x, y, color2, 1)
	end
end
hook.Add("HUDPaint", "DrawChopShopTip", drawDealerTip)