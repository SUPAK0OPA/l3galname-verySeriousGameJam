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

global.surf = surface_create(640, 360);

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

global.animCurves = {
	LINEAR : animcurve_get_channel(ac_presets, "lienar"),
	EASEIN : animcurve_get_channel(ac_presets, "easeIn"),
	EASEBACK : animcurve_get_channel(ac_presets, "easeBack"),
	ELASTIC : animcurve_get_channel(ac_presets, "elastic"),
	FASTSLOW : animcurve_get_channel(ac_presets, "fastSlow"),
	EASEINLINEAR : animcurve_get_channel(ac_presets, "easeInLinear"),
}

#endregion