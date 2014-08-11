CarDealer.inventory = {}

net.Receive("CarDealer_Inventory", function(len)
	CarDealer.inventory = net.ReadTable()
end)