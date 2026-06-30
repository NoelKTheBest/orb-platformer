shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR = vec4(UV, 0.5, 1.0);
	//COLOR = vec4(1.0, UV, 1.0);
	//COLOR = vec4(1.0, 1.0, UV);
	//vec4 = (r, g, b, a)
	//COLOR = vec4(UV.x, UV.y, 1.0, 1.0);
	//COLOR = vec4(1.0, UV.x, UV.y, 1.0);
	COLOR = vec4(1.0, 1.0, UV.x, UV.y);

	//// UV.g and UV.t have the same effect, but are not the same
	//COLOR = vec4(UV.g);
	//COLOR = vec4(UV.t);
	//
	//// UV.r and UV.s have the same effect, but are not the same
	//COLOR = vec4(UV.r);
	//COLOR = vec4(UV.s);

	//UV.x;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
