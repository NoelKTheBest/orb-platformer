extends Sprite2D

@export var overlay_image: Texture2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# I am using this to try to blit the image onto the texture
	# I wonder if the animation player isn't doing it right or 
	# if I messed up with the blit_rect function
	if overlay_image:
		#print(overlay_image.get_size())
		#print(texture.get_size())
		
		var image = texture.get_image()
		var new_texture
		
		image.blit_rect(overlay_image.get_image(), Rect2i(Vector2i(0, 0), overlay_image.get_size()), Vector2i(0, 0))
		new_texture = ImageTexture.create_from_image(image)
		texture = new_texture
		
		$"../UserInterface/Sprite2D".texture = texture
		
	#else:
		#print("ahoy")


func _draw() -> void:
	#var image = texture.get_image()
	#var new_texture
	#
	#if overlay_image:
		#image.blit_rect(overlay_image.get_image(), Rect2i(0, 0, 448, 196), Vector2i(0, 0))
		#new_texture = ImageTexture.create_from_image(image)
		#texture = new_texture
	pass
	
