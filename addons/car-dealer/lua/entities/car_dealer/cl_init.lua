include("shared.lua")

local color1, color2 = Color(0, 0, 0, 200), Color(30, 144, 255, 255)

local function drawDealerTip()
	localplayer = localplayer or LocalPlayer()
	hudText = "I am a car dealer.\nPress E on me to buy a car!"
	local x, y
	local npc = localplayer:GetEyeTrace().Entity

	if IsValid(npc) and npc:IsNPC() and string.sub(npc:GetClass(), 1, 10) == "car_dealer" and localplayer:GetPos():Distance(npc:GetPos()) < GAMEMODE.Config.minHitDistance then
		x, y = ScrW() / 2, ScrH() / 2 + 30

		draw.DrawNonParsedText(hudText, "TargetID", x + 1, y + 1, color1, 1)
		draw.DrawNonParsedText(hudText, "TargetID", x, y, color2, 1)
	end
end
hook.Add("HUDPaint", "DrawCarDealerTip", drawDealerTip)