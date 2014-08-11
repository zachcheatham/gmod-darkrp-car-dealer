if not CarDealer then
	CarDealer = {}
end

CarDealer.cars = {}

local function addVehicle(type, id, price, level)
	if not CarDealer.cars[type] then
		CarDealer.cars[type] = {}
	end
	
	if not CarDealer.cars[type].cars then
		CarDealer.cars[type].cars = {}
	end
	
	local car = {id=id, price=price, level=level}
	table.insert(CarDealer.cars[type].cars, car)
end

-------------------
--	PUBLIC CARS  --supratdm
-------------------
addVehicle("public", "porcycletdm", 5000, 1)
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
addVehicle("public", "f350tdm", 32000, 25)
addVehicle("public", "focusrstdm", 38000, 25)
addVehicle("public", "69camarotdm", 47000, 25)
addVehicle("public", "st1tdm", 50000, 25)
addVehicle("public", "chevellesstdm", 52000, 25)
addVehicle("public", "raptorsvttdm", 53000, 25)
addVehicle("public", "camarozl1tdm", 55000, 25)
addVehicle("public", "mustanggttdm", 55000, 25)
addVehicle("public", "coupe40tdm", 60000, 25)
addVehicle("public", "escaladetdm", 80000, 25)
addVehicle("public", "cayenne12tdm", 111000, 25)
addVehicle("public", "cayennetdm", 111000, 25)
addVehicle("public", "h1opentdm", 129000, 25)
addVehicle("public", "997gt3tdm", 130000, 25)
addVehicle("public", "h1tdm", 140000, 25)
addVehicle("public", "gt05tdm", 145000, 25)
addVehicle("public", "carreragttdm", 448000, 25)
addVehicle("public", "918spydtdm", 845000, 25)
addVehicle("public", "eb110tdm", 1600000, 25)
addVehicle("public", "veyrontdm", 1700000, 25)
addVehicle("public", "veyronsstdm", 2700000, 25)

-----------------------------
--	Civil Protection CARS  --
-----------------------------
CarDealer.cars["police"] = {noInventory = true, teams = {8}}
addVehicle("police", "sgmcrownviccvpi", 1000, 10)
addVehicle("police", "sgmcrownvicuc", 1000, 10)
addVehicle("police", "07sgmcrownviccvpi", 1500, 20)
addVehicle("police", "07sgmcrownvicuc", 1500, 20)