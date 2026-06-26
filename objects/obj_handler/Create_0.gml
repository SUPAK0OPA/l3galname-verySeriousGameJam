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
global.keybinds[7] = [ord("C"), vk_tab];

inputLength = array_length(global.keybinds);
global.inputs = array_create(inputLength);
for (var i=0; i<inputLength; i++) {
	global.inputs[i] = 0;
}

enum KEYS { UP, LEFT, DOWN, RIGHT, START, FULL, SELECT, ALT }

#endregion

#region Camera

//global.cameraTarget = obj_player;
global.cameraTarget = obj_player;
global.camera = undefined;
global.cameraClamp = [[1, 1], [1, 1]]; // Room x and y clamping
global.shake = [true, true]; // horizontal and vertical shake toggle
global.shakeTick = 100;

//// Scaling
fullscreen = 0;
ideal_width = 256;
ideal_height = 224;

////// Check for odd number
if(ideal_width mod 2 = 1) { ideal_width += 1 }
if(ideal_height mod 2 = 1) { ideal_height += 1 }

var _w = display_get_width();
var _h = display_get_height();

//aspect = _w / ideal_width;
aspect = _h / ideal_height;

global.windowSize = [0, 0];
global.windowPos = [0, 0];

function window_resize(full) {
	if full {
		global.windowSize[0] = ceil(ideal_width * aspect);
		global.windowSize[1] = ceil(ideal_height * aspect);
		
		global.windowPos[0] = floor((display_get_width()/2) - (global.windowSize[0]/2));
		global.windowPos[1] = floor((display_get_height()/2) - (global.windowSize[1]/2))
	} else {
		global.windowSize[0] = ideal_width*2;
		global.windowSize[1] = ideal_height*2;
		
		global.windowPos[0] = 0;
		global.windowPos[1] = 0;
	}
}

window_resize(fullscreen);

application_surface_enable(false);
global.surf2 = -1;
surfBG = -1;
bgTick = 0;
bgTickSpeed = 1/2;
//global.surf2 = surface_create(640, 360);


#endregion

#region Stage rotation

global.screenDir = 0;
global.roomCenterX = 0;
global.roomCenterY = 0;

transFrame = 0;
spinDir = 0;
screenDirPrev = 0;

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
	EASEOUT : animcurve_get_channel(ac_presets, "easeOut")
}

playerPos = [0, 0];
playerCollide = false;
playerExists = 0;

// RGB Splite on the drawn surface
rgbSplit = 0;
rgbTick = 2;
rgbSpin = 0;

timePrev = 0;
roomPrev = 0;

global.playerState = 0; // 0 for alive, 1 for win, 2 for lose

////ALL FONT CHARACTERS IN ORDER DO NOT TOUCH
#macro soup " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"

#endregion