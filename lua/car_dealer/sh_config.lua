if not CarDealer then
	CarDealer = {}
end

local function addVehicle(type, id, price, level, vip, teams, addon)
	if not CarDealer.cars[type] then
		CarDealer.cars[type] = {}
	end
	
	if not CarDealer.cars[type].cars then
		CarDealer.cars[type].cars = {}
	end
	
	local car = {id=id, price=price, level=level}
	if vip then car.vip = vip end
	if teams then car.allowedTeams = teams end
	if addon then car.addon = addon end
	table.insert(CarDealer.cars[type].cars, car)
end

local function loadSettings()
	timer.Simple(1, function()
		CarDealer.sellBackValue = 0.75
		CarDealer.chopShopAllowed = {TEAM_THIEF, TEAM_THIEF_EXP, TEAM_GANG, TEAM_MOB, TEAM_MOBBOSS}
		CarDealer.chopValue = 0.25
		CarDealer.chopDistance = 500
		CarDealer.chopTime = 300

		CarDealer.cars = {}
		
		-------------------
		--	PUBLIC CARS  --
		-------------------
		addVehicle("public", "crownvic_taxitdm", 5200, 40, false, {TEAM_TAXI})
		addVehicle("public", "bustdm", 550000, 64, false, {TEAM_BUS})
		addVehicle("public", "GTA4 Tow Truck", 30000, 13, false, {TEAM_MECHANIC})
		addVehicle("public", "porcycletdm", 500, 1)
		addVehicle("public", "gmcvantdm", 1662, 5)
		--addVehicle("public", "sgmcrownvic", 2029, 5)
		addVehicle("public", "focussvttdm", 3383, 7)
		addVehicle("public", "mr2gttdm", 4000, 7)
		--addVehicle("public", "07sgmcrownvic", 4710, 8)
		addVehicle("public", "c10tdm", 9800, 13, true)
		addVehicle("public", "sparktdm", 12000, 15)
		addVehicle("public", "blazertdm", 14000, 17)
		addVehicle("public", "impala96tdm", 14000, 17)
		addVehicle("public", "syclonetdm", 14500, 17)
		addVehicle("public", "wrangler88", 15000, 18)
		addVehicle("public", "supratdm", 16883, 20)
		addVehicle("public", "f100tdm", 20000, 23)
		addVehicle("public", "lrdefendertdm", 21592, 24, true)
		addVehicle("public", "wranglertdm", 22000, 25, true)
		addVehicle("public", "dodgeramtdm", 22644, 25)
		addVehicle("public", "focusrstdm", 22729, 25)
		addVehicle("public", "transittdm", 23000, 26)
		addVehicle("public", "landrovertdm", 23369, 26)
		addVehicle("public", "toyrav4tdm", 24000, 27)
		addVehicle("public", "chargersrt8tdm", 24051, 27)
		addVehicle("public", "sierralowtdm", 25000, 28)
		addVehicle("public", "sierraltdm", 25085, 28)
		addVehicle("public", "mustanggttdm", 25282, 28)
		addVehicle("public", "toytundratdm", 26353, 29)
		addVehicle("public", "f350tdm", 26959, 30)
		addVehicle("public", "chevstingray427tdm", 28000, 31)
		addVehicle("public", "grandchetdm", 29395, 32)
		addVehicle("public", "toyfjtdm", 30185, 33)
		addVehicle("public", "priustdm", 32500, 35)
		addVehicle("public", "charger2012tdm", 35845, 38)
		addVehicle("public", "raptorsvttdm", 45331, 47)
		addVehicle("public", "coupe40tdm", 47000, 49, true)
		addVehicle("public", "chevellesstdm", 52000, 54)
		addVehicle("public", "challenger70tdm", 53000, 55)
		addVehicle("public", "camarozl1tdm", 57522, 59)
		addVehicle("public", "landrover12tdm", 59871, 62)
		addVehicle("public", "escaladetdm", 65000, 67)
		addVehicle("public", "tesmodelstdm", 68660, 70, true)
		addVehicle("public", "deloreantdm", 69900, 71, true)
		addVehicle("public", "st1tdm", 70000, 71, true)
		addVehicle("public", "cayennetdm", 74642, 76)
		addVehicle("public", "cayenne12tdm", 83803, 85)
		addVehicle("public", "xbowtdm", 88000, 89, true)
		addVehicle("public", "69camarotdm", 112000, 90)
		addVehicle("public", "vipvipertdm", 122604, 90)
		addVehicle("public", "gt05tdm", 146475, 90, true)
		addVehicle("public", "v12vantagetdm", 180600, 91)
		addVehicle("public", "morgaerosstdm", 185000, 91, true)
		addVehicle("public", "bowlexrstdm", 236000, 92, true)
		addVehicle("public", "dbstdm", 250000, 92, true)
		addVehicle("public", "carreragttdm", 334283, 93, true)
		addVehicle("public", "noblem600tdm", 450000, 94, true)
		addVehicle("public", "lmptdm", 650000, 97, true)
		addVehicle("public", "918spydtdm", 845000, 99)
		
		-----------------------------
		--	Civil Protection CARS  --
		-----------------------------
		CarDealer.cars["police"] = {noInventory = true, teams = {TEAM_POLICE, TEAM_SWAT, TEAM_CHIEF, TEAM_POLICE_MEDIC, TEAM_MAYOR, TEAM_SECRETSERVICE}}
		addVehicle("police", "sgmcrownviccvpi", 0, 10)
		addVehicle("police", "sgmcrownvicuc", 0, 15)
		addVehicle("police", "07sgmcrownviccvpi", 0, 10)
		addVehicle("police", "07sgmcrownvicuc", 0, 15)
		addVehicle("police", "GTA4 Stretch", 0, 15, false, {TEAM_SECRETSERVICE})

		--------------------
		--	Fire Fighter  --
		--------------------
		CarDealer.cars["fire"] = {noInventory = true, teams = {TEAM_FIREFIGHTER}}
		addVehicle("fire", "GTA4 FireTruck", 0, 10)
		
		----------------
		--	Truckers  --
		----------------
		CarDealer.cars["trucker"] = {teams = {TEAM_TRUCKER}}
		addVehicle("trucker", "fgtargsytdm", 100000, 80)
		addVehicle("trucker", "kwt800tdm", 278000, 80)
		addVehicle("trucker", "flatbedtdm", 25000, 80, false, nil, true)
		addVehicle("trucker", "singleaxleboxtrailertdm", 70000, 80, false, nil, true)
	end)
end
hook.Add("OnReloaded", "CarDealerReloadCars", loadSettings)
hook.Add("PostGamemodeLoaded", "CarDealerLoadCars", loadSettings)
if CarDealer.cars then
	loadSettings()
end