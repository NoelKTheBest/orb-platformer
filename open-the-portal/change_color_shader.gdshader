shader_type canvas_item;
uniform sampler2D cut_mask;
uniform sampler2D add_mask;
uniform sampler2D color_mask;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	// How to change the color of only one pixel
	//COLOR = texture(image, vec2(0.015, 0.0));
	//COLOR = texture(image, vec2(ivec2(0, 0)));
	//COLOR = texelFetch(image, ivec2(0, 0), 0);
	vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 blank = vec4(0.0, 0.0, 0.0, 0.0);
	vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 color_cm = texture(cut_mask, UV);
	vec4 color_am = texture(add_mask, UV);
	
	// make every pixel inside the mask blank
	if (all(equal(white, color_cm)))// && not(equal(white, color_2)))
	{
		//COLOR.a = 0.0;
		COLOR = blank;
	}
	// make every other pixel outside the mask white
	//else if (all(equal(black, color))){
		//COLOR = white;
	//}
	
	
	
	if (all(notEqual(blank, color_am)))
	{
		// We will be sampling the add mask here and not the texture
		COLOR = texture(add_mask, UV);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
