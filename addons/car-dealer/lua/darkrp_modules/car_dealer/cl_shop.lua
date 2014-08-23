if not CarDealer then
	CarDealer = {}
end

local SHOP_WIDTH, SHOP_HEIGHT = 553, 453

function CarDealer.openShop(type)
	local allVehicles = list.Get("Vehicles")

	local shop = vgui.Create("DFrame")
	shop:SetTitle("Car Dealer")
	shop:SetDraggable(false)
	shop:MakePopup()

	shop:SetSize(SHOP_WIDTH, SHOP_HEIGHT)
	shop:SetPos(ScrW() / 2 - SHOP_WIDTH / 2, ScrH() / 2 - SHOP_HEIGHT / 2)

	shop.tabs = vgui.Create("DPropertySheet", shop)
	shop.tabs:Dock(FILL)
	
	if not CarDealer.cars[type].noInventory then
		shop.inventoryScroll = vgui.Create("DScrollPanel",  shop.tabs)
		shop.inventory = vgui.Create("DIconLayout", shop.inventoryScroll)
		shop.inventory:Dock(FILL)
		
		if CarDealer.inventory and CarDealer.inventory[type] then
			for _, id in pairs(CarDealer.inventory[type]) do
				local car = CarDealer.getCarDetails(type, id)
				if not car.allowedTeams or table.HasValue(car.allowedTeams, LocalPlayer():Team()) then
					local vehicle = allVehicles[id]
					if vehicle then
						local icon = shop.inventory:Add("CarDealerShopIcon")
						icon:SetCar(type, {id=id}, true)
						icon:SetName(vehicle.Name)
					else
						MsgC(Color(255, 255, 255), "Missing car " .. id .. " in Car Dealer!")
					end
				end
			end
		end
	end
		
	shop.buyScroll = vgui.Create("DScrollPanel", shop.tabs)
	shop.buy = vgui.Create("DIconLayout", shop.buyScroll)
	shop.buy:Dock(FILL)
	
	for _, v in ipairs(CarDealer.cars[type].cars) do	
		if not v.allowedTeams or table.HasValue(v.allowedTeams, LocalPlayer():Team()) then
			local vehicle = allVehicles[v.id]
			if vehicle then
				local icon = shop.buy:Add("CarDealerShopIcon")
				icon:SetCar(type, v)
				icon:SetName(vehicle.Name)
			else
				MsgC(Color(255, 0, 0), "Missing car " .. v.id .. " in Car Dealer!\n")
			end
		end
	end
	
	if not CarDealer.cars[type].noInventory then
		local inventorySheet = shop.tabs:AddSheet("Inventory", shop.inventoryScroll, "icon16/box.png")
	end
	local buySheet = shop.tabs:AddSheet("Buy", shop.buyScroll, "icon16/add.png")
	
	if not CarDealer.cars[type].noInventory then
		if not CarDealer.inventory or table.Count(CarDealer.inventory) == 0 then
			shop.tabs:SetActiveTab(buySheet.Tab)
		end
	end
	
	shop.despawnButton = vgui.Create("DButton", shop)
	shop.despawnButton:SetText("Pocket Current Vehicle")
	shop.despawnButton:SetWide(125)
	shop.despawnButton:SetPos(SHOP_WIDTH - shop.despawnButton:GetWide() - 5, 25)
	shop.despawnButton.DoClick = function()
		CarDealer.despawnCar()
	end
end

function CarDealer.buyCar(type, id)
	net.Start("CarDealer_BuyCar")
	net.WriteString(type)
	net.WriteString(id)
	net.SendToServer()
end

function CarDealer.spawnCar(type, id)
	net.Start("CarDealer_SpawnCar")
	net.WriteString(type)
	net.WriteString(id)
	net.SendToServer()
end

function CarDealer.despawnCar()
	net.Start("CarDealer_DespawnCar")
	net.SendToServer()
end

net.Receive("CarDealer_OpenShop", function(len)
	local type = net.ReadString()
	CarDealer.openShop(type)
end)