shader_type canvas_item;
uniform sampler2D cut_mask;
uniform sampler2D add_mask;

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
	vec4 color = texture(cut_mask, UV);
	vec4 color_2 = texture(add_mask, UV);
	
	if (all(equal(white, color)))// && not(equal(white, color_2)))
	{
		//COLOR.b = 1.0;
		//COLOR.p = 1.0;
		COLOR.a = 0.0;
	}
	
	if (all(equal(white, color_2)))
	{
		//COLOR.r = 1.0;
		// We will be sampling the add mask here and not the texture
		COLOR = texture(TEXTURE, UV);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
