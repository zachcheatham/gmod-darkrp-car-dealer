local PANEL = {}

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )
local matOverlay_AdminOnly = Material( "icon16/shield.png" )

AccessorFunc( PANEL, "m_Color", 			"Color" )
AccessorFunc( PANEL, "m_Type", 				"ContentType" )
AccessorFunc( PANEL, "m_SpawnName", 		"SpawnName" )
AccessorFunc( PANEL, "m_NPCWeapon", 		"NPCWeapon" )

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDrawBackground( false )
	self:SetSize( 128, 128 )
	self:SetText( "" )
	self:SetDoubleClickingEnabled( false )
	
	self.Image = self:Add( "DImage" )
	self.Image:SetPos( 3, 3 )
	self.Image:SetSize( 128 - 6, 128 - 6 )
	self.Image:SetVisible( false )

	self.Label = self:Add( "DLabel" )
	self.Label:Dock( BOTTOM )
	self.Label:SetContentAlignment( 2 )
	self.Label:DockMargin( 4, 0, 4, 10 )
	self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Label:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )

	self.Border = 0
	
end


function PANEL:SetCar( type, car, isInventory )
	self.Type = type
	self.VehicleID = car.id
	self.IsInventory = isInventory
	
	if not isInventory then
		self.CostLabel = self:Add( "DLabel" )
		self.CostLabel:Dock( TOP )
		self.CostLabel:SetContentAlignment( 2 )
		self.CostLabel:DockMargin( 4, 1, 4, 10 )
		self.CostLabel:SetText( "$0" )
		self.CostLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.CostLabel:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
	
		self.Cost = car.price
		self.Level = car.level
		
		if self.Level then
			self.CostLabel:SetText( "$" .. self.Cost .. " - " .. "Level " .. self.Level )
		else
			self.CostLabel:SetText( "$" .. self.Cost )
		end
	end
	
	self:SetMaterial("entities/" .. car.id .. ".png")
end

function PANEL:SetName( name )
	self:SetTooltip( name )
	self.Label:SetText( name )
	self.m_NiceName = name
end

function PANEL:SetMaterial( name )

	self.m_MaterialName = name

	local mat = Material( name )
	
	-- Look for the old style material
	if ( !mat || mat:IsError() ) then
	
		name = name:Replace( "entities/", "VGUI/entities/" )
		name = name:Replace( ".png", "" )
		mat = Material( name )
		
	end

	-- Couldn't find any material.. just return
	if ( !mat || mat:IsError() ) then
		return 
	end
	
	self.Image:SetMaterial( mat )
	
end

function PANEL:SetAdminOnly( b )
	self.AdminOnly = b
end

function PANEL:DoRightClick()

end

function PANEL:DoClick()
	if self.IsInventory then
		CarDealer.spawnCar(self.Type, self.VehicleID)
	else
		CarDealer.buyCar(self.Type, self.VehicleID)
	end
end

function PANEL:Paint( w, h )

	if ( self.Depressed && !self.Dragging ) then
		if ( self.Border != 8 ) then
			self.Border = 8
		end
	else
		if ( self.Border != 0 ) then
			self.Border = 0
		end
	end
	
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	
	self.Image:PaintAt( 3 + self.Border, 3 + self.Border, 128-8-self.Border*2, 128-8-self.Border*2 )
	
	render.PopFilterMag()
	render.PopFilterMin()

	surface.SetDrawColor( 255, 255, 255, 255 )
	
	if ( !dragndrop.IsDragging() && (self:IsHovered() || self:IsChildHovered( 2 )) ) then

		surface.SetMaterial( matOverlay_Hovered )
		self.Label:Hide()
		
		if self.CostLabel then
			self.CostLabel:Hide()
		end

	else

		surface.SetMaterial( matOverlay_Normal )
		
		self.Label:Show()
		
		if self.CostLabel then
			self.CostLabel:Show()
		end		
		
	end
	
	surface.DrawTexturedRect( self.Border, self.Border, w-self.Border*2, h-self.Border*2 )

	if ( self.AdminOnly ) then
		surface.SetMaterial( matOverlay_AdminOnly )
		surface.DrawTexturedRect( self.Border + 8, self.Border + 8, 16, 16 )
	end
end

function PANEL:PaintOver( w, h )

	self:DrawSelections()

end

function PANEL:ToTable( bigtable )

	local tab = {}
	
	tab.type		= self:GetContentType()
	tab.nicename	= self.m_NiceName
	tab.material	= self.m_MaterialName
	tab.admin		= self.AdminOnly
	tab.spawnname	= self:GetSpawnName()
	tab.weapon		= self:GetNPCWeapon()

	table.insert( bigtable, tab )

end

function PANEL:Copy()

	local copy = vgui.Create( "ContentIcon", self:GetParent() )

	copy:SetContentType( self:GetContentType() )
	copy:SetSpawnName( self:GetSpawnName() )
	copy:SetName( self.m_NiceName )
	copy:SetMaterial( self.m_MaterialName )
	copy:SetNPCWeapon( self:GetNPCWeapon() )
	copy:SetAdminOnly( self.AdminOnly )
	copy:CopyBase( self )
	copy.DoClick = self.DoClick
	copy.OpenMenu = self.OpenMenu

	return copy

end

vgui.Register("CarDealerShopIcon", PANEL, "DButton")