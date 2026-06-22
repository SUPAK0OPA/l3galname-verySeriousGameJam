/// @description Insert description here
switch room {
	case rm_init:
		room = rm_test0;
	break;
	case rm_test0:
		if !instance_exists(obj_camera) { instance_create_layer(0, 0, "Functional", obj_camera); }
	break;
}

global.roomCenterX = room_width/2;
global.roomCenterY = room_height/2;