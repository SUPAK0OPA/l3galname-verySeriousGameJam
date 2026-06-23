/// @description Variable Init
#region Keybinds

global.keybinds = array_create(4);
global.keybinds[0] = [ord("W"), vk_up, vk_space];
global.keybinds[1] = [ord("A"), vk_left];
global.keybinds[2] = [ord("S"), vk_down];
global.keybinds[3] = [ord("D"), vk_right];
global.keybinds[4] = [ord("Z"), vk_enter];
global.keybinds[5] = [ord("F")];
global.keybinds[6] = [ord("X"), vk_shift];

inputLength = array_length(global.keybinds);
global.inputs = array_create(inputLength);
for (var i=0; i<inputLength; i++) {
	global.inputs[i] = 0;
}

enum KEYS { UP, LEFT, DOWN, RIGHT, START, FULL, SELECT }

#endregion

#region Camera

//global.cameraTarget = obj_player;
global.cameraTarget = obj_player;
global.camera = undefined;
global.cameraClamp = [[1, 1], [1, 1]]; // Room x and y clamping

//// Scaling
fullscreen = 0;
ideal_width = 640;
ideal_height = 360;

////// Check for odd number
if(ideal_width mod 2 = 1) { ideal_width += 1 }
if(ideal_height mod 2 = 1) { ideal_height += 1 }

var _w = display_get_width();
var _h = display_get_height();

aspect = _w / ideal_width;

global.windowSize = [0, 0];
global.windowPos = [0, 0];

function window_resize(full) {
	if full {
		global.windowSize[0] = ceil(ideal_width * aspect);
		global.windowSize[1] = ceil(ideal_height * aspect);
		
		global.windowPos[0] = floor((display_get_width()/2) - (global.windowSize[0]/2));
		global.windowPos[1] = floor((display_get_height()/2) - (global.windowSize[1]/2))
	} else {
		global.windowSize[0] = ideal_width;
		global.windowSize[1] = ideal_height;
		
		global.windowPos[0] = 0;
		global.windowPos[1] = 0;
	}
}

window_resize(fullscreen);

application_surface_enable(false);
global.surf2 = -1;
//global.surf2 = surface_create(640, 360);


#endregion

#region Stage rotation

global.screenDir = 0;
global.roomCenterX = 0;
global.roomCenterY = 0;

transFrame = 0;
spinDir = 0;

#endregion

#region Miscellaneous

global.timeSpeed = 1;

window_enable_borderless_fullscreen(true);

// animCurve distance is end - start, realPosition is start + (distance * position) //
global.animCurves = {
	LINEAR : animcurve_get_channel(ac_presets, "lienar"),
	EASEIN : animcurve_get_channel(ac_presets, "easeIn"),
	EASEBACK : animcurve_get_channel(ac_presets, "easeBack"),
	ELASTIC : animcurve_get_channel(ac_presets, "elastic"),
	FASTSLOW : animcurve_get_channel(ac_presets, "fastSlow"),
	EASEINLINEAR : animcurve_get_channel(ac_presets, "easeInLinear"),
}

#endregion