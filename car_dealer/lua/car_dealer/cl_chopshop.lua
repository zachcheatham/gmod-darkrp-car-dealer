if not CarDealer then
	CarDealer = {}
end

function CarDealer.openChopShop(npc, cars)
	local allVehicles = list.Get("Vehicles")
	
	local frame = vgui.Create("DFrame")
	frame:SetTitle("Chop Shop")
	frame:MakePopup()
	frame:SetSize(350, 120)
	frame:SetPos(ScrW() / 2 - 150, ScrH() / 2 - 60)

	local tip = vgui.Create("DLabel", frame)
	tip:SetText("Select a nearby vehicle to have dismantled...")
	tip:SetBright(true)
	tip:Dock(TOP)
	
	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:Dock(FILL)
	
	if table.Count(cars) > 0 then
		for _, car in ipairs(cars) do
			
			local data = CarDealer.getCarDetails(car.type, car.id)
			local vData = allVehicles[car.id]
				
			local carRow = vgui.Create("DSizeToContents", scroll)
			carRow:SetTall(60)
			carRow:DockMargin(0,0,0,10)
			carRow:Dock(TOP)
			
			local image = vgui.Create("DImage", carRow)
			image:SetMaterial("VGUI/entities/" .. car.id)
			image:SetSize(60, 60)
			image:DockMargin(0, 0, 10, 0)
			image:Dock(LEFT)
			
			local name = vgui.Create("DLabel", carRow)
			name:SetText(vData.Name)
			name:SetBright(true)
			name:Dock(TOP)
			
			local owner = vgui.Create("DLabel", carRow)
			owner:SetText("Owner: " .. (IsValid(car.owner) and car.owner:Nick() or "Disconnected Player"))
			owner:Dock(TOP)
			
			local value = vgui.Create("DLabel", carRow)
			value:SetText("Value: $" .. data.price * CarDealer.chopValue)
			value:Dock(TOP)
			
			local chopButton = vgui.Create("DButton", carRow)
			chopButton:SetWide(100)
			chopButton:SetPos(230, 18)
			chopButton:SetText("Start Chopping")
			chopButton.DoClick = function()
				CarDealer.startChopping(npc, car.ent)
			end
		end
	end
end

local startTime = 0
-- Used the lockpick HUD from DarkRP
local function drawHUD()
	local w = ScrW()
	local h = ScrH()
	local x,y,width,height = w/2-w/10, h/2-60, w/5, h/15
	draw.RoundedBox(8, x, y, width, height, Color(10,10,10,120))
	
	local time = (startTime + CarDealer.chopTime) - startTime
	local curtime = CurTime() - startTime
	
	local status = math.Clamp(curtime/time, 0, 1)
	local BarWidth = status * (width - 16)
	local cornerRadius = math.Min(8, BarWidth/3*2 - BarWidth/3*2%2)
	draw.RoundedBox(cornerRadius, x+8, y+8, BarWidth, height-16, Color(255-(status*255), 0+(status*255), 0, 255))

	draw.DrawNonParsedSimpleText("Dismantling Vehicle... (" .. string.ToMinutesSeconds(time - curtime) .. ")", "Trebuchet24", w/2, y + height/2, Color(255,255,255,255), 1, 1)
end

function CarDealer.startChopping(npc, car)
	net.Start("CarDealer_StartChop")
	net.WriteEntity(npc)
	net.WriteEntity(car)
	net.SendToServer()
end

net.Receive("CarDealer_OpenChopShop", function(len)
	local npc = net.ReadEntity()
	local cars = net.ReadTable()
	if IsValid(npc) then
		CarDealer.openChopShop(npc, cars)
	end
end)

net.Receive("CarDealer_ChopState", function(len)
	local state = net.ReadBit() == 1
	
	if state then
		startTime = CurTime()
		hook.Add("HUDPaint", "CarDealer_ChopProgress", drawHUD)
	else
		hook.Remove("HUDPaint", "CarDealer_ChopProgress")
	end
end)