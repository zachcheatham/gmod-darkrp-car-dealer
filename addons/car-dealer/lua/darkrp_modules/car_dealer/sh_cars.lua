if not CarDealer then
	CarDealer = {}
end

CarDealer.cars = {}

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


-- Timer so TEAM_ vars exist!
timer.Simple(10, function()
	-------------------
	--	PUBLIC CARS  --chargersrt8tdm
	-------------------
	addVehicle("public", "porcycletdm", 500, 1)
	addVehicle("public", "crownvic_taxitdm", 5200, 40, false, {TEAM_TAXI})
	addVehicle("public", "blazertdm", 14000, 25)
	addVehicle("public", "sparktdm", 12000, 25)
	addVehicle("public", "impala96tdm", 14000, 25)
	addVehicle("public", "mr2gttdm", 15000, 25)
	addVehicle("public", "supratdm", 16000, 25)
	addVehicle("public", "focussvttdm", 17000, 25)
	addVehicle("public", "transittdm", 23000, 25)
	addVehicle("public", "toyrav4tdm", 23000, 25)
	addVehicle("public", "priustdm", 24000, 25)
	addVehicle("public", "sierratdm", 25000, 25)
	addVehicle("public", "f100tdm", 26000, 25)
	addVehicle("public", "toytundratdm", 26000, 25)
	addVehicle("public", "syclonetdm", 27000, 25)
	addVehicle("public", "toyfjtdm", 27500, 25)
	addVehicle("public", "gmcvantdm", 30000, 25)
	addVehicle("public", "dodgeramtdm", 30000, 25)
	addVehicle("public", "f350tdm", 32000, 25)
	addVehicle("public", "focusrstdm", 38000, 25)
	addVehicle("public", "lrdefendertdm", 40000, 25)
	addVehicle("public", "charger2012tdm", 45000, 25)
	addVehicle("public", "69camarotdm", 47000, 25)
	addVehicle("public", "st1tdm", 50000, 25)
	addVehicle("public", "chevellesstdm", 52000, 25)
	addVehicle("public", "raptorsvttdm", 53000, 25)
	addVehicle("public", "chargersrt8tdm", 54000, 25)
	addVehicle("public", "camarozl1tdm", 55000, 25)
	addVehicle("public", "mustanggttdm", 55000, 25)
	addVehicle("public", "coupe40tdm", 60000, 25)
	addVehicle("public", "challenger70tdm", 70000, 25)
	addVehicle("public", "escaladetdm", 80000, 25)
	addVehicle("public", "landrovertdm", 82000, 25)
	addVehicle("public", "landrover12tdm", 83000, 25)
	addVehicle("public", "cayenne12tdm", 111000, 25)
	addVehicle("public", "cayennetdm", 111000, 25)
	addVehicle("public", "h1opentdm", 129000, 25)
	addVehicle("public", "997gt3tdm", 130000, 25)
	addVehicle("public", "h1tdm", 140000, 25)
	addVehicle("public", "gt05tdm", 145000, 25)
	addVehicle("public", "carreragttdm", 448000, 25)
	addVehicle("public", "bustdm", 550000, 25, false, {TEAM_BUS})
	addVehicle("public", "918spydtdm", 845000, 25)
	addVehicle("public", "eb110tdm", 1600000, 25)
	addVehicle("public", "veyrontdm", 1700000, 25)
	addVehicle("public", "veyronsstdm", 2700000, 25)

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
	addVehicle("fire", "GTA4 FireTruck", 0, 20)
	
	----------------
	--	Truckers  --
	----------------
	CarDealer.cars["trucker"] = {teams = {TEAM_TRUCKER}}
	addVehicle("trucker", "fgtargsytdm", 100000, 80)
	addVehicle("trucker", "kwt800tdm", 278000, 80)
	addVehicle("trucker", "flatbedtdm", 25000, 80, false, nil, true)
	addVehicle("trucker", "singleaxleboxtrailertdm", 70000, 80, false, nil, true)
end)