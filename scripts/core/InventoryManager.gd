extends Node

func add_item(inventory_data: InventoryData, item: ItemData, quantity: int = 1):
	if inventory_data:
		var dict = inventory_data.content
		
		if dict.has(item):
			dict[item] += quantity
		else:
			dict[item] = quantity
			
		print("added ", item.item_name, ". total: ", dict[item])
	else:
		push_error("InventoryManager has no InventoryData assigned!")
