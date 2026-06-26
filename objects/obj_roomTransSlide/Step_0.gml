position = animcurve_channel_evaluate(animCurve, animFrame);
animFrame += animSpeed;
if (animFrame > 1) {
	if instance_exists(obj_player) { obj_player.active = true; }
	instance_destroy();
}