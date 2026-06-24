/// @description Insert description here
var input;
for (var i=0; i<inputLength; i++) {
	input = false;
	for (var j=0; j<array_length(global.keybinds[i]); j++) {
		if (keyboard_check(global.keybinds[i][j])) { input = true; } 
	}
	
	if input { global.inputs[i]++; }
	else { global.inputs[i] = 0; }
}

if keyboard_check_pressed(ord("R")) { game_restart(); }
if (global.inputs[KEYS.FULL] == 1 && (os_type == os_windows || os_type == os_macosx || os_type == os_linux)) {
	fullscreen = 1 - fullscreen;
	window_set_fullscreen(fullscreen);
	window_resize(fullscreen);
}

if mouse_check_button_pressed(mb_left) {
	// Set fps and physics changes
	if (game_get_speed(gamespeed_fps) > 60) {
		game_set_speed(60, gamespeed_fps);
		global.timeSpeed *= 2;
	} else {
		game_set_speed(120, gamespeed_fps);
		global.timeSpeed /= 2;
	}

	with (all) { event_user(0); }
	
	//view_surface_id[0] = -1;
	if instance_exists(obj_player) { obj_player.active = !obj_player.active; }
}

playerExists = instance_exists(obj_player);

//global.screenDir += (2*global.timeSpeed) * (keyboard_check(ord("Z")) - keyboard_check(ord("X")));
if (global.inputs[KEYS.START] == 1 && transFrame == 0) {
	spinDir = 1;
	transFrame = 1;
	if playerExists {
		obj_player.active = false;
		playerPos = [obj_player.x - obj_camera.cameraPos[0], obj_player.y - obj_camera.cameraPos[1]]; // Relative Position to GUI
	}
	screenDirPrev = global.screenDir;
} else if (global.inputs[KEYS.SELECT] == 1 && transFrame == 0) {
	spinDir = -1;
	transFrame = 1;
	if playerExists {
		obj_player.active = false;
		playerPos = [obj_player.x - obj_camera.cameraPos[0], obj_player.y - obj_camera.cameraPos[1]]; // Relative Position to GUI
	}
	screenDirPrev = global.screenDir;
}

// Animate the stage rotation
if (transFrame > 0 && transFrame <= 195) {
	//transFrame += 1 * global.timeSpeed;
	transFrame += 2 * global.timeSpeed;
} else {
	if (playerCollide || (playerExists && instance_place(obj_player.x, obj_player.y, obj_collision))) {
		playerCollide = true;
		transFrame += 2 * global.timeSpeed;
		if (transFrame > 260) {
			playerCollide = false;
			global.screenDir = screenDirPrev;
		}
	} else if (transFrame > 0) {
		transFrame = 0;
		rgbSplit = 0;
		//view_surface_id[0] = -1;
		
		if playerExists { obj_player.active = true; }
		if instance_exists(obj_camera) {
			obj_camera.cameraSpeed = 0.2;
			obj_camera.rShake = 4;
		}
		if instance_exists(obj_collision) {
			with obj_collision {
				repeat 3 { instance_create_layer(bbox_left, y+(sprite_height/2), "Particles", obj_dustFly); }
				repeat 3 { instance_create_layer(bbox_right, y+(sprite_height/2), "Particles", obj_dustFly); }
				repeat 3 { instance_create_layer(x+(sprite_width/2), bbox_top, "Particles", obj_dustFly); }
				repeat 3 { instance_create_layer(x+(sprite_width/2), bbox_bottom, "Particles", obj_dustFly); }
			}
		}
		
		if (abs(global.screenDir) >= 360) { global.screenDir = 0; }
	}
}

#region Stage rotation keyframes

if (transFrame > 0) {
	var _xscale = 1;
	var _yscale = 1;
	var position = 0;
	var animCurve = 0;
	var dist = 0;
	
	//playerExists = instance_exists(obj_player);

	if (transFrame < 50) {
		// Zoom in
		animCurve = global.animCurves.FASTSLOW;
		position = animcurve_channel_evaluate(animCurve, transFrame/45);
		dist = 1.25 - 1;
		if instance_exists(obj_camera) {
			obj_camera.cameraScale = 1 + (dist * position);
			obj_camera.cameraSpeed = 1;
		}
		
		// RGB Split
		dist = 2 - 0;
		rgbSplit = 0 + (dist * position);
	} else if (transFrame < 140) {
		// Rotate stage
		animCurve = global.animCurves.EASEINLINEAR;
		position = animcurve_channel_evaluate(animCurve, (transFrame-50)/60);
		dist = (screenDirPrev+(90*spinDir)) - screenDirPrev;
		global.screenDir = screenDirPrev + (dist * position);
	} else if (transFrame <= 195) {
		// Zoom back out
		global.screenDir = screenDirPrev + (90*spinDir);
		
		animCurve = global.animCurves.EASEBACK;
		position = animcurve_channel_evaluate(animCurve, (transFrame-140)/50);
		dist = 1 - 1.25;
		if instance_exists(obj_camera) {
			obj_camera.cameraScale = 1.25 + (dist * position);
		}
		
		// RGB Split
		dist = 0 - 2;
		rgbSplit = 2 + (dist * position);
		
		// Check if player is stuck
		if playerExists {
			var myself = self;
			with obj_player { myself.playerCollide = place_meeting(x, y, obj_collision); }
		}
		
	} else if playerCollide {
		// Undo if stuck
		animCurve = global.animCurves.FASTSLOW;
		position = animcurve_channel_evaluate(animCurve, (transFrame-210)/60);
		dist = screenDirPrev - (screenDirPrev+(90*spinDir));
		global.screenDir = (screenDirPrev+(90*spinDir)) + (dist * position);
	}
}

#endregion

if (keyboard_check_pressed(vk_space) && playerExists) { instance_create_layer(obj_player.x, obj_player.y, "Particles", obj_dustFly); }