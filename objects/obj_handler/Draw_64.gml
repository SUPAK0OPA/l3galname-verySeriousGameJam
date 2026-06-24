/// @description Debug text and surfaces
if !surface_exists(global.surf2) { global.surf2 = surface_create(ideal_width, ideal_height); }

view_surface_id[0] = global.surf2;

surface_set_target(global.surf2);

if (transFrame > 0 && playerExists) {
	// Draw Player
	if playerCollide {
		var xShake = 0
		if (transFrame > 210) {
			draw_sprite_ext(spr_pixel, 0, 0, 0, ideal_width, ideal_height, 0, c_red, clamp(((transFrame-210)/30), 0, 0.4))
			xShake = ((270-transFrame)/(60/6)) * sin((transFrame-210)/2);
		}
		draw_sprite(spr_playerMan, 0, playerPos[0] + xShake, playerPos[1]);
	} else {
		draw_sprite(spr_playerMan, 0, playerPos[0], playerPos[1]);
	}
}

//draw_text(0, 0, fps_real);
draw_text(0, 20, global.screenDir);

surface_reset_target();

if (rgbSplit == 0) {
	rgbSpin = 0
	draw_surface_stretched_ext(global.surf2, global.windowPos[0], global.windowPos[1], global.windowSize[0], global.windowSize[1], c_white, 1);
} else {
	rgbSpin += rgbTick * global.timeSpeed;
	var scale = global.windowSize[1] / ideal_height;
	
	gpu_set_colourwriteenable(1, 0, 0, 1);
	draw_surface_stretched_ext(global.surf2, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	gpu_set_colourwriteenable(0, 1, 0, 1);
	draw_surface_stretched_ext(global.surf2, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin+120))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin+120))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	gpu_set_colourwriteenable(0, 0, 1, 1);
	draw_surface_stretched_ext(global.surf2, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin+240))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin+240))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	gpu_set_colourwriteenable(1, 1, 1, 1);
}
