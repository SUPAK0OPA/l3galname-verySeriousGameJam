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
if (global.inputs[KEYS.FULL] == 1) { window_set_fullscreen(!window_get_fullscreen()); }

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
	
	view_surface_id[0] = -1;
	if instance_exists(obj_player) { obj_player.active = !obj_player.active; }
}

//global.screenDir += (2*global.timeSpeed) * (keyboard_check(ord("Z")) - keyboard_check(ord("X")));
if (global.inputs[KEYS.START] == 1 && transFrame == 0) {
	spinDir = 1;
	transFrame = 1;
} else if (global.inputs[KEYS.SELECT] == 1 && transFrame == 0) {
	spinDir = -1;
	transFrame = 1;
}