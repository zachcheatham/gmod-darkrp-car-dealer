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
		CarDealer.chopShopAllowed = {TEAM_THIEF, TEAM_GANG, TEAM_MOB}
		CarDealer.chopValue = 0.25
		CarDealer.chopDistance = 500
		CarDealer.chopTime = 300

		CarDealer.cars = {}
		
		-------------------
		--	PUBLIC CARS  --
		-------------------
		addVehicle("public", "crownvic_taxitdm", 5200, 40, false, {TEAM_TAXI})
		addVehicle("public", "bustdm", 550000, 64, false, {TEAM_BUS})
		addVehicle("public", "porcycletdm", 500, 1)
		--addVehicle("public", "sparktdm", 12000, 5)
		addVehicle("public", "blazertdm", 14000, 5)
		addVehicle("public", "impala96tdm", 14000, 10)
		addVehicle("public", "coupe40tdm", 60000, 10, true)
		addVehicle("public", "mr2gttdm", 15000, 12)
		addVehicle("public", "supratdm", 16000, 12)
		addVehicle("public", "focussvttdm", 17000, 17)
		addVehicle("public", "transittdm", 23000, 17)
		addVehicle("public", "challenger70tdm", 70000, 20, true)
		addVehicle("public", "toyrav4tdm", 23000, 23)
		addVehicle("public", "priustdm", 24000, 23)
		addVehicle("public", "sierratdm", 25000, 28)
		addVehicle("public", "f100tdm", 26000, 28)
		addVehicle("public", "toytundratdm", 26000, 28)
		addVehicle("public", "chevellesstdm", 52000, 30)
		addVehicle("public", "997gt3tdm", 130000, 30)
		addVehicle("public", "raptorsvttdm", 53000, 32)
		addVehicle("public", "syclonetdm", 27000, 35)
		addVehicle("public", "toyfjtdm", 27500, 35)
		addVehicle("public", "gmcvantdm", 30000, 35)
		addVehicle("public", "escaladetdm", 80000, 40)
		addVehicle("public", "landrovertdm", 82000, 40)
		addVehicle("public", "landrover12tdm", 83000, 40)
		addVehicle("public", "dodgeramtdm", 30000, 45)
		addVehicle("public", "f350tdm", 32000, 45)
		addVehicle("public", "focusrstdm", 38000, 45)
		addVehicle("public", "lrdefendertdm", 40000, 45, true)
		addVehicle("public", "charger2012tdm", 45000, 50)
		addVehicle("public", "69camarotdm", 47000, 50)
		--addVehicle("public", "st1tdm", 50000, 25)
		addVehicle("public", "chargersrt8tdm", 54000, 60)
		addVehicle("public", "camarozl1tdm", 55000, 60)
		addVehicle("public", "mustanggttdm", 55000, 60)
		addVehicle("public", "gt05tdm", 145000, 60, true)
		addVehicle("public", "cayenne12tdm", 111000, 80)
		addVehicle("public", "cayennetdm", 111000, 80)
		--addVehicle("public", "h1opentdm", 129000, 25)
		--addVehicle("public", "h1tdm", 140000, 25)
		addVehicle("public", "carreragttdm", 448000, 80, true)
		addVehicle("public", "918spydtdm", 845000, 99)
		--addVehicle("public", "eb110tdm", 1600000, 25)
		--addVehicle("public", "veyrontdm", 1700000, 25)
		--addVehicle("public", "veyronsstdm", 2700000, 25)

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