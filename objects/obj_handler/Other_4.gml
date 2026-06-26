/// @description Insert description here
switch room {
	case rm_init:
		room = rm_test0;
	break;
	case rm_init2:
		room = rm_stage0;
	break;
	case rm_test0:
	case rm_stage0:
	case rm_stage1:
	case rm_stage2:
		if !instance_exists(obj_camera) { instance_create_layer(0, 0, "Functional", obj_camera); }
		instance_create_layer(0, 0, "Particles", obj_roomTransSlide, { image_xscale : ideal_width, image_yscale : ideal_height });
		rgbSplit = 0;
	break;
}

global.roomCenterX = room_width/2;
global.roomCenterY = room_height/2;

global.cameraTarget = obj_player;
global.cameraClamp = [[1, 1], [1, 1]];
global.playerState = 0;
global.screenDir = 0;
transFrame = 0;
if (roomPrev != room) { timePrev = current_time/10; }
roomPrev = room;