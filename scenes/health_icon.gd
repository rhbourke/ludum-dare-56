extends TextureRect



func update_health_hud(health):
	texture.region.size.x = health * 32
	if health == 0:
		visible = false
	else:
		visible = true
	
		
