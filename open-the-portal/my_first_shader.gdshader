shader_type canvas_item;
uniform float blue = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += vec2(10.0, 0.0);

	// Animate Sprite2D moving in big circle around its location
	VERTEX += vec2(cos(TIME)*100.0, sin(TIME)*100.0);
}

void fragment() {
	// Called for every pixel the material is visible on.

	//COLOR = vec4(0.2, 0.7, 0.1, 1.0);
	COLOR = vec4(UV, 1.0, 0.4);
	// This shader will result in a blue-tinted icon
	//COLOR.b = 1.0;

	//COLOR = texture(TEXTURE, UV); // Read from texture again.
	COLOR.b = blue; //set blue channel to 1.0
	//COLOR = vec4(UV, 1.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
