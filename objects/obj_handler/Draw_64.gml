/// @description Debug text and surfaces
if !surface_exists(global.surf2) { global.surf2 = surface_create(ideal_width, ideal_height); }
//if !surface_exists(surfBG) { surfBG = surface_create(ideal_width, ideal_height); }

view_surface_id[0] = global.surf2;

#region Background drawing
surface_set_target(surfBG);

if (transFrame > 0 && playerExists && global.playerState == 0) {
	// Draw Player
	if playerCollide {
		var xShake = 0
		if (transFrame > 210) {
			draw_sprite_ext(spr_pixel, 0, 0, 0, ideal_width, ideal_height, 0, c_red, clamp(((transFrame-210)/30), 0, 0.4))
			xShake = ((270-transFrame)/(60/6)) * sin((transFrame-210)/2);
		}
		draw_sprite_ext(spr_mrGuy, 0, playerPos[0] + xShake - 4, playerPos[1] + 4, 1, 1, 0, c_black, 0.9);
		draw_sprite(spr_mrGuy, 0, playerPos[0] + xShake, playerPos[1]);
	} else {
		draw_sprite_ext(spr_mrGuy, 0, playerPos[0] - 4, playerPos[1] + 4, 1, 1, 0, c_black, 0.9);
		draw_sprite(spr_mrGuy, 0, playerPos[0], playerPos[1]);
	}
}

//draw_text(0, 20, global.screenDir);

surface_reset_target();
#endregion

surface_set_target(global.surf2);

//draw_clear_alpha(c_white, 0);

if (global.playerState == 1 && playerExists) {
	var _player = obj_player;
	draw_sprite_ext(spr_mrGuy, 0, playerPos[0], playerPos[1], _player.image_xscale, _player.image_yscale, _player.image_angle, c_white, _player.image_alpha);
}

if instance_exists(obj_roomTransSlide) {
	var _idealW = ideal_width;
	var _idealH = ideal_height;
	with obj_roomTransSlide {
		draw_sprite_ext(sprite_index, 0, 0 + (dist * position), 0, image_xscale*1.5, image_yscale, -45, c_black, 1);
		draw_sprite_ext(sprite_index, 0, 0 + ((dist*-1) * position), 0, image_xscale*1.5, image_yscale*-1, -45, c_black, 1);
	}
}

if instance_exists(obj_roomTransFade) {
	var _idealW = ideal_width;
	var _idealH = ideal_height;
	with obj_roomTransFade { draw_sprite_ext(spr_pixel, 0, 0, 0, _idealW, _idealH, 0, color, image_alpha); }
}

//draw_txt(0, 0, ideal_height / room_height);

if (global.playerState == 0) {
	draw_sprite_ext(spr_ditherBanner, 0, 0, 10, 4, 1, 0, c_black, 0.85);

	var time = floor((current_time/10) - timePrev);
	var hours = floor((time/100) / (60 * 60));
	time -= (hours * 60 * 60)*100;
	//var minutes = 0;
	var minutes = floor((time/100) / 60);
	time -= (minutes * 60)*100;
	var seconds = floor(time/100);
	time -= seconds*100;
	draw_txt(12, 12, $"{hours}:{minutes}:{seconds}:{time}");

	draw_sprite_ext(spr_ditherBanner, 0, 0, 26, 3, 1, 0, c_black, 0.85);

	var roomName = room_get_name(room);
	var strRemain = string_length(roomName) - string_length("rm_stage");
	draw_txt(12, 28, $"STAGE {1 + string_copy(roomName, string_length("rm_stage")+1, strRemain)}");
}

surface_reset_target();

if (rgbSplit == 0) {
	rgbSpin = 0
	
	draw_surface_stretched_ext(surfBG, global.windowPos[0], global.windowPos[1], global.windowSize[0], global.windowSize[1], c_white, 1);
	draw_surface_stretched_ext(global.surf2, global.windowPos[0], global.windowPos[1], global.windowSize[0], global.windowSize[1], c_white, 1);
} else {
	rgbSpin += rgbTick * global.timeSpeed;
	var scale = global.windowSize[1] / ideal_height;
	
	gpu_set_colourwriteenable(1, 0, 0, 1);
	draw_surface_stretched_ext(surfBG, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	draw_surface_stretched_ext(global.surf2, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	gpu_set_colourwriteenable(0, 1, 0, 1);
	draw_surface_stretched_ext(surfBG, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin+120))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin+120))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	draw_surface_stretched_ext(global.surf2, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin+120))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin+120))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	gpu_set_colourwriteenable(0, 0, 1, 1);
	draw_surface_stretched_ext(surfBG, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin+240))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin+240))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	draw_surface_stretched_ext(global.surf2, global.windowPos[0] + ((rgbSplit*dcos(rgbSpin+240))*scale), global.windowPos[1] + ((rgbSplit*dsin(rgbSpin+240))*scale), global.windowSize[0], global.windowSize[1], c_white, 1);
	gpu_set_colourwriteenable(1, 1, 1, 1);
}
