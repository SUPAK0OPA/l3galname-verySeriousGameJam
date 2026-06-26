function bgDraw_gridParalax(_tick){
	// Var Init
	var gap = 30;
	var lineW = (room_width / gap) + 1;
	var lineH = (room_height / gap) + 1;
	
	var colors = [
	#004000,
	#370d40,
	#082a4d,
	#4d2d00
	];
	
	
	var colorCur = merge_colour(colors[floor(_tick/(gap*4))%array_length(colors)], colors[(floor(_tick/(gap*4))+1)%array_length(colors)], (_tick/(gap*4))%1);
	
	draw_sprite_ext(spr_pixel, 0, 0, 0, ideal_width, ideal_height, 0, merge_color(colorCur, #595959, 0.9), 1);
	
	var i = 0;
	for (i=0; i<lineW; i++;) {
		draw_sprite_ext(spr_pixel, 0, (_tick%gap) + (i*gap), 0, 1, self.ideal_height, 0, colorCur, 1);
		draw_sprite_ext(spr_pixel, 0, ((_tick*2)%gap) + (i*gap), 0, 1, self.ideal_height, 0, colorCur, 1);
	}
	
	for (i=0; i<lineH; i++;) {
		draw_sprite_ext(spr_pixel, 0, 0, (_tick%gap) + (i*gap), self.ideal_width, 1, 0, colorCur, 1);
		draw_sprite_ext(spr_pixel, 0, 0, ((_tick*2)%gap) + (i*gap), self.ideal_width, 1, 0, colorCur, 1);
	}
}