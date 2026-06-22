/// @description Insert description here
if (global.cameraTarget == undefined || !instance_exists(global.cameraTarget)) { global.cameraTarget = obj_camera; }
cameraTarget = global.cameraTarget;

var targetX = cameraTarget.x - (cameraW/2);
var targetY = cameraTarget.y - (cameraH/2);

// Clamp to the room
if (global.cameraClamp[0][0] && targetX < 0) {
	targetX = 0;
} else if (global.cameraClamp[0][1] && targetX + cameraW > room_width) {
	targetX = room_width - cameraW;
}

if (global.cameraClamp[1][0] && targetY< 0) {
	targetY = 0;
} else if (global.cameraClamp[1][1] && targetY + cameraH > room_height) {
	targetY = room_height - cameraH;
}

cameraPos = [lerp(cameraPos[0], targetX, cameraSpeed), lerp(cameraPos[1], targetY, cameraSpeed)];

camera_set_view_pos(global.camera, cameraPos[0], cameraPos[1]);