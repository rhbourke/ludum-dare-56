extends TextureRect

var cheese = 0

func update_cheese_hud(amount_of_cheese):
	visible = true
	texture.region.size.x = amount_of_cheese * 32
	
		
