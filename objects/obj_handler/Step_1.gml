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
	//if instance_exists(obj_player) { obj_player.active = !obj_player.active; }
}

playerExists = instance_exists(obj_player);

switch global.playerState {
	case 1:
		var position = 0;
		var animCurve = 0;
		var dist = 0;
		
		if (transFrame < 180) {
			transFrame += 1 * global.timeSpeed;
			// Zoom in
			animCurve = global.animCurves.LINEAR;
			position = animcurve_channel_evaluate(animCurve, (transFrame-90)/60);
			dist = 2 - 0;
			rgbSplit = 0 + (dist * position);
			
			//if instance_exists(obj_camera) {
			//	obj_camera.cameraScale = 1 + (dist * position);
			//	obj_camera.cameraSpeed = 1;
			//	obj_camera.x = obj_camera.cameraTarget.x;
			//	obj_camera.y = obj_camera.cameraTarget.y;
			//}
		}
	break;
	case 2:
		var position = 0;
		var animCurve = 0;
		var dist = 0;
		
		if (transFrame < 30) {
			transFrame += 1 * global.timeSpeed;
			// Zoom in
			animCurve = global.animCurves.EASEOUT;
			position = animcurve_channel_evaluate(animCurve, transFrame/25);
			dist = 1.25 - 1;
			if instance_exists(obj_camera) {
				obj_camera.cameraScale = 1 + (dist * position);
				obj_camera.cameraSpeed = 1;
				obj_camera.x = obj_camera.cameraTarget.x;
				obj_camera.y = obj_camera.cameraTarget.y;
				obj_camera.rShake = 2;
			}
		} else {
			transFrame += 1 * global.timeSpeed;
			// Zoom out
			animCurve = global.animCurves.EASEIN;
			position = animcurve_channel_evaluate(animCurve, (transFrame-30)/40);
			dist = 0.9 - 1.25;
			global.cameraClamp = [[0, 0], [0, 0]];
			global.cameraTarget = obj_camera;
			if instance_exists(obj_camera) {
				obj_camera.cameraScale = 1.25 + (dist * position);
				obj_camera.cameraSpeed = 0.2;
			}
			
			if (playerExists) {
				if (obj_player.image_alpha <= 0) { room_restart(); }
			}
		}
	break;
	case 0:
		#region Control stage rotation
		
		if (global.inputs[KEYS.ALT] > 0 && instance_exists(obj_camera) && (transFrame < 0 || (playerExists && obj_player.active))) {
			transFrame += -1 * global.timeSpeed;
			if playerExists { obj_player.active = false; }
		} else if (global.inputs[KEYS.START] == 1 && transFrame == 0) {
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

		// Animate the stage
		if (transFrame < 0) {
			// Zoom out
			var animCurve = global.animCurves.EASEIN;
			var position = animcurve_channel_evaluate(animCurve, abs(transFrame/-20));
			var dist = (ideal_height / room_height) - 1;
			
			global.cameraClamp = [[0, 0], [0, 0]];
			if instance_exists(obj_camera) {
				obj_camera.cameraScale = 1 + (dist * position);
				obj_camera.cameraSpeed = 0.8;
				obj_camera.x = room_width/2;
				obj_camera.y = room_height/2;
				global.cameraTarget = obj_camera;
			}
			
			// Reset
			if (global.inputs[KEYS.ALT] == 0) {
				global.cameraTarget = obj_player;
				global.cameraClamp = [[1, 1], [1, 1]];
				obj_camera.cameraScale = 1;
				obj_camera.cameraSpeed = 1;
				transFrame = 0;
				
				if playerExists { obj_player.active = true; }
			}
			
		} else if (transFrame > 0 && transFrame <= 195) {
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
		
				if instance_exists(obj_semisolid) {
					with obj_semisolid {
						repeat 3 { instance_create_layer(bbox_left, y+(sprite_height/2), "Particles", obj_dustFly); }
						repeat 3 { instance_create_layer(bbox_right, y+(sprite_height/2), "Particles", obj_dustFly); }
						repeat 3 { instance_create_layer(x+(sprite_width/2), bbox_top, "Particles", obj_dustFly); }
						repeat 3 { instance_create_layer(x+(sprite_width/2), bbox_bottom, "Particles", obj_dustFly); }
					}
				}
		
				if (abs(global.screenDir) >= 360) { global.screenDir = 0; }
			}
		}

		#endregion

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
					with obj_player { myself.playerCollide = place_meeting(x, y, obj_collision) || place_meeting(x, y, obj_evilSpinner); }
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
	break;
}

bgTick += bgTickSpeed * global.timeSpeed;
if (bgTick >= 65535) { bgTick -= 65535; }