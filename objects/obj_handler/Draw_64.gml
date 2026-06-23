/// @description Debug text and surfaces

var playerExists = 0;

if (transFrame > 0) {
	var _xscale = 1;
	var _yscale = 1;
	var position = 0;
	var animCurve = 0;
	var dist = 0;
	//var distX = 0;
	//var distY = 0;
	
	playerExists = instance_exists(obj_player);

	if (transFrame < 50) {
		// Zoom in
	
		animCurve = global.animCurves.FASTSLOW;
		position = animcurve_channel_evaluate(animCurve, transFrame/45);
		dist = 1.25 - 1;
		//distX = 1.5 - 1; distY = 1.5 - 1;
		if instance_exists(obj_camera) {
			obj_camera.cameraScale = 1 + (dist * position);
			obj_camera.cameraSpeed = 1;
			//_yscale = 1 + (distY * position);
		}
		//_xscale = 1 + (distX * position);
		//_yscale = 1 + (distY * position);
	} else if (transFrame < 140) {
		// Rotate stage
		//playerExists = instance_exists(obj_player);
	
		animCurve = global.animCurves.EASEINLINEAR;
		position = animcurve_channel_evaluate(animCurve, (transFrame-50)/60);
		dist = (screenDirPrev+(90*spinDir)) - screenDirPrev;
		global.screenDir = screenDirPrev + (dist * position);
	} else if (transFrame <= 210) {
		// Zoom back out
		//playerExists = instance_exists(obj_player);
		
		global.screenDir = screenDirPrev + (90*spinDir);
		
		animCurve = global.animCurves.EASEBACK;
		position = animcurve_channel_evaluate(animCurve, (transFrame-140)/50);
		dist = 1 - 1.25;
		if instance_exists(obj_camera) {
			obj_camera.cameraScale = 1.25 + (dist * position);
		}
		
		
		if playerExists {
			var myself = self;
			with obj_player { myself.playerCollide = place_meeting(x, y, obj_collision); }
		}
	} else if playerCollide {
		// Undo if stuck
		//playerExists = instance_exists(obj_player);
		
		animCurve = global.animCurves.FASTSLOW;
		position = animcurve_channel_evaluate(animCurve, (transFrame-210)/60);
		dist = screenDirPrev - (screenDirPrev+(90*spinDir));
		global.screenDir = (screenDirPrev+(90*spinDir)) + (dist * position);
	}
}

if !surface_exists(global.surf2) { global.surf2 = surface_create(ideal_width, ideal_height); }

view_surface_id[0] = global.surf2;

surface_set_target(global.surf2);
//draw_clear_alpha(c_white, 0);
if playerExists {
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
draw_text(0, 0, transFrame);
draw_text(0, 20, global.screenDir);
surface_reset_target();

//draw_surface_ext(global.surf2, 0, 0, 1, 1, 0, c_teal, 1);
draw_surface_stretched_ext(global.surf2, global.windowPos[0], global.windowPos[1], global.windowSize[0], global.windowSize[1], c_white, 1);

