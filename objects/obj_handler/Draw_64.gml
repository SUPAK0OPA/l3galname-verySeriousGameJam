/// @description Debug text and surfaces

var _xscale = 1;
var _yscale = 1;
var position = 0;
var animCurve = 0;
var distX = 0;
var distY = 0;

if (transFrame < 60) {
	animCurve = global.animCurves.FASTSLOW;
	position = animcurve_channel_evaluate(animCurve, transFrame/60);
	distX = 1.5 - 1; distY = 1.5 - 1;
	_xscale = 1 + (distX * position);
	_yscale = 1 + (distY * position);
}

if !surface_exists(global.surf2) { global.surf2 = surface_create(640, 360); }

view_surface_id[0] = global.surf2;

surface_set_target(global.surf2);
//draw_clear_alpha(c_white, 0);
draw_text(0, 0, os_type);
draw_text(0, 20, global.windowSize);
surface_reset_target();

//draw_surface_ext(global.surf2, 0, 0, 1, 1, 0, c_teal, 1);
draw_surface_stretched_ext(global.surf2, global.windowPos[0], global.windowPos[1], global.windowSize[0], global.windowSize[1], c_white, 1);

