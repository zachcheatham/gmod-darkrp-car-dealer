if SERVER then
	AddCSLuaFile("car_dealer/sh_config.lua")
	AddCSLuaFile("car_dealer/sh_util.lua")
	AddCSLuaFile("car_dealer/cl_shop.lua")
	AddCSLuaFile("car_dealer/cl_inventory.lua")
	AddCSLuaFile("car_dealer/cl_chopshop.lua")
	
	include("car_dealer/sh_config.lua")
	include("car_dealer/sh_util.lua")
	include("car_dealer/sv_util.lua")
	include("car_dealer/sv_classcars.lua")
	include("car_dealer/sv_inventory.lua")
	include("car_dealer/sv_npcpos.lua")
	include("car_dealer/sv_shop.lua")
	include("car_dealer/sv_chopshop.lua")
	include("car_dealer/sv_util.lua")
else
	include("car_dealer/sh_config.lua")
	include("car_dealer/sh_util.lua")
	include("car_dealer/cl_shop.lua")
	include("car_dealer/cl_inventory.lua")
	include("car_dealer/cl_chopshop.lua")
end