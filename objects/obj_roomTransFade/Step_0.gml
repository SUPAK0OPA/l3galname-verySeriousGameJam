position = animcurve_channel_evaluate(animCurve, animFrame);
if (image_alpha >= 1) {
	color = merge_colour(c_white, c_black, 0 + (dist * position));
	image_alpha = 1;
} else {
	image_alpha = 0 + (dist * position);
}

animFrame += animSpeed;
if (animFrame > 1) {
	if (animCurve = global.animCurves.LINEAR) {
		animFrame = 0;
		animCurve = global.animCurves.FASTSLOW;
		animSpeedOG = 1/90;
		event_user(0);
	} else {
		if (animFrame > 1.25) {
			var roomName = room_get_name(room);
			var strRemain = string_length(roomName) - string_length("rm_stage");
			room = asset_get_index( $"rm_stage{1 + (string_copy(roomName, string_length("rm_stage")+1, strRemain))}" );
			instance_destroy();
		}
	}
}