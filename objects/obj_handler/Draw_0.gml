if !surface_exists(surfBG) { surfBG = surface_create(ideal_width, ideal_height); }
if !surface_exists(global.surf2) { global.surf2 = surface_create(ideal_width, ideal_height); }

#region draw shadows

surface_set_target(global.surf2);
draw_clear_alpha(c_white, 0); // Clear main surface because background is transparent

if instance_exists(obj_collisionBlock) {
	with obj_collisionBlock { draw_sprite_ext(sprite_index, 0, x-4, y+4, image_xscale, image_yscale, image_angle, c_black, 0.9); }
}

if playerExists {
	if obj_player.active {
		with obj_player { draw_sprite_ext(sprite_index, 0, x-4, y+4, image_xscale, image_yscale, image_angle, c_black, 0.9*image_alpha); }
	} else if (transFrame <= 0) {
		with obj_player { draw_self(); }
	}
} 

if instance_exists(obj_evilSpinner) {
	with obj_evilSpinner {
		draw_sprite_ext(sprite_index, 0, x-4, y+4, image_xscale, image_yscale, image_angle+dirReal, c_black, 0.9);
		draw_sprite_ext(sprite_index, 0, x-4, y+4, image_xscale, image_yscale, image_angle+((dirReal+15)*-1), c_black, 0.9);
	}
}

if instance_exists(obj_winSpinner) {
	with obj_winSpinner {
		draw_sprite_ext(sprite_index, 0, x-4, y+4, image_xscale, image_yscale, image_angle+(dirReal*1.2), c_black, 0.9);
		draw_sprite_ext(sprite_index, 0, x-4, y+4, image_xscale, image_yscale, image_angle+dirReal, c_black, 0.9);
	}
}

surface_reset_target();

#endregion

surface_set_target(surfBG);
draw_clear_alpha(c_white, 0);

bgDraw_gridParalax(bgTick);

surface_reset_target();