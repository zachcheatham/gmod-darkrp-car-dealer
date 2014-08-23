if not CarDealer then
	CarDealer = {}
end

function CarDealer.getCarDetails(type, id)
	for _, v in ipairs(CarDealer.cars[type].cars) do
		if v.id == id then
			return v
		end
	end
end